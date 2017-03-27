*****************************************
Troubleshooting perfSONAR 4.0
*****************************************

(page under construction!)


This page contains some hints on how to troubleshoot perfSONAR 4.0.

1.  Confirm that pScheduler on the local system is functioning:
::

   pscheduler ping localhost
   pscheduler task idle --duration PT2S
   pscheduler task rtt --dest 127.0.0.1

2.  Make sure SElinux is set to ``permissive`` or ``disabled``
::

To disable SElinux, run:
::

    echo 0 >/selinux/enforce

To make it permanently in the ``permissive`` mode, run:
::

    sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

3.  Confirm firewall settings are correct by running some tests from the command line.
::

   pscheduler task throughput --dest receive_host -source send_host   
   pscheduler task rtt --source send_host --dest receive_host
   pscheduler task trace --source send_host --dest receive_host

Also try reversing source/dest for all of these.

4. Make sure pscheduler is behaving properly.
::

Look for ERRORs in ``/var/log/pscheduler.log``

To enable additional logging, run (as the pscheduler or root user):
::

   pscheduler debug on  
   or
   pscheduler debug on runner scheduler  

To enable debug mode for these components only

If you are missing results, it can be helpful to look closer into what the scheduler is doing.
Some useful commands include:

Look at the schedule in real time:
::

   pscheduler monitor --refresh=5

Look at a plot of the schedule (past and future)
::

   pscheduler plot-schedule --host hostname -PT30M +PT30M > plot.png


Look for tests that failed to start in the past 2 hours:
::

   pscheduler schedule --host hostname -PT2H | grep -2 Non-Starter

Look at schedule details for the past hour for throughput tests:
::

   pscheduler schedule --filter-test=throughput -PT1H | grep -2 myTestHost | grep -2 iperf3

For a specific host/tool:
::

   pscheduler schedule --filter-test=throughput -PT1H | grep -2 myTestHost | grep -2 iperf3
   or
   pscheduler schedule --filter-test=throughput -PT1H | egrep -2  "(nuttcp|iperf3)" | grep -2 myTestHost

Note that these commands work to remote hosts too by adding ‘--host=hostname`
::

   pscheduler schedule --filter-test=throughput --host hostname -PT1H

To Look at results for a particular run:
::

   pscheduler result https://hostname/pscheduler/tasks/ccdad633-db0e-460d-9a63-0064b00c1f32/runs/83948ec5-3bb4-4627-b30c-4199b335c7b8


