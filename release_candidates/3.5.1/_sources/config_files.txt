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
:RedHat (<v1.6): ``/etc/bwctld/bwctld.conf``
:RedHat: ``/etc/bwctl-server/bwctl-server.conf``
:Debian: ``/etc/bwctl-server/bwctl-server.conf``
:Documentation: :doc:`config_bwctl`

.. _config_files-bwctl-conf-limits:

Limits File
##########################

:Description: The BWCTL limits file that defines authentication and authorization parameters for testing
:RedHat (<v1.6): ``/etc/bwctld/bwctld.limits``
:RedHat: ``/etc/bwctl-server/bwctl-server.limits``
:Debian: ``/etc/bwctl-server/bwctl-server.limits``
:Documentation: :doc:`config_bwctl_limits`


Important Scripts
-----------------

.. _config_files-bwctl-scripts-startup:

Start-up Script
##########################

:Description: The script used to start/stop/restart a BWCTL server
:RedHat (<v1.6): ``/etc/init.d/bwctld``
:RedHat: ``/etc/init.d/bwctl-server``
:Debian: ``/etc/init.d/bwctl-server``

Log Files
---------

.. _config_files-bwctl-logs-primary:

Primary Log file
##########################
:Description: BWCTL servers and clients can each write to log files. The location of the log file is dependent on your syslog configuration. The entries in this table assume a default configuration. 
:RedHat: **RPM Only**: ``/var/log/messages`` **Toolkit:** ``/var/log/perfsonar/owamp_bwctl.log``
:Debian: ``/var/log/messages`` 


esmond
======

Configuration Files
--------------------

.. _config_files-esmond-conf-main:

Main Configuration File 
#######################
:Description: The main configuration file for esmond
:RedHat (<v2.0): ``/opt/esmond/esmond.conf``
:RedHat: ``/etc/esmond/esmond.conf``
:Debian: ``/etc/esmond/esmond.conf``
:Documentation: *N/A*

Important Scripts
-----------------

.. _config_files-esmond-scripts-startup:

Start-up Script
##########################
:Description: Esmond is started/stopped/restarted when HTTPD is started/stopped/restarted 
:RedHat: ``/etc/init.d/httpd``
:Debian: ``/etc/init.d/httpd``

.. _config_files-esmond-scripts-ps_remove_data:

Data Cleaner
##########################
:Description: Cleans out old esmond data given a policy file.
:RedHat (<v2.0): ``/opt/esmond/utils/ps_remove_data.py``
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
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/ls_registration_daemon/etc/ls_registration_daemon.conf``
:RedHat: ``/etc/perfsonar/lsregistrationdaemon.conf``
:Debian: ``/etc/perfsonar/lsregistrationdaemon.conf``
:Documentation: :doc:`config_ls_registration`

.. _config_files-lsreg-conf-logging:

Logging Configuration File
#############################
:Description: Configuration file for setting log location, level of detail and various other log-related settings.
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/ls_registration_daemon/etc/ls_registration_daemon-logger.conf``
:RedHat: ``/etc/perfsonar/lsregistrationdaemon-logger.conf``
:Debian: ``/etc/perfsonar/lsregistrationdaemon-logger.conf``
:Documentation: `Log4perl Reference <http://search.cpan.org/~mschilli/Log-Log4perl-1.46/lib/Log/Log4perl.pm>`_

Important Scripts
-----------------

.. _config_files-lsreg-scripts-startup:

Start-up Script
##########################
:Description: The script used to start/stop/restart a LS Registation Daemon server
:RedHat (<v3.5.1): ``/etc/init.d/ls_registration_daemon``
:RedHat: ``/etc/init.d/perfsonar-lsregistrationdaemon``
:Debian: ``/etc/init.d/perfsonar-lsregistrationdaemon``


Log Files
---------

.. _config_files-lsreg-logs-primary:

Primary Log file
##########################
:Description: The log file to which the LS Registration daemon writes to as configured in the default :ref:`logging configuration file <config_files-lsreg-conf-logging>`
:RedHat (<v3.5.1): ``/var/log/perfsonar/ls_registration_daemon.log``
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
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/mesh_config/etc/agent_configuration.conf``
:Debian (<v3.5.1): ``/etc/perfsonar/agentconfiguration.conf``
:RedHat: ``/etc/perfsonar/meshconfig-agent.conf``
:Debian: ``/etc/perfsonar/meshconfig-agent.conf``
:Documentation: :doc:`config_mesh_agent`

