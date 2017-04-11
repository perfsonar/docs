***************************************
Listing of Important perfSONAR Files
***************************************

BWCTL
======

Configuration Files
--------------------

.. _config_files-bwctl-conf-main:

Main Configuration File
##########################

:Description: The main configuration file for a BWCTL server
:RedHat: ``/etc/bwctl-server/bwctl-server.conf``
:Debian: ``/etc/bwctl-server/bwctl-server.conf``
:Documentation: :doc:`config_bwctl`

.. _config_files-bwctl-conf-limits:

Limits File
##########################

:Description: The BWCTL limits file that defines authentication and authorization parameters for testing
:RedHat: ``/etc/bwctl-server/bwctl-server.limits``
:Debian: ``/etc/bwctl-server/bwctl-server.limits``
:Documentation: :doc:`config_bwctl_limits`


Important Scripts
-----------------

.. _config_files-bwctl-scripts-startup:

Start-up Script
##########################

:Description: The script used to start/stop/restart a BWCTL server
:RedHat 6: ``/etc/init.d/bwctl-server start|stop|restart``
:RedHat 7: ``systemctl start|stop|restart bwctl-server``
:Debian: ``service bwctl-server start|stop|restart``

Log Files
---------

.. _config_files-bwctl-logs-primary:

Primary Log file
##########################
:Description: BWCTL servers and clients can each write to log files. The location of the log file is dependent on your syslog configuration. The entries in this table assume a default configuration.
:RedHat: **RPM Only**: ``/var/log/messages`` **Toolkit:** ``/var/log/perfsonar/owamp_bwctl.log``
:Debian: ``/var/log/perfsonar/owamp_bwctl.log``


esmond
======

Configuration Files
--------------------

.. _config_files-esmond-conf-main:

Main Configuration File
#######################
:Description: The main configuration file for esmond
:RedHat: ``/etc/esmond/esmond.conf``
:Debian: ``/etc/esmond/esmond.conf``
:Documentation: *N/A*

Important Scripts
-----------------

.. _config_files-esmond-scripts-startup:

Start-up Script
##########################
:Description: Esmond is started/stopped/restarted when HTTPD is started/stopped/restarted
:RedHat 6: ``/etc/init.d/httpd24-httpd start|stop|restart``
:RedHat 7: ``systemctl httpd start|stop|restart``
:Debian: ``service apache2 restart``

.. _config_files-esmond-scripts-ps_remove_data:

Data Cleaner
##########################
:Description: Cleans out old esmond data given a policy file.
:RedHat: ``/usr/lib/esmond/utils/ps_remove_data.py``
:Debian: ``/usr/share/esmond/util/ps_remove_data.py``
:Documentation: :ref:`multi_ma_backups-delete`

Log Files
---------

.. _config_files-esmond-logs-esmond:

esmond Log
##########################
:Description: Primary error log for esmond software.
:RedHat: ``/var/log/esmond/esmond.log``
:Debian: ``/var/log/esmond/esmond.log``

.. _config_files-esmond-logs-django:

Django Log
##########################
:Description: Error log related to Django framework such as processing JSON messages and database interactions
:RedHat: ``/var/log/esmond/django.log``
:Debian: ``/var/log/esmond/django.log``

LS Registration Daemon
=======================

Configuration Files
--------------------

.. _config_files-lsreg-conf-main:

Main Configuration File
#############################
:Description: The main configuration file for the LS Registration Daemon that describes what you want registered in the Lookup Service.
:RedHat: ``/etc/perfsonar/lsregistrationdaemon.conf``
:Debian: ``/etc/perfsonar/lsregistrationdaemon.conf``
:Documentation: :doc:`config_ls_registration`

.. _config_files-lsreg-conf-logging:

Logging Configuration File
#############################
:Description: Configuration file for setting log location, level of detail and various other log-related settings.
:RedHat: ``/etc/perfsonar/lsregistrationdaemon-logger.conf``
:Debian: ``/etc/perfsonar/lsregistrationdaemon-logger.conf``
:Documentation: `Log4perl Reference <http://search.cpan.org/~mschilli/Log-Log4perl-1.46/lib/Log/Log4perl.pm>`_

Important Scripts
-----------------

.. _config_files-lsreg-scripts-startup:

Start-up Script
##########################
:Description: The script used to start/stop/restart a LS Registration Daemon server
:RedHat 6: ``/etc/init.d/perfsonar-lsregistrationdaemon``
:RedHat 7: ``systemctl perfsonar-lsregistrationdaemon start|stop|restart``
:Debian: ``service perfsonar-lsregistrationdaemon start|stop|restart``


