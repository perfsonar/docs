Operational Guide
######################################

Service Status
===============

MCA uses pm2 to monitor various MCA realted services and load-balance incoming requests. You can see a list of services by ..

::

    root@8f480cb15257 /]# su - mca
    [mca@8f480cb15257 ~]$ pm2 list
    ┌──────────┬────┬──────┬─────┬────────┬─────────┬────────┬──────────────┬──────────┐
    │ App name │ id │ mode │ pid │ status │ restart │ uptime │ memory       │ watching │
    ├──────────┼────┼──────┼─────┼────────┼─────────┼────────┼──────────────┼──────────┤
    │ profile  │ 0  │ fork │ 234 │ online │ 0       │ 18h    │ 70.754 MB    │  enabled │
    │ auth     │ 1  │ fork │ 238 │ online │ 0       │ 18h    │ 79.684 MB    │  enabled │
    │ mcadmin  │ 2  │ fork │ 242 │ online │ 0       │ 18h    │ 86.453 MB    │  enabled │
    │ mccache  │ 3  │ fork │ 244 │ online │ 0       │ 18h    │ 114.012 MB   │  enabled │
    │ mcpub    │ 4  │ fork │ 248 │ online │ 0       │ 18h    │ 75.031 MB    │  enabled │
    └──────────┴────┴──────┴─────┴────────┴─────────┴────────┴──────────────┴──────────┘
     Use `pm2 show <id|name>` to get more details about an app

.. note:: Docker container runs all services under root, so you don't need to do "su - mca" before running pm2 commands

profile and auth services provide MCA authentication and profile settings service. mcadmin is the main MCA UI (server side component), and mcpub generates MeshConfing to be downloaded by external services. You can safely shutdown / restart mcadmin without impacting mcpub service. mccache periodically loads host information from configured sLS and global LS instances.

You should see all service to show "online" with small number of restart (if you update configuration for any service, the service will be automatically restarted, so you will see non-0 restart in such case). You can reset restart count by

::

    pm2 reset mcadmin

or

::

    pm2 reset all

You can monitor realtime stats of each services via

::

    pm2 monit

For more information on pm2, please see `PM2 <http://pm2.keymetrics.io/>`_


Log files
============

/var/log/sca

::

    [root@8f480cb15257 mca]# ls -lrt
    total 18308
    -rw-rw-r-- 1 mca mca       77 Jan 22 02:11 profile.err
    -rw-rw-r-- 1 mca mca     1303 Jan 22 02:11 pub.err
    -rw-rw-r-- 1 mca mca     1976 Jan 22 02:14 pub-4.log
    -rw-rw-r-- 1 mca mca      112 Jan 22 02:30 auth.err
    -rw-rw-r-- 1 mca mca    13065 Jan 22 02:30 auth-1.log
    -rw-rw-r-- 1 mca mca     4079 Jan 22 02:31 admin.err
    -rw-rw-r-- 1 mca mca    71736 Jan 22 02:31 admin-2.log
    -rw-rw-r-- 1 mca mca    32915 Jan 22 02:31 profile-0.log
    -rw-rw-r-- 1 mca mca   198110 Jan 22 20:14 cache-3.log
    -rw-rw-r-- 1 mca mca 18390157 Jan 22 20:37 cache.err

Backup (Volatile Data)
==============

MCA stores MeshConfig related information in postgreSQL. For RHEL7, postgreSQL data directory can be found in 
::
    /var/lib/pgsql/data

For RHEL6, 
::
    /opt/rh/postgresql92/root/var/lib/pgsql/data

SCA auth service stores authentication information in a sqlite3 DB at (by default)
::
    /var/lib/mca/auth.sqlite

SCA profile service stores profile information in a sqlite3 DB at (by default)
::
    /var/lib/mca/profile.sqlite

Following configuration directory should be backed-up

::

    /opt/mca/mca/api/config
    /opt/mca/auth/api/config
    /opt/mca/profile/api/config

And UI has its own set of configuration files. These should be backed-up if you have modified from the RPM installed content

::

    /opt/mca/mca/ui/config.js 
    /opt/mca/auth/ui/config.js 
    /opt/mca/profile/ui/config.js 
    /opt/mca/shared/ui/config.js 


