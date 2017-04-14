=========================
Troubleshooting perfSONAR
=========================

(Page under construction.)

This page contains some hints on how to troubleshoot perfSONAR 4.0 and later.

******
System
******

-------
SELinux
-------

Check that SELinux is disabled or in permissive mode::

    getenforce

If SELinux is in Enforcing mode, change it to permissive and make the
change permanent::

    setenforce Permissive
    sed -i -e 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config




**********
pScheduler
**********

------------------------
pScheduler on Local Host
------------------------

Confirm that pScheduler on the local system is functioning::

    pscheduler ping localhost

Check that pScheduler on the local system isn't reporting problems::

    fgrep ' ERROR ' /var/log/pscheduler/pscheduler.log

Run basic tests on the local system::

   pscheduler task idle --duration PT2S
   pscheduler task rtt --dest 127.0.0.1



--------------------------
pScheduler on Remote Hosts
--------------------------

Confirm that pScheduler on the other host (``REMOTE-HOST``) is
reachable and working::

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

If results are missing, looking at the pScheduler's timeline of runs
(the *schedule*) can be useful.

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


To retrieve results and diagnostics for a single run using a run URL
shown by the ``schedule`` command::

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
