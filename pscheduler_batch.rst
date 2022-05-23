****************
Batch Processing
****************

pScheduler can be used to run a series of tasks, called a *batch*,
from the command line and return the results for further processing by
other programs.

Each task is referred to as a *job*.

Jobs can be done singly or in multiple *iterations* with the latter
being possible serially or in parallel.


.. _pscheduler_batch_invocation:

Invocation
----------

The batch processor is started using a ``pscheduler`` command::

    pscheduler batch [ OPTIONS ] [ INPUT-FILE ]


The ``OPTIONS`` control the batch processor's behavior and can be listed
using the ``--help`` option.

The ``INPUT-FILE`` is a path to the input.  If not provided or is
``-``, input will be taken from the standard input.

The final result (see :doc:`_pscheduler_batch_output`) is sent to the
standard output.

Error and diagnostic output will be sent to standard error.




.. _pscheduler_batch_input:

Input
-----

Input to the batch processor is JSON in the form of a single object
containing three pairs, ``global``, ``jobs`` and, optionally, a
``schema``.

The ``schema`` describes which version of the batch specification is
in use.  If none is provided, it defaults to ``1``.  Specific
instances where other values are required are described below.


.. _pscheduler_batch_input_global:

The ``global`` Pair
^^^^^^^^^^^^^^^^^^^

The ``global`` pair is an optional JSON object containing data and
transforms provided or applied to all jobs.  It contains the following
pairs, all optional:

``data`` (Any JSON) - Data made available to all jq transforms as a
variable named ``$global``.

``transform-pre`` (pScheduler jq Transform) - A transform applied to
the ``task`` object in each job before anything else is done.

``transform-post`` (pScheduler jq Transform) - A transform applied to
the ``task`` object in each job after `transform-pre` and the job's
`task-transform` have been applied.



.. _pscheduler_batch_input_jobs:

The ``jobs`` Pair
^^^^^^^^^^^^^^^^^

The ``jobs`` pair is an array of objects, each containing a single job::

    "jobs": [
        { ... Job 1 .. },
        { ... Job 2 .. },
        { ... Job n .. }
    ]

A job is described in a JSON object containing the following pairs:

``label`` (String) - A label for the job, used for reference in
debugging output.

``enabled`` (Boolean) - Determines whether or not the job is run.
Defaults to ``true``.

``iterations`` (Number or JQ Transform) - The number of times to run
the specified task.  If a JQ transform is provided, the script should
calculate and return the number of iterations as an integer and the
``schema`` should be set to at least ``3``.  Input to the transform is
``null``; any external data required should be accessed via
``$global``.

``parallel`` (Boolean) - Whether or not the job's iterations should be
run in parallel.  This defaults to ``false`` and implies ``sync-start``
(see below) unless ``sync-start`` is explicitly set ``false``.

``setup-time`` (Boolean) - The amount of time expected for pScheduler to
set up a single run.  The default of ``PT15S`` should be more than
sufficient in most cases.  This is ignored if not doing a synchronized
start (see ``sync-start``, below).

``backoff`` (String) - ISO8601 duration indicating how long each
iteration run in parallel waits before being submitted to pScheduler.
The first will have no backoff, the second will have the indicated
backoff, the third will have twice that, etc.  This value is ignored
if ``parallel`` is ``false``.

