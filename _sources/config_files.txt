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
:RedHat: ``/etc/bwctld/bwctld.conf``
:Debian: ``/etc/bwctl/bwctld.conf``
:Documentation: :doc:`config_bwctl`

.. _config_files-bwctl-conf-limits:

Limits File
##########################

:Description: The BWCTL limits file that defines authentication and authorization parameters for testing
:RedHat: ``/etc/bwctld/bwctld.limits``
:Debian: ``/etc/bwctl/bwctld.limits``
:Documentation: :doc:`config_bwctl_limits`


Important Scripts
-----------------

.. _config_files-bwctl-scripts-startup:

Start-up Script
##########################

:Description: The script used to start/stop/restart a BWCTL server
:RedHat: ``/etc/init.d/bwctld``
:Debian: ``/etc/init.d/bwctl-server``

Log Files
---------

.. _config_files-bwctl-logs-primary:

Primary Log file
##########################
:Description: BWCTL servers and clients can each write to log files. The location of the log file is dependent on your syslog configuration. The entries in this table assume a default configuration. 
:RedHat: **RPM Only**: ``/var/log/messages`` **Toolkit or Complete Install:** ``/var/log/perfsonar/owamp_bwctl.log``
:Debian: ``/var/log/messages`` 


esmond
======

Configuration Files
--------------------

.. _config_files-esmond-conf-main:

Main Configuration File 
#######################
:Description: The main configuration file for esmond
:RedHat: ``/opt/esmond/esmond.conf``
:Debian: *N/A*
:Documentation: *N/A*

Important Scripts
-----------------

.. _config_files-esmond-scripts-startup:

Start-up Script
##########################
:Description: Esmond is started/stopped/restarted when HTTPD is started/stopped/restarted 
:RedHat: ``/etc/init.d/httpd``
:Debian: *N/A*

.. _config_files-esmond-scripts-ps_remove_data:

Data Cleaner
##########################
:Description: Cleans out old esmond data given a policy file.
:RedHat: ``/opt/esmond/utils/ps_remove_data.py``
:Debian: *N/A*
:Documentation: :ref:`multi_ma_backups-delete`

Log Files
---------

.. _config_files-esmond-logs-esmond:

esmond Log
##########################
:Description: Primary error log for esmond software.
:RedHat: ``/var/log/esmond/esmond.log``
:Debian: *N/A* 

.. _config_files-esmond-logs-django:

Django Log
##########################
:Description: Error log related to Django framework such as processing JSON messages and database interactions 
:RedHat: ``/var/log/esmond/django.log``
:Debian: *N/A* 

LS Registration Daemon
=======================

Configuration Files
--------------------

.. _config_files-lsreg-conf-main:

Main Configuration File
#############################
:Description: The main configuration file for the LS Registration Daemon that describes what you want registered in the Lookup Service.
:RedHat: ``/opt/perfsonar_ps/ls_registration_daemon/etc/ls_registration_daemon.conf``
:Debian: ``/etc/perfsonar/lsregistrationdaemon.conf``
:Documentation: :doc:`config_ls_registration`

.. _config_files-lsreg-conf-logging:

Logging Configuration File
#############################
:Description: Configuration file for setting log location, level of detail and various other log-related settings.
:RedHat: ``/opt/perfsonar_ps/ls_registration_daemon/etc/ls_registration_daemon-logger.conf``
:Debian: ``/etc/perfsonar/lsregistrationdaemon-logger.conf``
:Documentation: `Log4perl Reference <http://search.cpan.org/~mschilli/Log-Log4perl-1.46/lib/Log/Log4perl.pm>`_

Important Scripts
-----------------

.. _config_files-lsreg-scripts-startup:

Start-up Script
##########################
:Description: The script used to start/stop/restart a LS Registation Daemon server
:RedHat: ``/etc/init.d/ls_registration_daemon``
:Debian: ``/etc/init.d/perfsonar-lsregistrationdaemon``


Log Files
---------

.. _config_files-lsreg-logs-primary:

Primary Log file
##########################
:Description: The log file to which the LS Registration daemon writes to as configured in the default :ref:`logging configuration file <config_files-lsreg-conf-logging>`
:RedHat: ``/var/log/perfsonar/ls_registration_daemon.log``
:Debian: ``/var/log/perfsonar/lsregistrationdaemon.log`` 