Log Files
---------

.. _config_files-lsreg-logs-primary:

Primary Log file
##########################
:Description: The log file to which the LS Registration daemon writes to as configured in the default :ref:`logging configuration file <config_files-lsreg-conf-logging>`
:RedHat: ``/var/log/perfsonar/lsregistrationdaemon.log``
:Debian: ``/var/log/perfsonar/lsregistrationdaemon.log``


MeshConfig
==========

Configuration Files
--------------------

.. _config_files-meshconfig-conf-agent:

Agent Configuration File
#############################
:Description: The configuration file used by clients to download a mesh and build a local test configuration
:RedHat: ``/etc/perfsonar/meshconfig-agent.conf``
:Debian: ``/etc/perfsonar/meshconfig-agent.conf``
:Documentation: :doc:`config_mesh_agent`

.. _config_files-meshconfig-conf-agent-tasks:

Agent Tasks File
#############################
:Description: This file contains the tasks to be run by the host as defined manually, via the toolkit web interface and/or any remote mesh configuration files. They are submitted to pScheduler. This file is the successor to the former regulartesting.conf file.
:RedHat: ``/etc/perfsonar/meshconfig-agent-tasks.conf``
:Debian: ``/etc/perfsonar/meshconfig-agent-tasks.conf``
:Documentation: :doc:`config_mesh_agent_tasks`

.. _config_files-meshconfig-conf-guiagent:

GUI Agent Configuration File
#############################
:Description: The configuration file used to download a mesh and build a `MaDDash <http://software.es.net/maddash>`_ configuration
:RedHat: ``/etc/perfsonar/meshconfig-guiagent.conf``
:Debian: ``/etc/perfsonar/meshconfig-guiagent.conf``

:Documentation: :doc:`config_mesh_gui`

.. _config_files-meshconfig-conf-lookup_hosts:

Dynamic Host Lookup Configuration File
#######################################
:Description: The configuration file used to contact the lookup service and build a set of hosts to be used in the mesh
:RedHat: ``/etc/perfsonar/meshconfig-lookuphosts.conf``
:Debian: ``/etc/perfsonar/meshconfig-lookuphosts.conf``
:Documentation: :doc:`config_mesh_lookup_hosts`


Important Scripts
-----------------
.. _config_files-meshconfig-scripts-agent:

MeshConfig Agent Start-up Script
#################################
:Description: The script used to start/stop/restart a MeshConfig Agent. This daemon builds :ref:`meshconfig-agent-tasks.conf<config_files-meshconfig-conf-agent-tasks>` from remote meshes and picks up any manual changes and submits the tasks to pScheduler.
:RedHat 6: ``/etc/init.d/perfsonar-meshconfig-agent start|stop|restart``
:RedHat 7: ``systemctl perfsonar-meshconfig-agent start|stop|restart``
:Debian: ``service perfsonar-meshconfig-agent start|stop|restart``

.. _config_files-meshconfig-scripts-guiagent:

MeshConfig GUI Agent Start-up Script
#################################
:Description: The script used to start/stop/restart a MeshConfig GUI Agent. This daemon builds `MaDDash configuration file <http://software.es.net/maddash/config_server.html>`_ from a downloaded central configuration file.
:RedHat 6: ``/etc/init.d/perfsonar-meshconfig-guiagent start|stop|restart``
:RedHat 7: ``systemctl perfsonar-meshconfig-guiagent start|stop|restart``
:Debian: ``service perfsonar-meshconfig-guiagent start|stop|restart``

.. _config_files-meshconfig-scripts-json:

JSON Builder
############
:Description: The script used to convert a central configuration file to JSON consumable by agents
:RedHat: ``/usr/lib/perfsonar/bin/build_json``
:Debian: ``/usr/lib/perfsonar/bin/build_json``

.. _config_files-meshconfig-scripts-lookup_hosts:

Dynamic Host List Generator
###########################
:Description: The script used to contact the lookup service and build a set of hosts to be used in the mesh
:RedHat: ``/usr/lib/perfsonar/bin/lookup_hosts``
:Debian: ``/usr/lib/perfsonar/bin/lookup_hosts``

Log Files
---------

.. _config_files-meshconfig-logs-generate_configuration:

MeshConfig Agent Log
################################
:Description: The log file written when the :ref:`MeshConfig agent <config_files-meshconfig-scripts-agent>` is run.
:RedHat: ``/var/log/perfsonar/meshconfig-agent.log``
:Debian: ``/var/log/perfsonar/meshconfig-agent.log``