.. _config_files-meshconfig-conf-gui_agent:

GUI Agent Configuration File
#############################
:Description: The configuration file used to download a mesh and build a `MaDDash <http://software.es.net/maddash>`_ configuration
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/mesh_config/etc/gui_agent_configuration.conf``
:Debian (<v3.5.1): ``/etc/perfsonar/guiagentconfiguration.conf``
:RedHat: ``/etc/perfsonar/meshconfig-guiagent.conf``
:Debian: ``/etc/perfsonar/meshconfig-guiagent.conf``

:Documentation: :doc:`config_mesh_gui`

.. _config_files-meshconfig-conf-lookup_hosts:

Dynamic Host Lookup Configuration File
#######################################
:Description: The configuration file used to contact the lookup service and build a set of hosts to be used in the mesh
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/mesh_config/etc/lookup_hosts.conf``
:Debian (<v3.5.1): ``/etc/perfsonar/lookuphosts.conf``
:RedHat: ``/etc/perfsonar/meshconfig-lookuphosts.conf``
:Debian: ``/etc/perfsonar/meshconfig-lookuphosts.conf``
:Documentation: :doc:`config_mesh_lookup_hosts`


Important Scripts
-----------------

.. _config_files-meshconfig-scripts-json:

JSON Builder
############
:Description: The script used to convert a central configuration file to JSON consumable by agents
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/mesh_config/bin/build_json``
:RedHat: ``/usr/lib/perfsonar/bin/build_json``
:Debian: ``/usr/lib/perfsonar/bin/build_json``

.. _config_files-meshconfig-scripts-generate_configuration:

Test Configuration Generator
#############################
:Description: The script used to generate a :ref:`regular testing configuration file <config_files-regtesting-conf-main>` from a downloaded central configuration file
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/mesh_config/bin/generate_configuration``
:RedHat: ``/usr/lib/perfsonar/bin/generate_configuration``
:Debian: ``/usr/lib/perfsonar/bin/generate_configuration``

.. _config_files-meshconfig-scripts-generate_gui_configuration:

GUI/Dashboard Configuration Generator
#####################################
:Description: The script used to generate a `MaDDash configuration file <http://software.es.net/maddash/config_server.html>`_ from a downloaded central configuration file
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/mesh_config/bin/generate_gui_configuration``
:RedHat: ``/usr/lib/perfsonar/bin/generate_gui_configuration``
:Debian: ``/usr/lib/perfsonar/bin/generate_gui_configuration``

.. _config_files-meshconfig-scripts-lookup_hosts:

Dynamic Host List Generator
###########################
:Description: The script used to contact the lookup service and build a set of hosts to be used in the mesh
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/mesh_config/bin/lookup_hosts``
:RedHat: ``/usr/lib/perfsonar/bin/lookup_hosts``
:Debian: ``/usr/lib/perfsonar/bin/lookup_hosts``

Installed Cron Jobs
-------------------

.. _config_files-meshconfig-cron-generate_configuration:

Test Configuration Generator Cron
#####################################
:Description: Runs the :ref:`test configuration generator <config_files-meshconfig-scripts-generate_configuration>` every night at 2AM
:RedHat (<v3.5.1): ``/etc/cron.d/cron-mesh_config_agent``
:RedHat: ``/etc/cron.d/perfsonar-meshconfig-agent``
:Debian: ``/etc/cron.d/perfsonar-meshconfig-agent``

.. _config_files-meshconfig-cron-generate_gui_configuration:

GUI/Dashboard Configuration Generator Cron
###########################################
:Description: Runs the :ref:`GUI configuration generator <config_files-meshconfig-scripts-generate_gui_configuration>` every night at 2AM
:RedHat (<v3.5.1): ``/etc/cron.d/cron-mesh_config_gui_agent``
:RedHat: ``/etc/cron.d/perfsonar-meshconfig-guiagent``
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
:RedHat (<v3.5): ``/etc/owampd/owampd.conf``
:Debian (<v3.5): ``/etc/owampd/owampd.conf``
:RedHat: ``/etc/owamp-server/owamp-server.conf``
:Debian: ``/etc/owamp-server/owamp-server.conf``
:Documentation: :doc:`config_owamp`