MeshConfig
==========

Configuration Files
--------------------

.. _config_files-meshconfig-conf-agent:

Agent Configuration File
#############################
:Description: The configuration file used by clients to download a mesh and build a local test configuration
:RedHat: ``/opt/perfsonar_ps/mesh_config/etc/agent_configuration.conf``
:Debian: ``/etc/perfsonar/agentconfiguration.conf``
:Documentation: :doc:`config_mesh_agent`

.. _config_files-meshconfig-conf-gui_agent:

GUI Agent Configuration File
#############################
:Description: The configuration file used to download a mesh and build a `MaDDash <http://software.es.net/maddash>`_ configuration
:RedHat: ``/opt/perfsonar_ps/mesh_config/etc/gui_agent_configuration.conf``
:Debian: ``/etc/perfsonar/guiagentconfiguration.conf``
:Documentation: :doc:`config_mesh_gui`

.. _config_files-meshconfig-conf-lookup_hosts:

Dynamic Host Lookup Configuration File
#######################################
:Description: The configuration file used to contact the lookup service and build a set of hosts to be used in the mesh
:RedHat: ``/opt/perfsonar_ps/mesh_config/etc/lookup_hosts.conf``
:Debian: ``/etc/perfsonar/lookuphosts.conf``
:Documentation: :doc:`config_mesh_lookup_hosts`


Important Scripts
-----------------

.. _config_files-meshconfig-scripts-json:

JSON Builder
############
:Description: The script used to convert a central configuration file to JSON consumable by agents
:RedHat: ``/opt/perfsonar_ps/mesh_config/bin/build_json``
:Debian: ``/usr/lib/perfsonar/bin/build_json``

.. _config_files-meshconfig-scripts-generate_configuration:

Test Configuration Generator
#############################
:Description: The script used to generate a :ref:`regular testing configuration file <config_files-regtesting-conf-main>` from a downloaded central configuration file
:RedHat: ``/opt/perfsonar_ps/mesh_config/bin/generate_configuration``
:Debian: ``/usr/lib/perfsonar/bin/generate_configuration``

.. _config_files-meshconfig-scripts-generate_gui_configuration:

GUI/Dashboard Configuration Generator
#####################################
:Description: The script used to generate a `MaDDash configuration file <http://software.es.net/maddash/config_server.html>`_ from a downloaded central configuration file
:RedHat: ``/opt/perfsonar_ps/mesh_config/bin/generate_gui_configuration``
:Debian: ``/usr/lib/perfsonar/bin/generate_gui_configuration``

.. _config_files-meshconfig-scripts-lookup_hosts:

Dynamic Host List Generator
###########################
:Description: The script used to contact the lookup service and build a set of hosts to be used in the mesh
:RedHat: ``/opt/perfsonar_ps/mesh_config/bin/lookup_hosts``
:Debian: ``/usr/lib/perfsonar/bin/lookup_hosts``

Installed Cron Jobs
-------------------

.. _config_files-meshconfig-cron-generate_configuration:

Test Configuration Generator Cron
#####################################
:Description: Runs the :ref:`test configuration generator <config_files-meshconfig-scripts-generate_configuration>` every night at 2AM
:RedHat: ``/etc/cron.d/cron-mesh_config_agent``
:Debian: ``/etc/cron.d/perfsonar-meshconfig-agent``

.. _config_files-meshconfig-cron-generate_gui_configuration:

GUI/Dashboard Configuration Generator Cron
###########################################
:Description: Runs the :ref:`GUI configuration generator <config_files-meshconfig-scripts-generate_gui_configuration>` every night at 2AM
:RedHat: ``/etc/cron.d/cron-mesh_config_gui_agent``
:Debian: ``/etc/cron.d/perfsonar-meshconfig-guiagent``

Log Files
---------

.. _config_files-meshconfig-logs-generate_configuration:

