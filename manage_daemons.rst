*****************
Managing Daemons
*****************

Under contruction!

This page is for expert users, and may be helpful for debugging/troubleshooting.

Each perfSONAR bundle runs various services, which use one or more daemons.

This page describes the CentOS7/Debian daemons you should expect to see with each bundle.

List of Daemons
================

Hosts running the perfsonar 'testpoint' bundle should see these daemons:

systemd services:

::

  # OWAMP
  owamp-server.service  
  # NTP, required by several services
  ntpd.service                       
  # registration with the Lookup Service
  perfsonar-lsregistrationdaemon.service 
  # Mesh configuration
  perfsonar-meshconfig-agent.service    
  # needed by pscheduler
  postgresql-9.5.service               
  httpd.service                       
  # security services
  fail2ban.service                  
  firewalld.service                
  # legacy bwctl service
  bwctl-server.service  

SysVinit pscheduler services (soon to be converted to systemd services)

::

  chkconfig --list | grep pscheduler
  pscheduler-archiver	0:off	1:off	2:on	3:on	4:on	5:on	6:off
  pscheduler-runner	0:off	1:off	2:on	3:on	4:on	5:on	6:off
  pscheduler-scheduler	0:off	1:off	2:on	3:on	4:on	5:on	6:off
  pscheduler-ticker	0:off	1:off	2:on	3:on	4:on	5:on	6:off


In addition to these, hosts running the full perfSONAR Toolkit should see these daemons:

::

  perfsonar-configdaemon	0:off	1:off	2:on	3:on	4:on	5:on	6:off
  perfsonar-configure_nic_parameters	0:off	1:off	2:on	3:on	4:on	5:on	6:off
  perfsonar-generate_motd	0:off	1:off	2:on	3:on	4:on	5:on	6:off
  perfsonar-lscachedaemon	0:off	1:off	2:on	3:on	4:on	5:on	6:off
  perfsonar-psb_to_esmond	0:off	1:off	2:on	3:on	4:on	5:on	6:off

  # used by esmond DB
  mysqld         	0:off	1:off	2:on	3:on	4:on	5:on	6:off
  cassandra      	0:off	1:off	2:on	3:on	4:on	5:on	6:off



Hosts running a central MA should see these daemons:

**add list here**

Restarting Daemons 
===================

Run:

::

   service servicename start/stop/restart


Enabling/Disabling Daemons
===========================

Run:

::

   systemctl enable/disable servicename

