
Monitoring
----------

Once everything is configured, you should now be able to access PWA by accessing your host on your browser. You should be prompted to the login page. You should signup / confirm your email address, then define host groups / testspecs, and construct new meshconfig using those test entries.

PWA reports the current health status via following API endpoint (for pwa-admin and pwa-cache)

``https://<hostname>/pwa/api/pwa/health``

.. code-block:: javascript

   {
       status: "ok",
       msg: "everything looks good",
       cache: {
           hosts: 255,
           update_time: 1486994021924
       }
   }

You can configure your monitoring systems (Sensu, Nagios, etc..) to check for ``status`` and make sure it's set to 'ok'. 

For pwa-pub instances, you should run separate test at ``http://<hostname>/pwa/pub/health`` (not https://)

.. code-block:: javascript

   {
       status: "ok"
   }

..

   Please note.. if you are running multiple instances of pwa-pub, then /pub/health is just from one of the instances (not all)


You should also monitor the authentication service status

``https://<hostname>/pwa/api/auth/health``

.. code-block:: javascript

   {
       status: "ok",
       headers: {...}
   }

You can also monitor docker stdout/stderr log - similar to syslog:

``sudo docker exec -it pwa-admin1 pm2 logs``