Test Configuration Generator Log
################################
:Description: The log file written when the :ref:`test generator <config_files-meshconfig-scripts-generate_configuration>` is run from :ref:`cron <config_files-meshconfig-cron-generate_configuration>`.
:RedHat: ``/var/log/perfsonar/mesh_configuration_agent.log``
:Debian: ``/var/log/perfsonar/mesh_configuration_agent.log`` 

.. _config_files-meshconfig-logs-generate_gui_configuration:

GUI/Dashboard Configuration Generator Log
############################################
:Description: The log file written when the :ref:`GUI generator <config_files-meshconfig-scripts-generate_gui_configuration>` is run from :ref:`cron <config_files-meshconfig-cron-generate_gui_configuration>`.
:RedHat: ``/var/log/perfsonar/mesh_configuration_gui_agent.log``
:Debian: ``/var/log/perfsonar/mesh_configuration_gui_agent.log`` 

OWAMP
======

Configuration Files
--------------------

.. _config_files-owamp-conf-main:

Main Configuration File
##########################

:Description: The main configuration file for an OWAMP server
:RedHat: ``/etc/owampd/owampd.conf``
:Debian: ``/etc/owampd/owampd.conf``
:Documentation: :doc:`config_owamp`

.. _config_files-owamp-conf-limits:

Limits File
##########################

:Description: The OWAMP limits file that defines authentication and authorization parameters for testing
:RedHat: ``/etc/owampd/owampd.limits``
:Debian: ``/etc/owampd/owampd.limits``
:Documentation: :doc:`config_owamp_limits`


Important Scripts
-----------------

.. _config_files-owamp-scripts-startup:

Start-up Script
##########################

:Description: The script used to start/stop/restart an OWAMP server
:RedHat: ``/etc/init.d/owampd``
:Debian: ``/etc/init.d/owampd``

Log Files
---------

.. _config_files-owamp-logs-primary:

Primary Log file
##########################
:Description: OWAMP servers and clients can each write to log files. The location of the log file is dependent on your syslog configuration. The entries in this table assume a default configuration. 
:RedHat: **RPM Only**: ``/var/log/messages`` **Toolkit or Complete Install:** ``/var/log/perfsonar/owamp_bwctl.log``
:Debian: ``/var/log/messages`` 

Regular Testing
================

Configuration Files
--------------------

.. _config_files-regtesting-conf-main:

Main Configuration File
#############################
:Description: The main configuration file for Regular Testing that describes the schedule of tests to run.
:RedHat: ``/opt/perfsonar_ps/regular_testing/etc/regular_testing.conf``
:Debian: ``/etc/perfsonar/regulartesting.conf``
:Documentation: :doc:`config_regular_testing`

.. _config_files-regtesting-conf-logging:

Logging Configuration File
#############################
:Description: Configuration file for setting log location, level of detail and various other log-related settings.
:RedHat: ``/opt/perfsonar_ps/regular_testing/etc/regular_testing-logger.conf``
:Debian: ``/etc/perfsonar/regulartesting-logger.conf``
:Documentation: `Log4perl Reference <http://search.cpan.org/~mschilli/Log-Log4perl-1.46/lib/Log/Log4perl.pm>`_

Important Scripts
-----------------

.. _config_files-regtesting-scripts-startup:

Start-up Script
##########################
:Description: The script used to start/stop/restart Regular Testing
:RedHat: ``/etc/init.d/regular_testing``
:Debian: ``/etc/init.d/perfsonar-regulartesting``


Log Files
---------

.. _config_files-regtesting-logs-primary:

Primary Log file
##########################
:Description: The log file to which Regular Testing writes as configured in the default :ref:`logging configuration file <config_files-regtesting-conf-logging>`
:RedHat: ``/var/log/perfsonar/regular_testing.log``
:Debian: ``/var/log/perfsonar/regulartesting.log``



Toolkit
========

Configuration Files
--------------------

.. note:: The Toolkit contains other configuration files but in general non-developers should not be changing them. As such they are not listed here.

.. _config_files-toolkit-conf-clean_esmond_db:

Measurement Archive Data Retention Policy
#########################################
:Description: The configuration file used by the :ref:`esmond data cleaner <config_files-esmond-scripts-ps_remove_data>` script when running in the :ref:`cron <config_files-toolkit-cron-clean_esmond_db>` installed by the Toolkit.
:RedHat: ``/opt/perfsonar_ps/toolkit/etc/clean_esmond_db.conf``
:Debian: *N/A*
:Documentation: :ref:`multi_ma_backups-delete`