.. _config_files-meshconfig-logs-generate_gui_configuration:

GUI/Dashboard Configuration Agent Log
############################################
:Description: The log file written when the :ref:`MeshConfig GUI agent <config_files-meshconfig-scripts-guiagent>` is run.
:RedHat: ``/var/log/perfsonar/meshconfig-guiagent.log``
:Debian: ``/var/log/perfsonar/meshconfig-guiagent.log``

OWAMP
======

Configuration Files
--------------------

.. _config_files-owamp-conf-main:

Main Configuration File
##########################

:Description: The main configuration file for an OWAMP server
:RedHat: ``/etc/owamp-server/owamp-server.conf``
:Debian: ``/etc/owamp-server/owamp-server.conf``
:Documentation: :doc:`config_owamp`

.. _config_files-owamp-conf-limits:

Limits File
##########################

:Description: The OWAMP limits file that defines authentication and authorization parameters for testing
:RedHat: ``/etc/owamp-server/owamp-server.limits``
:Debian: ``/etc/owamp-server/owamp-server.limits``
:Documentation: :doc:`config_owamp_limits`


Important Scripts
-----------------

.. _config_files-owamp-scripts-startup:

Start-up Script
##########################

:Description: The script used to start/stop/restart an OWAMP server
:RedHat 6: ``/etc/init.d/owamp-server start|stop|restart``
:RedHat 7: ``systemctl owamp-server start|stop|restart``
:Debian: ``service owamp-server start|stop|restart``

Log Files
---------

.. _config_files-owamp-logs-primary:

Primary Log file
##########################
:Description: OWAMP servers and clients can each write to log files. The location of the log file is dependent on your syslog configuration. The entries in this table assume a default configuration.
:RedHat: **RPM Only**: ``/var/log/messages`` **Toolkit:** ``/var/log/perfsonar/owamp_bwctl.log``
:Debian: ``/var/log/perfsonar/owamp_bwctl.log``

pScheduler
==========

Configuration Files
--------------------

.. _config_files-pscheduler-conf-limits:

Limits File
##########################

:Description: The pScheduler limits file that defines authentication and authorization parameters for testing.
:RedHat: ``/etc/pscheduler/limits.conf``
:Debian: ``/etc/pscheduler/limits.conf``
:Documentation: :doc:`config_pscheduler_limits`

.. _config_files-pscheduler-conf-archives:

Archives Configuration Files
############################

