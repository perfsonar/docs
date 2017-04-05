*****************
Reading Log Files
*****************

The tools and services running on your host keep log files of major activity. This page describes the log files available and the additional tools provided for accessing them.

Important Log Files
===================
Most perfSONAR related services keep log files under the directory **/var/log/perfsonar**. Some external tools store them in other areas under */var/log/* or elsewhere. There are many log files on the system but some of the most important ones (organized by the service that populates them) can be found below:

+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| Service                                      | Log File(s)                                   | When to Use                                |
+==============================================+===============================================+============================================+
| pScheduler                                   | /var/log/pscheduler/pscheduler.log            | |log_descr_pscheduler|                     |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| Esmond Measurement Archive                   | /var/log/esmond/esmond.log                    | |log_descr_esmond|                         |
|                                              | /var/log/httpd/error_log                      |                                            |
|                                              | /var/log/httpd24/error_log (CentOS 6 only)    |                                            |
|                                              | /var/log/cassandra/cassandra.log              |                                            |
|                                              | /var/lib/pgsql/pgstartup.log                  |                                            |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| perfSONAR Mesh Configuration Agent           | /var/log/perfsonar/meshconfig-agent.log       | |log_descr_meshag|                         |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| BWCTL and OWAMP                              | /var/log/perfsonar/owamp_bwctl.log            | |log_descr_bwctl|                          |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| perfSONAR Configuration Daemon               | /var/log/perfsonar/configdaemon.log           | |log_descr_config|                         |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| perfSONAR Lookup Service Cache Daemon        | /var/log/perfsonar/lscachedaemon.log          | |log_descr_lscache|                        |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| perfSONAR Lookup Service Registration Daemon | /var/log/perfsonar/lsregistrationdaemon.log   | |log_descr_lsreg|                          |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| perfSONAR Service Watcher                    | /var/log/perfsonar/servicewatcher.log         | |log_descr_watcher|                        |
|                                              | /var/log/perfsonar/servicewatcher_error.log   |                                            |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| perfSONAR Web Interface                      | /var/log/perfsonar/web_admin/web_admin.log    | |log_descr_web|                            |
|                                              | /var/log/httpd/error_log                      |                                            |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+

.. note:: The table above is not an exhaustive list of every log file on the system. It's intended to point at some *important* log files that are commonly used to debug issues with perfSONAR tools. Depending on the exact issue you may need to view other log files on the system to diagnose a problem. 

Accessing Log Files Through the Web Interface
=============================================
Users with administrative rights may look at log files under **/var/log/perfsonar/** through the web interface. This obviously does not include all logs on the system, but does allow easy access for some of the major perfSONAR logs. To access this interface perform the following steps:
    #. From your toolkit main web interface, look at the right side of **Services** section, under **SERVICE LOGS**. This place provides links to web interface access to selected toolkit logs.

        .. image:: images/manage_logs-main.png
    #. Login using the web administrator username and password.
        .. seealso:: See :doc:`manage_users` for more details on creating a web administrator account.
    #. Selected log files should be listed on the page that loads.

        .. image:: images/manage_logs-list.png

Determining Who Is Testing to Your Host
=======================================
This could likely be derived from the a combination pScheduler and OWAMP logs, but the best place to collect is information is likely not from the logs at all. See :doc:`pscheduler_client_schedule` for information on viewing tests initiated both by your host and others. 


.. |log_descr_bwctl|  replace:: Every BWCTL and OWAMP test (both on the client and server side) is logged in this file. It should be used when a BWCTL or OWAMP test is not completing. It contains information about denied or failed tests. It may also contain information when an *owamp-server* or *bwctl-server* process crashes unexpectedly. Please note that BWCTL is deprecated as of version 4.0, so you may be better served looking at the pScheduler logs.
.. |log_descr_pscheduler|  replace:: Contains logs related to the scheduling, running, and storage of measurements. This is often a good starting point if you are trying to debug a missing or failed measurement.
.. |log_descr_esmond|  replace:: If your measurement archive is not running or your graphs are not returning data you may want to look in one of these logs. *esmond.log* has information from the archive itself (e.g. improperly formatted requests). The HTTPD error log has information such as if esmond was able to connect to it's underlying databases. Speaking of databases, esmond connects to both Cassandra and PostgreSQL so it may be worth checking those logs as well.
.. |log_descr_config|  replace:: If you are unable to save changes to the configuration made through the web interface, this is a good place to look.
.. |log_descr_lscache|  replace:: If you get a message saying that your communities or lookup service cache are out of date, this log file may contain more information.
.. |log_descr_lsreg|  replace:: Look here if your toolkit web page says that your host is not registered with the lookup service or you cannot find your host in the global services directory.
.. |log_descr_tests|  replace:: If you are not seeing test results in the graphs or you are concerned some tests are not running, this log may have more information.
.. |log_descr_watcher|  replace:: This log contains information about nightly restarts.
.. |log_descr_web|  replace:: Use these logs when you encounter problems with the web interface.
.. |log_descr_meshag|  replace:: In addition to the pScheduler logs, this is a good place to debug information regarding missing measurements. The MeshConfig agent handles the submission of tasks to pScheduler, so failure to do so is a common cause of missing tests.