.. _config_files-owamp-conf-limits:

Limits File
##########################

:Description: The OWAMP limits file that defines authentication and authorization parameters for testing
:RedHat (<v3.5): ``/etc/owampd/owampd.limits``
:Debian (<v3.5): ``/etc/owampd/owampd.limits``
:RedHat: ``/etc/owamp-server/owamp-server.limits``
:Debian: ``/etc/owamp-server/owamp-server.limits``
:Documentation: :doc:`config_owamp_limits`


Important Scripts
-----------------

.. _config_files-owamp-scripts-startup:

Start-up Script
##########################

:Description: The script used to start/stop/restart an OWAMP server
:RedHat (<v3.5): ``/etc/init.d/owampd``
:Debian (<v3.5): ``/etc/init.d/owampd``
:RedHat: ``/etc/init.d/owamp-server``
:Debian: ``/etc/init.d/owamp-server``

Log Files
---------

.. _config_files-owamp-logs-primary:

Primary Log file
##########################
:Description: OWAMP servers and clients can each write to log files. The location of the log file is dependent on your syslog configuration. The entries in this table assume a default configuration. 
:RedHat: **RPM Only**: ``/var/log/messages`` **Toolkit:** ``/var/log/perfsonar/owamp_bwctl.log``
:Debian: ``/var/log/messages`` 

Regular Testing
================

Configuration Files
--------------------

.. _config_files-regtesting-conf-main:

Main Configuration File
#############################
:Description: The main configuration file for Regular Testing that describes the schedule of tests to run.
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/regular_testing/etc/regular_testing.conf``
:RedHat: ``/etc/perfsonar/regulartesting.conf``
:Debian: ``/etc/perfsonar/regulartesting.conf``
:Documentation: :doc:`config_regular_testing`

.. _config_files-regtesting-conf-logging:

Logging Configuration File
#############################
:Description: Configuration file for setting log location, level of detail and various other log-related settings.
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/regular_testing/etc/regular_testing-logger.conf``
:RedHat: ``/etc/perfsonar/regulartesting-logger.conf``
:Debian: ``/etc/perfsonar/regulartesting-logger.conf``
:Documentation: `Log4perl Reference <http://search.cpan.org/~mschilli/Log-Log4perl-1.46/lib/Log/Log4perl.pm>`_

Important Scripts
-----------------

.. _config_files-regtesting-scripts-startup:

Start-up Script
##########################
:Description: The script used to start/stop/restart Regular Testing
:RedHat (<v3.5.1): ``/etc/init.d/regular_testing``
:RedHat: ``/etc/init.d/perfsonar-regulartesting``
:Debian: ``/etc/init.d/perfsonar-regulartesting``


Log Files
---------

.. _config_files-regtesting-logs-primary:

Primary Log file
##########################
:Description: The log file to which Regular Testing writes as configured in the default :ref:`logging configuration file <config_files-regtesting-conf-logging>`
:RedHat (<v3.5.1): ``/var/log/perfsonar/regular_testing.log``
:RedHat: ``/var/log/perfsonar/regulartesting.log``
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
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/toolkit/etc/clean_esmond_db.conf``
:RedHat: ``/etc/perfsonar/toolkit/clean_esmond_db.conf``
:Debian: ``/etc/perfsonar/toolkit/clean_esmond_db.conf``
:Documentation: :ref:`multi_ma_backups-delete`


Important Scripts
-----------------

.. _config_files-toolkit-scripts-nptoolkit_configure:

Toolkit Configuration Script
###########################################
:Description: A script to help configure users and other basic features of the Toolkit. 
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/toolkit/scripts/nptoolkit-configure.py``
:RedHat: ``/usr/lib/perfsonar/scripts/nptoolkit-configure.py``
:Debian: ``/usr/lib/perfsonar/scripts/nptoolkit-configure.py``
:Documentation: :doc:`manage_users`

