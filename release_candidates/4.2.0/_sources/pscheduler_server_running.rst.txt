******************************
Running a pScheduler Server
******************************

Introduction
--------------
The pScheduler server is the component that does the heavy-lifting of scheduling and managing tasks.  It consists of multiple daemon processes and makes extensive use of `PostgreSQL <https://www.postgresql.org>`_. This document describes basic usage of the server.

Daemons
--------
pScheduler consists for four daemon processes that run as separate services. The four services are:

    #. **pscheduler-scheduler** - This process is what puts new runs on the schedule or marks a run as a non-starter if it can not find an available slot.
    #. **pscheduler-runner** - This process is what executes runs on the schedule using the selected tool
    #. **pscheduler-archiver** - This process executes archiver plug-ins using the results of runs. Archivers generally send results to long-term storage or to applications for further processing.
    #. **pscheduler-ticker** - This process handles basic maintenance of pScheduler

These services can be started/stopped with ``systemctl`` or the ``service`` command depending on the operating system. For example:

    * Using systemctl::
        
        systemctl start pscheduler-scheduler
        systemctl start pscheduler-runner
        systemctl start pscheduler-archiver
        systemctl start pscheduler-ticker
        
In addition to these processes, it also requires Apache HTTPD and PostgreSQL daemons to be running. Apache provides the web server where pScheduler accepts REST API requests and PostgreSQL is where the schedule is stored. The name of these processes is dependent on the operating system:

    * **CentOS (all versions)**: ``httpd`` and ``postgresql-9.5``
    * **Debian (all versions)**: ``apache2`` and ``postgresql``
    
Logging
----------
By default pScheduler logs to syslog facility **local4**. It sets-up rsyslogd to redirect all logging to the following file:
    
    * /var/log/pscheduler/pscheduler.log

.. note:: If you are using an alternative syslog implementation to rsyslogd then you will need to configure it to redirect local4 manually

Configuration
---------------
pScheduler has regular configuration files for configuring various aspects of the server. It also has a file for managing :term:`limits` of the server. For more information on both of these topics, see the pages below:

    * :doc:`config_pscheduler`
    * :doc:`config_pscheduler_limits`



Pausing and Resuming
--------------------

pScheduler can be directed to stop running tasks using the ``pause``
command.  With no arguments, the pause will last indefinitely; with an
ISO 8601 duration (e.g., ``PT2H``), the pause will last for the amount
of time specified.  Note that any runs in progress when this command
is executed will be allowed to run to completion.  Runs scheduled
while the system is paused will fail with a ``missed`` status.

The ``resume`` command will start runing tasks with the next one on
the schedule.
