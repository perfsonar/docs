*************
Configuration
*************

Most of the configuration files for PWA can be found in the ``/etc/pwa`` directory. At a minimum, you need to configure the datasources for your instance, configure the authentication module, and create a user before you can start using PWA.

**Note:** If you are upgrading from an old MCA instance, view the docs on `Upgrading from MCA to PWA <pwa_upgrading_from_mca>`_



Data Sources
============

``/etc/pwa/index.js`` lists the Global Lookup Service and any private LSes that host information is pulled from. 


Global SLS
----------

A sample datasource entry for the Global SLS:

::

    "gls": {
        label: 'GLS',
        type: 'global-sls',
        activehosts_url: 'http://ps1.es.net:8096/lookup/activehosts.json',
        query: '?type=service',
    },

* "gls" is used as internal key to identify this datasource. Pick one that's unique.
* label: is used to show the datasource name in the web UI
* type: needs to be "global-sls" for Global SLS datasource.
* activehosts_url: should always point to http://ps1.es.net:8096/lookup/activehosts.json unless you know a different global registry.
* query: This query is passed to all sLS instances that are member of the global registry. You will always want ``?type=service``, at the very least. For more detail on sLS query, see below.

Global SLS, filtered
--------------------

You can define a query for the SLS instance, so if you want host datasources set differently depending on what communities they are in (or other parameters), you can do so.

A sample of filtered Global SLS datasource:

::

    "osg": {
        label: 'OSG',
        type: 'global-sls',
        activehosts_url: 'http://ps1.es.net:8096/lookup/activehosts.json',
        query: '?type=service&group-communities=OSG',
    },

* "osg" is used as internal key to identify this datasource. Pick one that's unique.
* label: is used to show the datasource name in the web UI
* type: needs to be "global-sls" for Global SLS datasource.
* activehosts_url: should always point to http://ps1.es.net:8096/lookup/activehosts.json unless you know a different global registry.
* query: This query is passed to all sLS instances that are member of the global registry. For more detail on sLS query, please refer to `sLS API Spec <https://github.com/esnet/simple-lookup-service/wiki/APISpec#query>`_

So, the above sample datasource entry instructs mca-cache service to pull all service records (used to construct "hosts" for PWA) from the global lookup service (ps1.es.net) with community registered to "OSG". If you don't want any hosts from OSG, simply remove this section, or update the label and group-communities to something other than OSG.

As you may find in the default ``/etc/pwa/index.js``, you can list as many datasources as you want. Make sure to use a unique key, and label.

sLS
--------

If you have a private sLS instance, enter something like following, replacing ``sls_hostname`` with your sLS hostname:

::

    "wlcg": {
        label: 'WLCG',
        type: 'sls',
        url: 'https://sls_hostname/sls/lookup/records/?type=service&group-communities=WLCG',
        cache: 1000*60*5, //refresh every 5 minutes (default 30 minutes)
    },

* "wlcg" is used as internal key to identify this datasource. Pick one that's unique
* label: is used to show the datasource name in the web UI
* type: needs to be 'sls'
* url: URL for your private sLS instance. For type off queries, please refer to `sLS API Spec <https://github.com/esnet/simple-lookup-service/wiki/APISpec#query>`_
* cache: refrequency of polling from this sLS in msec.

When you update this file, all PWA services will automatically restart. Please monitor logs by doing ``sudo docker exec -it pwa-admin1 pm2 logs``

Database 
============

The database is also configured in ``/etc/pwa/index.js``

::

    exports.mongodb = "mongodb://mongo/pwa";


When you update this file, all meshconfig services will automatically restart. Please monitor logs by doing  ``sudo docker exec -it pwa-admin1 pm2 logs``

Test Spec Default parameters
============================

``index.js`` contains default values for various test specification. Update this to your liking (please send us comments if we should be using a different default).

When you update this file, all meshconfig services will automatically restarts. Please monitor logs by doing ``sudo docker exec -it pwa-admin1 pm2 logs``

Logging
========================

``index.js`` also contains logging related configuration. It's unlikely you need to change this, but if you want to  enable debug logging, for instance, you would change:

``level: 'info',``

to

``level: 'debug',``

PWA uses Winston for logging. Please see `Winston <https://github.com/winstonjs/winston>`_ for more detail. 

Others
========================

``index.js`` contains all other configuration such as ports and host names to bind PWA server and PWA publisher. It also contain information such as the location of JWT public key to verify token issued by SCA authentication service.

Authentication Service (sca-auth)
=================================

PWA uses authentication microservices originally developed by SCA (Scalable Computing Archive) group at IU. You can enable / disable various authentication methods provided by sca-auth by modifying ``/etc/pwa/auth/index.js``

Certain features in PWA are restricted to only super-admin. In order to become a super-admin, you will need to run following as root via the command line.

::

    docker exec -it sca-auth /app/bin/auth.js modscope --username user --add '{"pwa": ["admin"]}'

You need to sign out & login again in order for this change to take effect.

Please refer to `sca-auth gitrepo <https://github.com/perfsonar/sca-auth>`_ for more information.

User Management
================

By default, signup is disabled and no users exist. You will need either manually create users (see the next page for details), and/or allow signups 

To enable user signup (registration through the web form), set these values in the following files:

``/etc/pwa/auth/index.js``

::
    
    allow_signup: true

``/etc/pwa/shared/auth.ui.js``

::
    
    signup: true

