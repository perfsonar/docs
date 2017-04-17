*****************
Reading Log Files
*****************

The tools and services running on your host keep log files of major activity. The perfSONAR Toolkit provides utilities for exposing these logs via the web interface as well as tools to analyze their results. This page decribes the log files available and the additional tools provided for analyzing them.

Important Log Files
===================
Most perfSONAR related services keep log files under the directory */var/log/perfsonar*. Some external tools store them in other areas under */var/log/* or elsewhere. There are many log files on the system but some of the most important ones (organized by the service that populates them) can be found below:

+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| Service                                      | Log File(s)                                   | When to Use                                |
+==============================================+===============================================+============================================+
| BWCTL and OWAMP                              | /var/log/perfsonar/owamp_bwctl.log            | |log_descr_bwctl|                          |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| Esmond Measurement Archive                   | /var/log/esmond/esmond.log                    | |log_descr_esmond|                         |
|                                              | /var/log/httpd/error_log                      |                                            |
|                                              | /var/log/cassandra/cassandra.log              |                                            |
|                                              | /var/lib/pgsql/pgstartup.log                  |                                            |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| Network Diagnostic Tool (NDT)                | /var/log/ndt/web100srv.log                    | |log_descr_ndt|                            |
|                                              | /var/log/ndt/fakewww_error.log                |                                            |
|                                              | /var/log/ndt/fakewww_access.log               |                                            |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| perfSONAR Configuration Daemon               | /var/log/perfsonar/configdaemon.log           | |log_descr_config|                         |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| perfSONAR Lookup Service Cache Daemon        | /var/log/perfsonar/lscachedaemon.log          | |log_descr_lscache|                        |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| perfSONAR Lookup Service Registration Daemon | /var/log/perfsonar/lsregistrationdaemon.log   | |log_descr_lsreg|                          |
+----------------------------------------------+-----------------------------------------------+--------------------------------------------+
| perfSONAR Regular Testing Scheduler          | /var/log/perfsonar/regulartesting.log         | |log_descr_tests|                          |
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
Users with administrative rights may look at all the log files under **/var/log/perfsonar/** through the web interface. This obviously does not include all logs on the system, but does allow easy access for some of the major perfSONAR logs. To access this interface perform the following steps:
    #. From your toolkit web interface, click *perfSONAR Logs* on the left menu

        .. image:: images/manage_logs-view1.png
    #. Login using the web administrator username and password.
        .. seealso:: See :doc:`manage_users` for more details on creating a web administrator account
    #. The log files should be listed on the page that loads

        .. image:: images/manage_logs-view2.png

Determining Who Is Testing to Your Host
=======================================

You may install a cron job that analyzes the logs of BWCTL, OWAMP, and NDT hourly and generates a report of who tested to your host when. You can install access these reports as follows:
    #. Copy the cron script to */etc/cron.hourly*::
    
        cp /usr/lib/perfsonar/scripts/logscraper.cron /etc/cron.hourly/logscraper.cron
    #. Wait at least an hour for the script to run
    #. Visit the old tookit web interface at *http://hostaddress/toolkit-old*
    #. Click *BWCTL Log Analysis*, *OWAMP Log Analysis*, or *NDT Log Analysis* (depending on the log you want analyzed) on the left menu
    
        .. image:: images/manage_logs-analyze1.png
    #. Login using the web administrator username and password.
        .. seealso:: See :doc:`manage_users` for more details on creating a web administrator account
    #. On the page that loads, you should see a listing of IP addresses and the times that they ran tests to your host
    
        .. image:: images/manage_logs-analyze2.png

.. warning:: The cron script may consume significant system resources. Prior to version 3.5 the script was installed by default, but was removed due to this constraint. If you reinstall the file as detailed above, please use caution and note that it may affect your regular tests.

.. |log_descr_bwctl|  replace:: Every BWCTL and OWAMP test (both on the client and server side) is logged in this file. It should be used when a BWCTL or OWAMP test is not completing. It contains information about denied or failed tests. It may also contain information when an *owamp-server* or *bwctl-server* process crashes unexpectedly.
.. |log_descr_esmond|  replace:: If your measurement archive is not running or your graphs are not returning data you may want to look in one of these logs. *esmond.log* has information from the archive itself (e.g. improperly formatted requests). The HTTPD error log has information such as if esmond was able to connect to it's underlying databases. Speaking of databases, esmond connects to both Cassandra and PostgreSQL so it may be worth checking those logs as well.
.. |log_descr_ndt|  replace:: Use these logs when you encounter problems running NDT either from the command-line or Java applet
.. |log_descr_config|  replace:: If you are unable to save changes to the configuration made through the web interface, this is a good place to look.
.. |log_descr_lscache|  replace:: If you get a message saying that your communities or lookup service cache are out of date, this log file may contain more information.
.. |log_descr_lsreg|  replace:: Look here if your toolkit web page says that your host is not registered with the lookup service or you cannot find your host in the global services directory.
.. |log_descr_tests|  replace:: If you are not seeing test results in the graphs or you are concerned some tests are not running, this log may have more information.
.. |log_descr_watcher|  replace:: This log contains information about nightly restarts.
.. |log_descr_web|  replace:: Use these logs when you encounter problems with the web interface