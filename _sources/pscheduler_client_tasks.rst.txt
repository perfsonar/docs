***************************************
Creating and Managing Tasks
***************************************

.. _pscheduler_client_tasks-taskcmd:

The `task` command
-------------------

The `pscheduler task` command is the primary way from the command-line to create new pScheduler :term:`tasks<task>`. It takes the following form::

    pscheduler task [ TASK_OPTIONS ] TEST_TYPE TEST_OPTIONS

.. _pscheduler_client_tasks-basics:

The Basics
----------

The simplest task that can be run is a one-shot test with no special options, such as this one which conducts a round-trip time (*rtt*) test between the local host and *www.perfsonar.net*, then displays the results::

    pscheduler task rtt --dest www.perfsonar.net

Note that the ``--dest`` option following ``rtt`` is a :term:`test` option specific to the test type being requested.  Each test has its own set of options, so what follows the test type will vary.  Most tests that have an option in common that serves the same purpose have consistent names between them.  For example, many tests that involve sending data to another host (*rtt*, *trace*, *throughput*, *latency*) will specify the other hosts using the ``--dest`` option.

The ``task`` command has a set of its own options that go before the test type.  These options are related to how the task is run rather than what test is being conducted.  For example, the ``--quiet`` switch suppresses the diagnostic information that is usually produced::

    pscheduler task --quiet rtt --dest www.perfsonar.net

.. note:: You can get a full listing of supported task options by running ``pscheduler task --help``. Likewise you can get a full listing of test-specific options by running ``pscheduler task TEST_TYPE --help`` where ``TEST_TYPE`` is replaced with the type of test you want to run.

.. _pscheduler_client_tasks-otherhosts:

Running Tests from Other Hosts
------------------------------

pScheduler determines where to submits a task based on the test parameters. Where a task needs to be submitted is called the :term:`lead participant`. For many tests run by perfSONAR, a ``--source`` switch which specifies where the test should originate and is also the *lead participant*::

    pscheduler task throughput --source host2 --dest host3

If the example command above is run on *host1*, then the client will submit the task to *host2* and the test will be run between *host2* and *host3*. 

Not all tests use the source to calculate the lead participant and determining it can get complicated when dealing with things like BWCTL backward compatibility, etc. Luckily, each test plug-in installed on a pScheduler server has the logic required to calculate the lead in the face of this complexity. This does mean though, that the ``pscheduler`` command needs to be able to ask a pScheduler server, called the :term:`assist server`, where a task needs to be submitted. 

By default, the ``pscheduler`` command will assume there is a pScheduler server running on the local host and try to contact that as the default assist server. If there is NOT a pScheduler server on the local host, then you need to use the ``--assist`` flag. For example, say we run the following on *host4* and it does not have a pScheduler server but we know that *host1* does. Our command could be as follows::

    pscheduler task --assist host1 throughput --source host2 --dest host3
    
The assist server could just as easily be ``host2`` or ``host3`` if they are also running pScheduler servers. It does not matter where the assist server is as long as it a) has a pScheduler server and b) has the test plugin installed for the type of test you want to run. 


.. _pscheduler_client_tasks-tools:

Selecting Tool(s) for Tasks
---------------------------

By default, pScheduler will automatically select a tool for a task based on three factors:

    #. Availability of tools on each of the participating nodes that can conduct the type of test requested.
    #. The ability of those tools to carry out the test according to the parameters.  Not all tools are capable of making good on all of the parameters.  For example, *traceroute* is capable of setting the number of hops allowed by adjusting the time to live but *tracepath* is not.  In a *trace* test where this is requested, *traceroute* will list itself as able to participate but *tracepath* will not.
    #. A preference value hard-wired into each tool by its authors.  If multiple tools can carry out a task as requested, pScheduler will select one with the highest preference value or, in the event of a tie, the one that is alphabetically first.  The preference value is used to promote the use of newer, better tools while still keeping older, deprecated tools available for situations where they're required.

Using the ``--tool`` switch, the user can control what tool(s) pScheduler selects for a task::

    pscheduler task --tool tracepath trace --dest www.perfsonar.net

This will specify that the ``tracepath`` tool should be used for running the test.  Similarly, repeating the switch forms a list of acceptable tools with those specified earlier being preferred over those specified later.  For example::

    pscheduler task --tool tracepath --tool paris-traceroute trace --dest www.perfsonar.net

Whether or not tools are specified, a task where no available tool is capable of making the measurement will be rejected.

.. _pscheduler_client_tasks-repeating:

Repeating Tasks
------------------

