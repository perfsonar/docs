***************************************
Listing of Important perfSONAR Files
***************************************

LS Registration Daemon
=======================

Configuration Files
--------------------

.. _config_files-lsreg-conf-main:

Main Configuration File
#############################
:Description: The main configuration file for the LS Registration Daemon that describes what you want registered in the Lookup Service.
:CentOS: ``/etc/perfsonar/lsregistrationdaemon.conf``
:Debian: ``/etc/perfsonar/lsregistrationdaemon.conf``
:Documentation: :doc:`config_ls_registration`

.. _config_files-lsreg-conf-logging:

Logging Configuration File
#############################
:Description: Configuration file for setting log location, level of detail and various other log-related settings.
:CentOS: ``/etc/perfsonar/lsregistrationdaemon-logger.conf``
:Debian: ``/etc/perfsonar/lsregistrationdaemon-logger.conf``
:Documentation: `Log4perl Reference <http://search.cpan.org/~mschilli/Log-Log4perl-1.46/lib/Log/Log4perl.pm>`_

Important Scripts
-----------------

.. _config_files-lsreg-scripts-startup:

Start-up Script
##########################
:Description: The script used to start/stop/restart a LS Registration Daemon server
:CentOS: ``systemctl start|stop|restart perfsonar-lsregistrationdaemon``
:Debian: ``service perfsonar-lsregistrationdaemon start|stop|restart``


Log Files
---------

.. _config_files-lsreg-logs-primary:

Primary Log file
##########################
:Description: The log file to which the LS Registration daemon writes to as configured in the default :ref:`logging configuration file <config_files-lsreg-conf-logging>`
:CentOS: ``/var/log/perfsonar/lsregistrationdaemon.log``
:Debian: ``/var/log/perfsonar/lsregistrationdaemon.log``

OWAMP
======

Configuration Files
--------------------

.. _config_files-owamp-conf-main:

Main Configuration File
##########################

:Description: The main configuration file for an OWAMP server
:CentOS: ``/etc/owamp-server/owamp-server.conf``
:Debian: ``/etc/owamp-server/owamp-server.conf``
:Documentation: :doc:`config_owamp`

.. _config_files-owamp-conf-limits:

Limits File
##########################

:Description: The OWAMP limits file that defines authentication and authorization parameters for testing
:CentOS: ``/etc/owamp-server/owamp-server.limits``
:Debian: ``/etc/owamp-server/owamp-server.limits``
:Documentation: :doc:`config_owamp_limits`


Important Scripts
-----------------

.. _config_files-owamp-scripts-startup:

Start-up Script
##########################

:Description: The script used to start/stop/restart an OWAMP server
:CentOS: ``systemctl start|stop|restart owamp-server``
:Debian: ``service owamp-server start|stop|restart``

Log Files
---------

.. _config_files-owamp-logs-primary:

Primary Log file
##########################
:Description: OWAMP servers and clients can each write to log files. The location of the log file is dependent on your syslog configuration. The entries in this table assume a default configuration.
:CentOS: **RPM Only**: ``/var/log/messages`` **Toolkit:** ``/var/log/perfsonar/owamp.log``
:Debian: ``/var/log/perfsonar/owamp.log``

pScheduler
==========

Configuration Files
--------------------

.. _config_files-pscheduler-conf-limits:

Limits File
##########################

:Description: The pScheduler limits file that defines authentication and authorization parameters for testing.
:CentOS: ``/etc/pscheduler/limits.conf``
:Debian: ``/etc/pscheduler/limits.conf``
:Documentation: :doc:`config_pscheduler_limits`

.. _config_files-pscheduler-conf-archives:

Archives Configuration Files
############################