``sync-start`` (Boolean) - If running in parallel, set the start time of
all iterations to be the same.  The time is based on the ``number`` of
times the task is run, ``backoff`` and ``setup-time``.  This value is
ignored if ``parallel`` is ``false``.  Note that tasks subject to
restrictions on being run at the same time will not necessarily start
in sync (or at all if no ``slip`` is allowed as part of the task's
``schedule`` section.

``task`` (Object or Array of Objects) - A pScheduler task
specification as would be produced using the ``task`` command's
``--export`` switch.  Note that if the specification contains a
``schedule``, those parameters will be ignored.  If the value is an
array, the contents of the array will be treated as a set of tasks and
the number of iterations will be set to its length.  This overrides
the contents of ``iterations``.

``task-transform`` - A jq transform that operates on the ``task``'s
value for each iteration to make iteration-specific changes.  The
``$iteration`` variable is provided to indicate which iteration
(starting with ``0``) is being transformed.  The script should operate
on the input in place.


For example, this job will run five sequential ``rtt`` tests to
``www.perfsonar.net`` with 5, 10, 15, 20 and 25 pings sent.  The
``task-transform`` adds a ``count`` to the test specification that is
calculated based on the iteration::

    {
        "label": "rtt",
        "iterations": 5,
        "parallel": false,
        "task": {
            "test": {
                "type": "rtt",
                "spec": {
                    "schema": 1,
                    "dest": "www.perfsonar.net"
                }
            }
        },
        "task-transform": {
            "script": [
                ".test.spec.count = ($iteration + 1) * 5"
            ]
        }
    }

``continue-if`` - A jq transform that determines, based on the results
of a job, whether the batch processor should continue to the next job
or abort the batch.  The input given to the transform is the same as
the value of the ``results`` pair in the output as described below.
For example::

    [
      {
        "task": { ... },
        "runs": [
          {
            "application/json": {
              "schema": 1,
              "duration": "PT2S",
              "succeeded": true
            },
            "text/plain": " ... ",
            "text/html": " ... "
          }
        ]
      }
    ]

The transform should return ```true`` for the batch to continue with
the next job or ``false`` to abort the batch without processing any
subsequent jobs.  Any other value is treated as an error and
the batch will be aborted with no results.

A ``continue-if`` that decides whether to continue based on the
success or failure of the first run in a job would look like this::

    {
        "task": { ... },
        "continue-if": {
            "script": ".[0].runs[0].\"application/json\".succeeded"
        }
     }


.. _pscheduler_batch_output:

Output
------

Once all jobs have been completed, the batch processor will output a
copy of the input with the addition of a ``results`` pair in each job
containing information about what tasks were run and the results they
produced.

The ``results`` pair is an array of JSON objects, with one element per
iteration.  Each object contains the following pairs:

``task`` (pScheduler Task Specification) - The task that was submitted
to pScheduler and run.

``runs`` (Array of pScheduler Results) - An array of the results
produced by the task.  In most cases, there will be a single element,
but for tasks that return multiple results (e.g., ``latencybg``),
there will be more than one.  Each result is a JSON object containing
pairs named ``application/json``, ``text/plain`` and ``text/html`` for
each of the formats in which pScheduler can produce a result.



.. _pscheduler_batch_python:

Invocation from Python
----------------------

The batch processor can be invoked from Python on any system where
pScheduler's Python library is installed.  (On CentOS, this would be
the ``python-pscheduler`` package.)

For example::

    #!/usr/bin/env python3

    import pscheduler.batchprocessor
    import sys


    batch = { ... }

    def debug(message):
        """
        Callback function for the batch processor to emit a line of
        debug.
        """
        print(message, file=sys.stderr)

    processor = pscheduler.batchprocessor.BatchProcessor(batch)

    # Leave out the debug argument for no debugging.
    # This can be invoked multiple times to run the same batch repeatedly.
    result = processor(debug=debug)



.. _pscheduler_batch_tips:

Tips and Tricks
---------------

Running Different Tasks as Part of the Same Job
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Different tests can be run in parallel by using the ``task-transform``
to alter the contents of the ``test`` pair for each iteration.

 * Put an array of the tests to be run in the task's ``reference``
   pair.  The length of the array should be the same as the specified
   ``iterations``.

 * Leave the task's ``test`` section as an empty object (``{}``).

 * Add a ``task-transform`` that replaces the test with an element
   from the array (e.g., ``.test = .reference.tests[$iteration]``).


This example runs a three-minute-long streaming latency test with a
throughput test to the same host during the second minute.  The
``backoff`` value makes the througput test sleep for one minute before
it is scheduled and started so there's latency data produced
beforehand and afterward.::

    {
        "label": "different-in-parallel",
        "iterations": 2,
        "parallel": true,
        "backoff": "PT1M",
        "task": {
            "reference": {
                "tests": [
                    {
                        "type": "latencybg",
                        "spec": {
                            "dest": "ps.example.net",
                            "duration": "PT3M"
                        }
                    },
                    {
                        "type": "throughput",
                        "spec": {
                            "dest": "ps.example.net",
                            "duration": "PT1M"
                        }
                    }
                ]
    
            },
            "#": "This is intentionally empty:",
            "test": { }
        },
        "task-transform": {
            "script": [
                "# Replace the test section of the task with one of the",
                "# tests in the reference block based on the iteration.",
                ".test = .reference.tests[$iteration]"
            ]
        }
    }
