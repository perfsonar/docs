.. role:: raw-html-m2r(raw)
   :format: html


pSConfig Web Administrator (PWA)
================================

PWA is a pSConfig Web-based administration GUI and tools to publish configs in pSConfig/MeshConfig formats. The current deployment model for PWA utilizes Docker containers. RPM/DEB packaging is planned.


.. image:: images/pwa/pwa_install.png
   :target: images/pwa/pwa_install.png
   :alt: Alt text


Installation
------------

VM Host
^^^^^^^

To install PWA, you will need a VM with any OS that supports Docker, such as CentOS7

Minimum resource requirements are..


* 4-6 CPUs
* 4G memory
* 16G disk

Docker Engine
^^^^^^^^^^^^^

Read the official `docker installation doc <https://docs.docker.com/engine/installation/>`_ for more information. For CentOS 7, the Docker version from the CentOS Extras repo will work. For CentOS 6, the CentOS version might work, or you might need to try the version from the Docker repo.

For CentOS7 as root:

.. code-block:: bash

   yum install -y docker

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



Other Topics
============

* `Monitoring / Testing <pwa_monitoring>`_
* PWA provides a developer API -- see the `API DOC <pwa_api>`_

Reference
=========

Meshconfig parameters
http://docs.perfsonar.net/config_mesh.html