:Description: The configuration files for pScheduler's archives. Contains individual archive specifications applied to every measurement the system runs.
:RedHat: ``/etc/pscheduler/default-archives/*``
:Debian: ``/etc/pscheduler/default-archives/*``
:Documentation:

.. _config_files-pscheduler-conf-database:

Database Configuration Files
############################

:Description: The configuration files for pScheduler's database. Contains files maintained by the system and should not be altered at the risk of breaking pScheduler’s ability to use its database.
:RedHat: ``/etc/pscheduler/database/*``
:Debian: ``/etc/pscheduler/database/*``
:Documentation:


Log Files
---------

.. _config_files-pscheduler-logs-primary:

Primary Log file
##########################
:Description: The log file written when the pScheduler daemon is run.
:RedHat: ``/var/log/pscheduler/pscheduler.log``
:Debian: ``/var/log/pscheduler/pscheduler.log``


Toolkit
========

Configuration Files
--------------------

.. note:: The Toolkit contains other configuration files but in general non-developers should not be changing them. As such they are not listed here.

.. _config_files-toolkit-conf-clean_esmond_db:

Measurement Archive Data Retention Policy
#########################################
:Description: The configuration file used by the :ref:`esmond data cleaner <config_files-esmond-scripts-ps_remove_data>` script when running in the :ref:`cron <config_files-toolkit-cron-clean_esmond_db>` installed by the Toolkit.
:RedHat: ``/etc/perfsonar/toolkit/clean_esmond_db.conf``
:Debian: ``/etc/perfsonar/toolkit/clean_esmond_db.conf``
:Documentation: :ref:`multi_ma_backups-delete`


Important Scripts
-----------------

.. _config_files-toolkit-scripts-nptoolkit_configure:

Toolkit Configuration Script
###########################################
:Description: A script to help configure users and other basic features of the Toolkit.
:RedHat: ``/usr/lib/perfsonar/scripts/nptoolkit-configure.py``
:Debian: ``/usr/lib/perfsonar/scripts/nptoolkit-configure.py``
:Documentation: :doc:`manage_users`

.. _config_files-toolkit-scripts-config_daemon:

Configuration Daemon Start-up Script
#######################################
:Description: The script used to start/stop/restart the service used by the administrative web interface to configure the host
:RedHat 6: ``/etc/init.d/perfsonar-configdaemon start|stop|restart``
:RedHat 7: ``systemctl perfsonar-configdaemon start|stop|restart``
:Debian: ``service perfsonar-toolkit-config-daemon start|stop|restart``

.. _config_files-toolkit-scripts-configure_nic_parameters:

Network Interface Card Configuration Script
###########################################
:Description: The script detects if the NIC is misconfigured, and makes necessary configuration changes to NIC if they are.
:RedHat 6: ``/etc/init.d/perfsonar-configure_nic_parameters start|stop|restart``
:RedHat 7: ``systemctl perfsonar-configure_nic_parameters start|stop|restart``
:Debian: ``service perfsonar-configure_nic_parameters start|stop|restart``

.. _config_files-toolkit-scripts-generate_motd:

'Message of the Day' Script
###########################################
:Description: Generates the login message on start-up that appears to command-line users
:RedHat 6: ``/etc/init.d/perfsonar-generate_motd start|stop|restart``
:RedHat 7: ``systemctl perfsonar-generate_motd start|stop|restart``
:Debian: ``service perfsonar-generate_motd start|stop|restart``

.. _config_files-toolkit-scripts-psb_to_esmond:

Measurement Archive Upgrade Script
###########################################
:Description: Upgrades data from a pre-3.4 Toolkit to the current version. If there is no data to upgrade then it exits.
:RedHat: ``/etc/init.d/perfsonar-psb_to_esmond start|stop|restart``
:Debian: ``service perfsonar-psb_to_esmond start|stop|restart``

.. _config_files-toolkit-scripts-mod_interface_route:

Multi-Interface Routing Setup Script
###########################################
:Description: A script to help with the configuration of routing for hosts running tests on multiple interfaces.
:RedHat: ``/usr/lib/perfsonar/scripts/mod_interface_route``
:Debian: ``/usr/lib/perfsonar/scripts/mod_interface_route``
:Documentation: :doc:`manage_dual_xface`


Installed Cron Jobs
-------------------

.. _config_files-toolkit-cron-clean_esmond_db:

Measurement Archive Data Cleaner
#####################################
:Description: Cleans out data in the measurement archive according to retention policy in :ref:`config_files-toolkit-conf-clean_esmond_db`. Runs at 2:30AM every morning.
:RedHat: ``/etc/cron.d/cron-clean_esmond_db``
:Debian: ``/etc/cron.d/cron-clean_esmond_db``

.. _config_files-toolkit-cron-service_watcher:

Regular Service Restarts and Maintenance
###########################################
:Description: Verifies expected processes are running every hour and performs a regular restart of services that require it every moring at 1:05AM. It also cleans out stale files from OWAMP and Regular Testing at this time.
:RedHat: ``/etc/cron.d/cron-service_watcher``
:Debian: ``/etc/cron.d/perfsonar-toolkit-servicewatcher``

Log Files
---------

.. _config_files-toolkit-logs-config_daemon:

Configuration Daemon Log
##########################
:Description: The log file for the :ref:`configuration daemon <config_files-toolkit-scripts-config_daemon>`
:RedHat: ``/var/log/perfsonar/configdaemon.log``
:Debian: ``/var/log/perfsonar/configdaemon.log``

.. _config_files-toolkit-logs-psb_to_esmond:

Measurement Archive Upgrade Log
################################
:Description: The log file for the measurement archive :ref:`upgrade script <config_files-toolkit-scripts-psb_to_esmond>`
:RedHat: ``/var/log/perfsonar/psb_to_esmond.log``
:Debian: ``/var/log/perfsonar/psb_to_esmond.log``

.. _config_files-toolkit-logs-service_watcher:

Service Watcher Log
################################
:Description: Logs generated by the :ref:`cron <config_files-toolkit-cron-service_watcher>` that verifies services are running and performs regular restarts/maintenance.
:RedHat: ``/var/log/perfsonar/servicewatcher.log`` and ``/var/log/perfsonar/servicewatcher_error.log``
:Debian: ``/var/log/perfsonar/servicewatcher.log`` and ``/var/log/perfsonar/servicewatcher_error.log``
:Debian: *N/A*

Web Interface Logs
################################
:Description: Log files for the web interface.
:RedHat: ``/var/log/perfsonar/web_admin/web_admin.log``
:Debian: ``/var/log/perfsonar/web_admin/web_admin.log``