Important Scripts
-----------------

.. _config_files-toolkit-scripts-nptoolkit_configure:

Toolkit Configuration Script
###########################################
:Description: A script to help configure users and other basic features of the Toolkit. 
:RedHat: ``/opt/perfsonar_ps/toolkit/scripts/nptoolkit-configure.py``
:Debian: *N/A*
:Documentation: :doc:`manage_users`

.. _config_files-toolkit-scripts-config_daemon:

Configuration Daemon Start-up Script
#######################################
:Description: The script used to start/stop/restart the service used by the administrative web interface to configure the host
:RedHat: ``/etc/init.d/config_daemon``
:Debian: *N/A*

.. _config_files-toolkit-scripts-configure_nic_parameters:

Network Interface Card Configuration Script
###########################################
:Description: The script detects if NDT or NPAD is running and makes necessary configuration changes to NIC if they are. 
:RedHat: ``/etc/init.d/configure_nic_parameters``
:Debian: *N/A*

.. _config_files-toolkit-scripts-generate_motd:

'Message of the Day' Script
###########################################
:Description: Generates the login message on start-up that appears to command-line users
:RedHat: ``/etc/init.d/generate_motd``
:Debian: *N/A*

.. _config_files-toolkit-scripts-psb_to_esmond:

Measurement Archive Upgrade Script
###########################################
:Description: Upgrades data from a pre-3.4 Toolkit to the current version. If there is no data to upgrade then it exits.
:RedHat: ``/etc/init.d/psb_to_esmond``
:Debian: *N/A*

.. _config_files-toolkit-scripts-mod_interface_route:

Multi-Interface Routing Setup Script
###########################################
:Description: A script to help with the configuration of routing for hosts running tests on multiple interfaces.
:RedHat: ``/opt/perfsonar_ps/toolkit/scripts/mod_interface_route``
:Debian: *N/A*
:Documentation: :doc:`manage_dual_xface`


Installed Cron Jobs
-------------------

.. _config_files-toolkit-cron-clean_esmond_db:

Measurement Archive Data Cleaner
#####################################
:Description: Cleans out data in the measurement archive according to retention policy in :ref:`config_files-toolkit-conf-clean_esmond_db`. Runs at 2:30AM every morning.
:RedHat: ``/etc/cron.d/cron-clean_esmond_db``
:Debian: *N/A*

.. _config_files-toolkit-cron-service_watcher:

Regular Service Restarts and Maintenance
###########################################
:Description: Verifies expected processes are running every hour and performs a regular restart of services that require it every moring at 1:05AM. It also cleans out stale files from OWAMP and Regular Testing at this time.
:RedHat: ``/etc/cron.d/cron-service_watcher``
:Debian: *N/A*

Log Files
---------

.. _config_files-toolkit-logs-config_daemon:

Configuration Daemon Log
##########################
:Description: The log file for the :ref:`configuration daemon <config_files-toolkit-scripts-config_daemon>`
:RedHat: ``/var/log/perfsonar/config_daemon.log``
:Debian: *N/A*

.. _config_files-toolkit-logs-psb_to_esmond:

Measurement Archive Upgrade Log
################################
:Description: The log file for the measurement archive :ref:`upgrade script <config_files-toolkit-scripts-psb_to_esmond>`
:RedHat: ``/var/log/perfsonar/psb_to_esmond.log``
:Debian: *N/A*

.. _config_files-toolkit-logs-service_watcher:

Service Watcher Log
################################
:Description: Logs generated by the :ref:`cron <config_files-toolkit-cron-service_watcher>` that verifies services are running and performs regular restarts/maintenance.
:RedHat: ``/var/log/perfsonar/service_watcher.log`` and ``/var/log/perfsonar/service_watcher_error.log``
:Debian: *N/A*

Web Interface Logs
################################
:Description: Log files for the web interface.
:RedHat: ``/var/log/perfsonar/web_admin/web_admin.log``
:Debian: *N/A*

