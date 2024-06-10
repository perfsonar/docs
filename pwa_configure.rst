*************
Configuration
*************


This guide assumes you have already pulled down the sample PWA config, either from RPM packages, or a manual step in the Docker installation.

Most of the configuration files for PWA can be found in the ``/etc/perfsonar/psconfig-web`` directory. At a minimum, you need to configure your hostname, configure the datasources for your instance, configure the authentication module, and create a user before you can start using PWA.

**Interaction with other web applications:** If you want to run PWA via Docker, on a node that is already running other web applications, such as the perfSONAR Toolkit web interface, you will need to do a couple things differently. See `Running alongside other web applications <pwa_running_alongside>`_

If you are running an RPM-based install, you likely won't have to do anything differently.

**Upgrading:** If you are upgrading from an old MCA instance, view the docs on `Upgrading from MCA to PWA <pwa_upgrading_from_mca>`_

When you update ``/etc/perfsonar/psconfig-web/index.js``, all PWA services will automatically restart. Please monitor logs by doing  ``sudo docker exec -it pwa-admin1 pm2 logs``

Hostname
========

* 
  Update the publisher URL with the hostname of your PWA instance. Most likely, this will be the full hostname of your Docker host. Replace ``<hostname>`` or ``<pwa_hostname>`` with your full hostname, like this.

If your hostname is ``pwa.example.com``,

.. code-block:: javascript

    url: "http://<pwa_hostname>/pwa/pub/",

becomes

.. code-block:: javascript

        url: "http://pwa.example.com/pwa/pub/",

Database 
============

The database is also configured in ``/etc/perfsonar/psconfig-web/index.js``

::

    exports.mongodb = "mongodb://localhost/pwa";



Data Sources
============

``/etc/perfsonar/psconfig-web/index.js`` lists the Global Lookup Service and any private LSes that host information is pulled from. 

In most cases, you won't need to change the LS configuration.


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

So, the above sample datasource entry instructs the PWA cache service to pull all service records (used to construct "hosts" for PWA) from the global lookup service (ps1.es.net) with community registered to "OSG". If you don't want any hosts from OSG, simply remove this section, or update the label and group-communities to something other than OSG.

As you may find in the default ``/etc/perfsonar/psconfig-web/index.js``, you can list as many datasources as you want. Make sure to use a unique key, and label.

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


Test Spec Default parameters
============================

``index.js`` contains default values for various test specification. Update this to your liking (please send us comments if we should be using a different default).

When you update this file, all PWA services will automatically restart. Please monitor logs by doing ``sudo docker exec -it pwa-admin1 pm2 logs`` 

if running Docker, or

``/var/log/messages`` if running RPMs

Logging
========================

``index.js`` also contains logging related configuration. It's unlikely you need to change this, but if you want to  enable debug logging, for instance, you would change:

``level: 'info',``

to

``level: 'debug',``

PWA uses Winston for logging. Please see `Winston <https://github.com/winstonjs/winston>`_ for more detail. 

Others
------

``index.js`` contains all other configuration such as ports and host names to bind PWA server and PWA publisher. It also contain information such as the location of JWT public key to verify token issued by the PWA authentication service.

Web server (nginx/apache)
=========================

A webserver (apache for RPM installs, nginx for docker installs) will expose various functionalities provides by various containers to the actual users. The default configuration should work, but if you need to modify the configuration, edit:

.. code-block:: bash

    /etc/perfsonar/psconfig-web/nginx

or

.. code-block:: bash

    /etc/httpd/conf.d/pwa*.conf

**Host Certificates**

You will need SSL certificates for https access. These should automatically be generated when you install/run the services, but you can also create them manually.

If you want to generate self-signed certs, you can run this script (you may wish to edit it if you are using custom file paths): 

.. code-block:: bash

    sudo /usr/local/sbin/generate_nginx_cert.sh

If you want to provide your own certs, place them in ``/etc/perfsonar/psconfig-web/nginx/certs`` with these names:

.. code-block:: bash

   cert.pem
   key.pem

If you are enabling x509 authentication, then you will also need ``trusted.pem``\ ; This file contains list of all CAs that you trust and grant access to PWA. You will have to adapt the nginx config in ``/etc/perfsonar/psconfig-web/nginx/conf.d/pwa.conf`` as follows:

.. code-block:: bash

   ssl_client_certificate /etc/nginx/certs/trusted.pem
   ssl_verify_client on

..

Unlike Apache, Nginx uses a single CA file for better performance.. so you have to join all .pem into a single ``trusted.pem file``

Typically, Apache will just work with RPM installs, but you may have to change Apache's config similarly, if using an RPM install.

Authentication Service (pwa-auth)
=================================

PWA uses authentication microservices originally developed by SCA (Scalable Computing Archive) group at IU. You can enable / disable various authentication methods provided by sca-auth by modifying the config file.

Edit the auth config file:

``/etc/perfsonar/psconfig-web/auth/index.js``

* 
 Update the hostname in the config by performing a search and replace in this file. Replace ``<pwa_hostname>`` with the hostname (FQDN) of your Docker host (remove the brackets).

* 
 Update ``from`` address to administrator's email address used to send email to confirmation new user accounts. You can do this by doing a search and replace in the file, replacing ``<email_address>`` with the full e-mail address you want to use (remove the brackets).

* 
 If you'd like to skip email confirmation when user signup, simply comment out the whole ``email_confirmation`` section.

 .. code-block:: javascript

    exports.email_confirmation = {
    subject: 'psConfig Web Admin Account Confirmation',
    from: '<email_address>'  //most mail server will reject if this is not replyable address
    };


Authentication service mail server configuration
------------------------------------------------

    Now update the ``mailer`` section depending on whether you are using a separate docker container running postfix, or specifying an SMTP server.

    **Using a separate postfix docker container**

    Replace ``postfix`` with the actual name of the postfix container, if you are running it under a different name.

    .. code-block:: javascript

       mailer: {
           host: 'postfix',
           secure: false,
           port: 25,
           tls: {
                   // do not fail on invalid certs
                   rejectUnauthorized: false
           }
       }

**OR**

**Using external SMTP server**

    .. code-block:: javascript

       // example config with SMTP server; make sure the pass path exists, or things will break
       // alternatively, hard-code the password if this is acceptable in your environment
       mailer: {
           host: 'mail-relay.domain.com',
           secure: true,
           auth: {
               user: 'username',
               pass: fs.readFileSync(__dirname+'/smtp.password', {encoding: 'ascii'}).trim(),
           }
       }


User Registration
=================

By default, signup is disabled and no users exist. You will need either manually create users once the docker containers have been created (see the next page for details), and/or allow signups.

To enable user signup (registration through the web form), set these values in the following files:

``/etc/perfsonar/psconfig-web/auth/index.js``

::
    
    allow_signup: true

``/etc/perfsonar/psconfig-web/shared/auth.ui.js``

::
    
    signup: true

