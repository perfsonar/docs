*****************
Managing Daemons
*****************
This page describes the CentOS7+/Debian daemons you should expect to see with each bundle. This page is for expert users, and may be helpful for debugging/troubleshooting.

Each perfSONAR bundle runs various services, which use one or more daemons.

List of Daemons
================

Testpoint
---------
Hosts running the perfsonar ``testpoint`` bundle should see these daemons:
           
    * *postgresql-10.service* - stores schedules of pScheduler
    * *httpd.service* - web server for pScheduler (*apache* in Debian)
    * *fail2ban.service* - intrusion detection system (IDS) to log suspicious activity
    * *firewalld.service* - firewall service
    * *ntpd.service* - NTP time synchronisation
    * *owamp-server.service* - OWAMP
    * *twamp-server.service* - TWAMP
    * *perfsonar-lsregistrationdaemon.service* - registration with the Lookup Service
    * *psconfig-pscheduler-agent.service* - reads pSConfig templates and generates a set of pScheduler tasks
    * *pscheduler-archiver.service* - executes archiver plug-ins using the results of runs
    * *pscheduler-runner.service* - executes runs on the schedule using the selected tool
    * *pscheduler-scheduler.service* - puts new runs on the schedule or marks a run as a non-starter if it can not find an available slot
    * *pscheduler-ticker.service* - handles basic maintenance of pScheduler

Toolkit
-------
Hosts running the perfsonar ``toolkit`` bundle should see all daemons running in the ``testpoint`` **plus additional**:

    * *perfsonar-configdaemon.service* - used by the administrative web interface to configure the host
    * *perfsonar-configure_nic_parameters* - detects if the NIC is misconfigured, and makes necessary configuration changes to NIC
    * *perfsonar-generate_motd* - takes care of Message of The Day
    * *perfsonar-lscachedaemon.service* - perfSONAR Lookup Service cache daemon
    * *logstash.service* - used to format and annotate results from pScheduler before storing in OpenSearch
    * *opensearch.service* - stores measurement results
    * *elmond.service* - backward compatibility interface that speaks the Esmond API from perfSONAR 4.X and earlier.

For selected services in ``toolkit`` the status is listed in the Toolkit GUI main page *Services* tab.

Archive
----------
Hosts running an ``archive`` bundle should see these daemons:

    * *httpd.service* - web server
    * *logstash.service* - used to format and annotate results from pScheduler before storing in OpenSearch
    * *opensearch.service* - stores measurement results
    * *elmond.service* - backward compatibility interface that speaks the Esmond API from perfSONAR 4.X and earlier.

Showing service status
=======================
Run::

     systemctl status SERVICE-NAME

Restarting Daemons 
===================

Run::

     systemctl start/stop/restart SERVICE-NAME


Enabling/Disabling Daemons
===========================

Run::

    systemctl enable/disable SERVICE-NAME