Any pScheduler task can be configured to run repeatedly by adding options to the ``task`` command:

    * ``--start TIMESTAMP`` - Run the first iteration of the task at _timestamp_.
    * ``--repeat DURATION`` - Repeat runs at intervals of ``DURATION``.
    * ``--repeat-cron CRONSPEC`` - Repeat runs cron(8)-style according to ``CRONSPEC``.  ``CRONSPEC`` is a `POSIX-standard cron entry specification <https://pubs.opengroup.org/onlinepubs/9699919799/utilities/crontab.html>`_  without a shell command attached (e.g., ``0,20,40 * * * 1-5`).
    * ``--max-runs N`` - Allow the task to run up to ``N`` times.
    * ``--until TIMESTAMP`` - Repeat runs of the task until ``TIMESTAMP``.
    * ``--slip DURATION`` - Allow the start of each run to be as much as ``DURATION`` later than their ideal scheduled time.  If the environment variable *PSCHEDULER_SLIP* is present, its value will be used as a default, and.  Failing that, the default will be ``PT5M``.  (Note that the slip value also applies to non-repeating tasks.)
    * ``--sliprand`` - Randomly choose a timeslot within the allowed slip instead of choosing earliest available
    
For example, to measure round-trip time 50 times once per hour::

    pscheduler task --repeat PT1H --max-runs 50 rtt --dest www.perfsonar.net

For example, to measure round-trip time at zero, 20 and 40 minutes past the top of each hour on weekdays::

    pscheduler task --repeat-cron "0,20,40 * * * 1-5" rtt --dest www.perfsonar.net


Note that ``--repeat`` and ``--repeat-cron`` may be used in the same task but their behavior together will be complex hard to predict easily.  Use of both at the same time is not recommended.


It is strongly recommended that repeating tasks apply as much slip as is tolerable to allow pScheduler to work around scheduling conflicts.  Larger slip values will will give tasks a better chance of executing.  For example::
  
    pscheduler task --repeat PT1H --slip PT30M rtt --dest www.perfsonar.net

Repeating tasks can be stopped using the ``cancel`` command.

.. _pscheduler_client_tasks-archiving:

Archiving Tasks
------------------
You can tell the ``pscheduler`` command to send results to an :term:`archiver` using the ``--archive`` switch. The definition you give the archiver can take two forms:

    #. A filename starting with the @ symbol that points at a file containing a JSON archiver specification.
    #. A string literal of the JSON archiver specification

For example, the *perfsonar-core* and *perfsonar-toolkit* bundles install a special file at */usr/share/pscheduler/psc-archiver-esmond.json* with an archiver specification for writing to the locally running esmond instance. You could then use that file to publish a *trace* test (or any other test) to the local MA instance with the following command::

    pscheduler task --archive @/usr/share/pscheduler/psc-archiver-esmond.json trace --dest www.perfsonar.net
    
Alternatively, you could use a JSON string to accomplish the same as follows (replacing ``abc123`` with the API key used for your esmond instance) ::

    pscheduler task --archive '{"archiver": "esmond","data":{"url":"http://localhost/esmond/perfsonar/archive/","_auth-token": "abc123"}}' trace --dest www.perfsonar.net
 
For more information on different archivers and their specifications, see :doc:`pscheduler_ref_archivers`.
 
.. _pscheduler_client_tasks-exporting:

Exporting tasks to JSON
------------------------

The JSON version of a task specification can be sent to the standard output without scheduling using the ``--export`` switch::

    pscheduler task --export throughput --dest wherever --udp --ip-version 6 > mytask.json

**NOTE:**  Tasks are not validated until submitted for scheduling, so it is possible to export invalid tasks.

.. _pscheduler_client_tasks-importing:

Importing tasks from JSON
--------------------------

A JSON file that was previously exported or generated elsewhere can be imported using the ``--import`` switch::

    pscheduler task --import mytask.json throughput

Test parameters may be changed on the fly by adding them to the command line after the test type::

    pscheduler task --import mytask.json throughput --dest somewhere.else



.. _pscheduler_client_tasks-substitutions:

Substituting Files for Test Parameters
--------------------------------------

All test parameters (i.e., those after the test type) may have their
values read from a file by preceding the path to the file with an
at sign (``@``)::

    pscheduler task throughput --dest @~/mystuff/destination.txt --duration PT1M

For arguments that need to begin with a literal ``@``, this feature
can be disabled by escaping the first character with a backslash::

    pscheduler task idle --starting-comment '\@keep-this-argument-as-is' --duration PT2S



.. _pscheduler_client_tasks-canceling:
 
Canceling Tasks
------------------
You may cancel a task with the ``pscheduler cancel`` command which takes the following form::
    
    pscheduler cancel TASK_URL
    
The ``TASK_URL`` is the full URL of the task to be canceled and should have been output by the ``pscheduler task`` command when a task was submitted. This command cancels any future runs of the task specified. The task itself plus all runs prior to the time of the transaction remain intact. Any run of the task which is underway will continue to completion. The task will still be in the database but will be marked as disabled. This means you will still be able to query results of runs completed prior to cancellation but no new results will be generated. A full example of the command is shown below::

    pscheduler cancel https://ps.example.org/pscheduler/tasks/f1fc3a56-080c-46ec-a777-91c26460a233
    