:Description: The configuration files for pScheduler's archives. Contains individual archive specifications applied to every measurement the system runs.
:CentOS: ``/etc/pscheduler/default-archives/*``
:Debian: ``/etc/pscheduler/default-archives/*``
:Documentation:

.. _config_files-pscheduler-conf-database:

Database Configuration Files
############################

:Description: The configuration files for pScheduler's database. Contains files maintained by the system and should not be altered at the risk of breaking pScheduler’s ability to use its database.
:CentOS: ``/etc/pscheduler/database/*``
:Debian: ``/etc/pscheduler/database/*``
:Documentation:


Log Files
---------

.. _config_files-pscheduler-logs-primary:

Primary Log file
##########################
:Description: The log file written when the pScheduler daemon is run.
:CentOS: ``/var/log/pscheduler/pscheduler.log``
:Debian: ``/var/log/pscheduler/pscheduler.log``

.. _config_files-psconfig:

pSConfig
========

.. _config_files-psconfig-conf:

Configuration Files
--------------------

.. _config_files-psconfig-conf-pscheduler:

pSConfig pScheduler Agent Configuration File
##############################################
:Description: The pSConfig pScheduler Agent configuration file
:CentOS: ``/etc/perfsonar/psconfig/pscheduler-agent.json``
:Debian: ``/etc/perfsonar/psconfig/pscheduler-agent.json``
:Documentation: *N/A*

.. _config_files-psconfig-conf-grafana:

pSConfig Grafana Agent Configuration File
##############################################
:Description: The pSConfig Grafana Agent configuration file
:CentOS: ``/etc/perfsonar/psconfig/grafana-agent.json``
:Debian: ``/etc/perfsonar/psconfig/grafana-agent.json``
:Documentation: *N/A*

.. _config_files-psconfig-conf-pscheduler-d:

pSConfig pScheduler Agent Include Directory
##############################################
:Description: Directory for pSConfig templates that automatically get loaded by pScheduler agent
:CentOS: ``/etc/perfsonar/psconfig/pscheduler.d``
:Debian: ``/etc/perfsonar/psconfig/pscheduler.d``
:Documentation: *N/A*

.. _config_files-psconfig-conf-grafana-d:

pSConfig Grafana Agent Include Directory
##############################################
:Description: Directory for pSConfig templates that automatically get loaded by Grafana agent
:CentOS: ``/etc/perfsonar/psconfig/grafana.d``
:Debian: ``/etc/perfsonar/psconfig/grafana.d``
:Documentation: *N/A*

.. _config_files-psconfig-conf-archive-d:

pSConfig Archive Include Directory
##############################################
:Description: Directory for archive definitions that automatically get loaded by agent(s)
:CentOS: ``/etc/perfsonar/psconfig/archives.d``
:Debian: ``/etc/perfsonar/psconfig/archives.d``
:Documentation: *N/A*

.. _config_files-psconfig-conf-transform-d:

pSConfig Transform Include Directory
##############################################
:Description: Directory for JQ transformations that automatically get applied to all templates downloaded by agent(s)
:CentOS: ``/etc/perfsonar/psconfig/transforms.d``
:Debian: ``/etc/perfsonar/psconfig/transforms.d``
:Documentation: *N/A*

Important Scripts
-----------------

.. _config_files-psconfig-scripts-pscheduler-startup:

pSConfig pScheduler Agent Start-up Script
############################################
:Description: Scripts used to start|stop|restart the pSConfig pScheduler Agent
:CentOS: ``systemctl start|stop|restart psconfig-pscheduler-agent``
:Debian: ``service psconfig-pscheduler-agent start|stop|restart``

.. _config_files-psconfig-scripts-grafana-startup:

pSConfig Grafana Agent Start-up Script
############################################
:Description: Scripts used to start|stop|restart the pSConfig Grafana Agent
:CentOS: ``systemctl start|stop|restart psconfig-grafana-agent``
:Debian: ``service psconfig-grafana-agent start|stop|restart``

.. _config_files-psconfig-scripts-ps_remove_data:

`psconfig` command
############################################
:Description: Command used to perform numerous tasks related to pSConfig
:CentOS: ``psconfig COMMAND [OPTIONS]``
:Debian: ``psconfig COMMAND [OPTIONS]``

Log Files
---------

.. _config_files-psconfig-logs-pscheduler-agent:

pSConfig pScheduler Agent Log
##############################
:Description: Primary log for pSConfig pScheduler Agent
:CentOS: ``/var/log/perfsonar/psconfig-pscheduler-agent.log``
:Debian: ``/var/log/perfsonar/psconfig-pscheduler-agent.log``

.. _config_files-psconfig-logs-pscheduler-agent-trans:

pSConfig pScheduler Agent Tasks Log
##########################################
:Description: Log of all the pScheduler tasks managed by the agent
:CentOS: ``/var/log/perfsonar/psconfig-pscheduler-agent-tasks.log``
:Debian: ``/var/log/perfsonar/psconfig-pscheduler-agent-tasks.log``

pSConfig pScheduler Agent Transactions Log
##########################################
:Description: Log of each interaction by agent with pScheduler server(s)
:CentOS: ``/var/log/perfsonar/psconfig-pscheduler-agent-transactions.log``
:Debian: ``/var/log/perfsonar/psconfig-pscheduler-agent-transactions.log``

.. _config_files-psconfig-logs-grafana-agent:

pSConfig Grafana Agent Log
##########################
:Description: Primary log for pSConfig Grafana Agent
:CentOS: ``/var/log/perfsonar/psconfig-grafana-agent.log``
:Debian: ``/var/log/perfsonar/psconfig-grafana-agent.log``

Toolkit
========

Configuration Files
--------------------

.. note:: The Toolkit contains other configuration files but in general non-developers should not be changing them. As such they are not listed here.


Important Scripts
-----------------

.. _config_files-toolkit-scripts-nptoolkit_configure:

Toolkit Configuration Script
###########################################
:Description: A script to help configure users and other basic features of the Toolkit.
:CentOS: ``/usr/lib/perfsonar/scripts/nptoolkit-configure.py``
:Debian: ``/usr/lib/perfsonar/scripts/nptoolkit-configure.py``
:Documentation: :doc:`manage_users`

.. _config_files-toolkit-scripts-config_daemon:

Configuration Daemon Start-up Script
#######################################
:Description: The script used to start/stop/restart the service used by the administrative web interface to configure the host
:CentOS: ``systemctl start|stop|restart perfsonar-configdaemon``
:Debian: ``service perfsonar-toolkit-config-daemon start|stop|restart``

.. _config_files-toolkit-scripts-configure_nic_parameters:

Network Interface Card Configuration Script
###########################################
:Description: The script detects if the NIC is misconfigured, and makes necessary configuration changes to NIC if they are.
:CentOS: ``systemctl start|stop|restart perfsonar-configure_nic_parameters``
:Debian: ``service perfsonar-configure_nic_parameters start|stop|restart``

.. _config_files-toolkit-scripts-generate_motd:

'Message of the Day' Script
###########################################
:Description: Generates the login message on start-up that appears to command-line users
:CentOS: ``systemctl start|stop|restart perfsonar-generate_motd``
:Debian: ``service perfsonar-generate_motd start|stop|restart``

.. _config_files-toolkit-scripts-mod_interface_route:

Multi-Interface Routing Setup Script
###########################################
:Description: A script to help with the configuration of routing for hosts running tests on multiple interfaces.
:CentOS: ``/usr/lib/perfsonar/scripts/mod_interface_route``
:Debian: ``/usr/lib/perfsonar/scripts/mod_interface_route``
:Documentation: :doc:`manage_dual_xface`

Log Files
---------

.. _config_files-toolkit-logs-config_daemon:

Configuration Daemon Log
##########################
:Description: The log file for the :ref:`configuration daemon <config_files-toolkit-scripts-config_daemon>`
:CentOS: ``/var/log/perfsonar/configdaemon.log``
:Debian: ``/var/log/perfsonar/configdaemon.log``


Web Interface Logs
################################
:Description: Log files for the web interface.
:CentOS: ``/var/log/perfsonar/web_admin/web_admin.log``
:Debian: ``/var/log/perfsonar/web_admin/web_admin.log``
