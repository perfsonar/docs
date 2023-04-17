######################################
Docker Installation
######################################

.. role:: raw-html-m2r(raw)
   :format: html

**If you are installing with RPMs, SKIP THIS PAGE**


VM Host
^^^^^^^

To install PWA, you will need a VM with any OS that supports Docker, such as CentOS7

Minimum resource requirements are..


* 4-6 CPUs
* 4G memory
* 16G disk

Docker Engine
^^^^^^^^^^^^^

For CentOS 7, the Docker version from the CentOS Extras repo will work.

For CentOS7 as root:

.. code-block:: bash

   yum install -y docker

If that doesn't work, or if you want a newer Docker version, or if on another platform, read the official `docker installation doc <https://docs.docker.com/engine/installation/>`_ for more information. PWA will work fine with the newer Docker versions, as well.

Before you start the docker engine, you might want to add any VM specific configuration. For example, your VM might be using /usr/local as a primary partition for your VM. If so, you should have something like following..

.. code-block:: bash

   mkdir /etc/docker

``/etc/docker/daemon.json``

.. code-block:: json

   {
           "graph": "/usr/local/docker"
   }

Enable & start the docker engine.

.. code-block:: bash

   $ systemctl enable docker
   $ systemctl start docker

You should install logrotate for docker container log

/etc/logrotate.d/docker-container

.. code-block:: bash

   /var/lib/docker/containers/*/*.log {
     rotate 7
     daily
     compress
     size=1M
     missingok
     delaycompress
     copytruncate
   }

Sample Configuration
^^^^^^^^^^^^^^^^^^^^


This guide assumes you have already pulled down the sample PWA config and extracted it like this (you should have done this during the Install step; if not, do it now:

.. code-block:: bash

   wget https://github.com/perfsonar/psconfig-web/raw/master/deploy/docker/pwa.sample.tar.gz
   sudo tar -C /etc -xvf pwa.sample.tar.gz pwa && sudo tar -C /etc/pwa -xvf pwa.sample.tar.gz scripts



Other Topics
============

* `Monitoring / Testing <pwa_monitoring>`_
* PWA provides a developer API -- see the `API DOC <pwa_api>`_

Reference
=========

Meshconfig parameters
http://docs.perfsonar.net/config_mesh.html