.. _config_files-toolkit-scripts-config_daemon:

Configuration Daemon Start-up Script
#######################################
:Description: The script used to start/stop/restart the service used by the administrative web interface to configure the host
:RedHat (<v3.5.1): ``/etc/init.d/config_daemon``
:RedHat: ``/etc/init.d/perfsonar-configdaemon``
:Debian: ``/etc/init.d/perfsonar-configdaemon``

.. _config_files-toolkit-scripts-configure_nic_parameters:

Network Interface Card Configuration Script
###########################################
:Description: The script detects if NDT or NPAD is running and makes necessary configuration changes to NIC if they are. 
:RedHat (<v3.5.1): ``/etc/init.d/configure_nic_parameters``
:RedHat: ``/etc/init.d/perfsonar-configure_nic_parameters``
:Debian: ``/etc/init.d/perfsonar-configure_nic_parameters``

.. _config_files-toolkit-scripts-generate_motd:

'Message of the Day' Script
###########################################
:Description: Generates the login message on start-up that appears to command-line users
:RedHat (<v3.5.1): ``/etc/init.d/generate_motd``
:RedHat: ``/etc/init.d/perfsonar-generate_motd``
:Debian: ``/etc/init.d/perfsonar-generate_motd``

.. _config_files-toolkit-scripts-psb_to_esmond:

Measurement Archive Upgrade Script
###########################################
:Description: Upgrades data from a pre-3.4 Toolkit to the current version. If there is no data to upgrade then it exits.
:RedHat (<v3.5.1): ``/etc/init.d/psb_to_esmond``
:RedHat: ``/etc/init.d/perfsonar-psb_to_esmond``
:Debian: ``/etc/init.d/perfsonar-psb_to_esmond``

.. _config_files-toolkit-scripts-mod_interface_route:

Multi-Interface Routing Setup Script
###########################################
:Description: A script to help with the configuration of routing for hosts running tests on multiple interfaces.
:RedHat (<v3.5.1): ``/opt/perfsonar_ps/toolkit/scripts/mod_interface_route``
:RedHat: ``/usr/lib/perfsonar/scripts/mod_interface_route``
:Debian: ``/usr/lib/perfsonar/scripts/mod_interface_route``
:Documentation: :doc:`manage_dual_xface`


Installed Cron Jobs
-------------------

.. _config_files-toolkit-cron-clean_esmond_db:

Measurement Archive Data Cleaner
#####################################
:Description: Cleans out data in the measurement archive according to retention policy in :ref:`config_files-toolkit-conf-clean_esmond_db`. Runs at 2:30AM every morning.
:RedHat (<v3.5.1): ``/etc/cron.d/cron-clean_esmond_db``
:Debian: *N/A*

.. _config_files-toolkit-cron-service_watcher:

Regular Service Restarts and Maintenance
###########################################
:Description: Verifies expected processes are running every hour and performs a regular restart of services that require it every moring at 1:05AM. It also cleans out stale files from OWAMP and Regular Testing at this time.
:RedHat (<v3.5.1): ``/etc/cron.d/cron-service_watcher``
:Debian: *N/A*

Log Files
---------

.. _config_files-toolkit-logs-config_daemon:

Configuration Daemon Log
##########################
:Description: The log file for the :ref:`configuration daemon <config_files-toolkit-scripts-config_daemon>`
:RedHat (<v3.5.1): ``/var/log/perfsonar/config_daemon.log``
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
:RedHat (<v3.5.1): ``/var/log/perfsonar/service_watcher.log`` and ``/var/log/perfsonar/service_watcher_error.log``
:RedHat: ``/var/log/perfsonar/servicewatcher.log`` and ``/var/log/perfsonar/servicewatcher_error.log``
:Debian: ``/var/log/perfsonar/servicewatcher.log`` and ``/var/log/perfsonar/servicewatcher_error.log``
:Debian: *N/A*

Web Interface Logs
################################
:Description: Log files for the web interface.
:RedHat: ``/var/log/perfsonar/web_admin/web_admin.log``
:Debian: ``/var/log/perfsonar/web_admin/web_admin.log``

