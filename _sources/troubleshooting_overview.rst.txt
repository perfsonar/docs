=========================
Troubleshooting perfSONAR
=========================

This page contains some hints on how to troubleshoot perfSONAR 4.0 and later. You may also find some helpful notes in :doc:`FAQ`.

******
System
******

**********
Logs
**********
Check the logs using the information :doc:`here <manage_logs>`.

**********
pScheduler
**********

------------------------
pScheduler on Local Host
------------------------

These steps will allow you to verify the basic health of pScheduler in a local host.
Confirm that pScheduler on the local system is functioning running a command which will ping the localhost using pScheduler::

    pscheduler ping localhost

Check that pScheduler on the local system isn't reporting problems::

    fgrep ' ERROR ' /var/log/pscheduler/pscheduler.log

Run basic tests on the local system::

   pscheduler task idle --duration PT2S
   pscheduler task rtt --dest 127.0.0.1



--------------------------
pScheduler on Remote Hosts
--------------------------

These steps will allow you to verify the basic health of pScheduler in a remote host.
Confirm that pScheduler on the other host (``REMOTE-HOST``) is reachable and working running a command which will ping the remote host using pScheduler::

    pscheduler ping REMOTE-HOST

Run basic tests to the other host (the first test requires that TCP
ports 5890-5899 be open on that system)::

    pscheduler task trace --dest REMOTE-HOST
    pscheduler task rtt --dest REMOTE-HOST
    pscheduler task simplestream --dest REMOTE-HOST
    pscheduler task throughput --bandwidth 1M --dest REMOTE-HOST

Run the same tests in the opposite direction (from ``REMOTE-HOST`` to ``LOCAL-HOST``)::

    pscheduler task trace --source REMOTE-HOST --dest LOCAL-HOST
    pscheduler task rtt --source REMOTE-HOST --dest LOCAL-HOST
    pscheduler task simplestream --source REMOTE-HOST --dest LOCAL-HOST
    pscheduler task throughput --bandwidth 1M --source REMOTE-HOST --dest LOCAL-HOST



---------------------
Checking the Schedule
---------------------

If results are missing, looking at the pScheduler's timeline of runs (the *schedule*) can be useful.

Note that ``--host HOST-NAME`` can be added to the switches to
retrieve the schedule from other hosts.


Retrieve the schedule for a specified range of times::

    pscheduler schedule 2017-05-02T12:00:00 2017-05-02T12:10:00


Retrieve the schedule for a specified range of times relative to right
now::

    pscheduler schedule -PT10M +PT5M


Watch at the schedule in real time::

   pscheduler monitor --refresh=5


Look for tests that failed to start in the past 2 hours::

   pscheduler schedule -PT2H | grep -2 Non-Starter


Look at schedule details for throughput tests in the last hour
involving the host ``TEST-HOST``::

   pscheduler schedule --filter-test=throughput -PT1H | grep -2 TEST-HOST | grep -2 iperf3


Same as above, but for a specific tool and test::

   pscheduler schedule --filter-test=throughput -PT1H | egrep -2  "(nuttcp|iperf3)" | grep -2 TEST-HOST


To retrieve results and diagnostics for a single run using a RUN-URL shown by the ``schedule`` command::

   pscheduler result --diags --archivings RUN-URL


Generate a plot of the schedule that shows congestion::

    pscheduler plot-schedule -PT30M +PT30M > plot.png




------------------------
Additional Debug Logging
------------------------

The programs that manage pScheduler's activities can produce
additional debugging information useful to the development team in
finding problems.

To enable logging of debug output from pScheduler's components, run
(as ``root``)::

   pscheduler debug on PROGRAMS

Where ``PROGRAMS`` is a list of any of ``scheduler``, ``runner``,
``archiver``, ``ticker`` or ``api``.  Turning on debug for anything
other than ``scheduler`` and ``runner`` rarely be necessary.  If no
list is provided, debug will be enabled for all pScheduler programs.

Logging can be disabled by running::

    pscheduler debug off PROGRAMS

More information on the pscheduler error messages you might find in the logs is available at: 

- https://github.com/perfsonar/pscheduler/wiki/Error-Messages

