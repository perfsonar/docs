*****************
Reading Log Files
*****************

The tools and services running on your host keep log files of major activity. This page describes the log files available and the additional tools provided for accessing them.

Important Log Files
===================
Most perfSONAR related services keep log files under the directory **/var/log/perfsonar**. Some external tools store them in other areas under */var/log/* or elsewhere. There are many log files on the system but some of the most important ones (organized by the service that populates them) can be found below:

+----------------------------------------------+-------------------------------------------------------------------+--------------------------------------------+
| Service                                      | Log File(s)                                                       | When to Use                                |
+==============================================+===================================================================+============================================+
| pScheduler                                   | * /var/log/pscheduler/pscheduler.log                              | |log_descr_pscheduler|                     |
+----------------------------------------------+-------------------------------------------------------------------+--------------------------------------------+
| pSConfig pScheduler Agent                    | * /var/log/perfsonar/psconfig-pscheduler-agent.log                | |log_descr_psconfig|                       |
|                                              | * /var/log/perfsonar/psconfig-pscheduler-agent-transactions.log   |                                            |
|                                              | * /var/log/perfsonar/psconfig-pscheduler-agent-tasks.log          |                                            |
+----------------------------------------------+-------------------------------------------------------------------+--------------------------------------------+
| OpenSearch/Logstash Archive                  | * /var/log/httpd/ssl_error_log                                    | |log_descr_archive|                        |
|                                              | * /var/log/opensearch/opensearch.log                              |                                            |
|                                              | * /var/log/logstash/logstash-plain.log                            |                                            |
+----------------------------------------------+-------------------------------------------------------------------+--------------------------------------------+
| OWAMP                                        | * /var/log/perfsonar/owamp.log                                    | |log_descr_owamp|                          |
+----------------------------------------------+-------------------------------------------------------------------+--------------------------------------------+
| perfSONAR Configuration Daemon               | * /var/log/perfsonar/configdaemon.log                             | |log_descr_config|                         |
+----------------------------------------------+-------------------------------------------------------------------+--------------------------------------------+
| perfSONAR Lookup Service Cache Daemon        | * /var/log/perfsonar/lscachedaemon.log                            | |log_descr_lscache|                        |
+----------------------------------------------+-------------------------------------------------------------------+--------------------------------------------+
| perfSONAR Lookup Service Registration Daemon | * /var/log/perfsonar/lsregistrationdaemon.log                     | |log_descr_lsreg|                          |
+----------------------------------------------+-------------------------------------------------------------------+--------------------------------------------+
| perfSONAR Web Interface                      | * /var/log/perfsonar/web_admin/web_admin.log                      | |log_descr_web|                            |
|                                              | * /var/log/httpd/error_log                                        |                                            |
|                                              | * /var/log/apache2/error.log (Debian/Ubuntu)                      |                                            |
+----------------------------------------------+-------------------------------------------------------------------+--------------------------------------------+

.. note:: The table above is not an exhaustive list of every log file on the system. It's intended to point at some *important* log files that are commonly used to debug issues with perfSONAR tools. Depending on the exact issue you may need to view other log files on the system to diagnose a problem. 

Determining Who Is Testing to Your Host
=======================================
This could likely be derived from the a combination pScheduler and OWAMP logs, but the best place to collect is information is likely not from the logs at all. See :doc:`pscheduler_client_schedule` for information on viewing tests initiated both by your host and others. 


.. |log_descr_owamp|  replace:: Every OWAMP test (both on the client and server side) is logged in this file. It should be used when an OWAMP test is not completing. It contains information about denied or failed tests. It may also contain information when an *owamp-server* process crashes unexpectedly.
.. |log_descr_pscheduler|  replace:: Contains logs related to the scheduling, running, and storage of measurements. This is often a good starting point if you are trying to debug a missing or failed measurement.
.. |log_descr_archive|  replace:: If your measurement archive is not running or your graphs are not returning data you may want to look in one of these logs. The HTTPD error log has information such as if the proxy could reach Logstash or OpenSearch. The Logstash logs indicate if there was an issue reaching OpenSearch or processing the result. OpenSearch logs will indicate if there is an issue with the database or processing queries.
.. |log_descr_config|  replace:: If you are unable to save changes to the configuration made through the web interface, this is a good place to look.
.. |log_descr_lscache|  replace:: If you get a message saying that your communities or lookup service cache are out of date, this log file may contain more information.
.. |log_descr_lsreg|  replace:: Look here if your toolkit web page says that your host is not registered with the lookup service or you cannot find your host in the global services directory.
.. |log_descr_tests|  replace:: If you are not seeing test results in the graphs or you are concerned some tests are not running, this log may have more information.
.. |log_descr_watcher|  replace:: This log contains information about nightly restarts.
.. |log_descr_web|  replace:: Use these logs when you encounter problems with the web interface.
.. |log_descr_psconfig|  replace:: See document :ref:`here<psconfig_pscheduler_agent-troubleshoot-logs>`
