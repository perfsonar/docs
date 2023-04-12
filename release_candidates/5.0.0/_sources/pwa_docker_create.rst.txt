Creating Docker containers
=============================================

**If you are not using Docker, SKIP THIS PAGE**

Creating containers using `docker-compose`
-----------------------------------------------


*Note* make sure you have extracted the sample configs here:

:doc:`pwa_install_docker`

Run this script to create your nginx certs, if you don't already have them:

.. code-block:: shell

    /etc/pwa/scripts/generate_nginx_cert.sh

Download the ``docker-compose.yml`` file from here:

https://raw.githubusercontent.com/perfsonar/psconfig-web/master/deploy/docker/docker-compose.yml

Bring up the application:

.. code-block:: shell

    docker-compose up -d

Make sure the containers are running:


.. code-block:: shell

    # docker-compose ps

          Name                      Command               State                             Ports
    ------------------------------------------------------------------------------------------------------------------------
    docker_mongo_1        docker-entrypoint.sh mongod      Up      27017/tcp
    docker_nginx_1        /docker-entrypoint.sh ngin ...   Up      0.0.0.0:443->443/tcp, 0.0.0.0:80->80/tcp,
                                                                   0.0.0.0:9443->9443/tcp
    docker_pwa-admin1_1   docker-entrypoint.sh /start.sh   Up      80/tcp, 8080/tcp
    docker_pwa-pub1_1     node /app/api/pwapub.js          Up      8080/tcp
    docker_sca-auth_1     docker-entrypoint.sh /app/ ...   Up      80/tcp, 8080/tcp

If not everything is running, try ``docker-compose logs`` to troubleshoot.

Docker Compose documentation can be found here:

https://docs.docker.com/compose/

Creating containers using a script
-----------------------------------------------

Now we have all configuration files necessary to start installing PWA services.

The easiest way to get the necessary containers installed and running is to use these scripts. You may want to modify them if you are doing something other than a default setup.

Default setup uses a ``pwa`` docker network, data under ``/usr/local/data``, one publisher named ``pwa-pub1``, one PWA application named ``pwa-admin1``, and one ``sca-auth`` instance named ``sca-auth``. It also initializes ``mongodb`` and ``nginx`` instances. By default, a ``postfix`` instance is not created, so if you want to use that you'll have to modify the script.

Only run this script when you initially install PWA:

.. code-block:: shell

    /usr/local/sbin/init_docker.sh

Then, you can use this script to start the containers:

.. code-block:: shell

    /usr/local/sbin/start_pwa_containers.sh

Updating containers with a script
-----------------------------------

To update PWA containers to the latest version, use this script (you may have to modify it, if you changed ``init_docker.sh`` or ``start_pwa_containers.sh`` above).

.. code-block:: shell

    /usr/local/sbin/update_pwa_containers.sh


Manually creating containers
-------------------------------------------

If you want a custom setup, or if you are trying to troubleshoot the containers, you may want to manually create the containers.

#. 
   First, create the ``data`` directory:

   .. code-block:: shell

       mkdir -p /usr/local/data

#. 
   Next, create a docker network to group all PWA containers 

   .. code-block:: shell

       docker network create pwa

#. 
   Create mongoDB container. Use -v to persist data on host directory (/usr/local/data/mongo)

   .. code-block:: shell

       mkdir -p /usr/local/data
       docker run \
               --restart=always \
               --net pwa \
               --name mongo \
               -v /usr/local/data/mongo:/data/db \
               -d mongo

#. 
   Create SCA authentication service container. This service handles user authentication / account/user group management.

   .. code-block:: shell

       docker run \
           --restart=always \
           --net pwa \
           --name sca-auth \
           -v /etc/pwa/auth:/app/api/config \
           -v /usr/local/data/auth:/db \
           -d perfsonar/sca-auth

   ..

       The sca-auth container will generate a few files under the /config directory when it's first started, so don't mount it with ``ro``.
       The user account DB is stored in ``/usr/local/data/auth``.


#. 
   Create PWA's main UI/API container.

   .. code-block:: shell

       docker run \
           --restart=always \
           --net pwa \
           --name pwa-admin1 \
           -v /etc/pwa:/app/api/config:ro \
           -d perfsonar/pwa-admin

#. 
   Create meshconfig publishers.

   .. code-block:: shell

       docker run \
           --restart=always \
           --net pwa \
           --name pwa-pub1 \
           -v /etc/pwa:/app/api/config:ro \
           -d perfsonar/pwa-pub

    You can create as many pwa-pub containers as desired (make sure to use unique names ``pwa-pub1``\ , ``pwa-pub2``\ , etc..) based on available resource (mainly CPU) . 1 or 2 should be fine for most cases.

    If you use more than 1 instance, please edit ``/etc/pwa/nginx/conf.d/pwa.conf`` to include all instances, like..

    .. code-block:: javascript

       upstream pwapub {
           server pwa-pub1:8080;
           server pwa-pub2:8080;
           server pwa-pub3:8080;
       }


#. 
   Finally, we install nginx to expose these container via 80/443/9443

   .. code-block:: shell

       docker run \
           --restart=always \
           --net pwa \
           --name nginx \
           -v /etc/pwa/shared:/shared:ro \
           -v /etc/pwa/nginx:/etc/nginx:ro \
           -v /etc/pwa/auth:/certs:ro \
           -p 80:80 \
           -p 443:443 \
           -p 9443:9443 \
           -d nginx

#. 
   Start the ``postfix`` container (optional)

   The ``sca-auth`` service sometimes needs to send e-mails to users, as part of the registration process, or for password resets, etc. It can be configured to use an external SMTP server, or you can run a separate docker container that runs postfix, in which case PWA will send its e-mail notices through that.

   If you are not using an external SMTP server, install a postfix docker container. This one has been tested and appears to work well, but it is not maintained by the perfSONAR project:

   `Docker-postfix <https://hub.docker.com/r/yorkshirekev/postfix/>`_

   .. code-block:: shell

           docker run \
               --network pwa \
               -d --name postfix \
               -p 587:25 \
               --restart always \
               yorkshirekev/postfix HOSTNAME

    Make sure to replace HOSTNAME with the actual hostname of the main host.
    You might need to try different ports for ``-p 587:25``\ , depending on what is available on the main host.

Manually updating
------------------

Pull down the latest version using (for example):

.. code-block:: shell

  docker pull perfsonar/pwa-admin1
  docker pull perfsonar/pwa-pub1
  docker pull perfsonar/sca-auth

Then stop and remove each container you wish to upgrade -- for example:

.. code-block:: shell
   
   docker stop pwa-admin1
   docker rm pwa-admin1
   docker stop pwa-pub1
   docker rm pwa-pub1
   docker stop sca-auth
   docker rm sca-auth


Re-run the container using the same ``docker run ...`` command you used to start it.


