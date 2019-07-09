######################################
PWA RPM Installation
######################################

.. role:: raw-html-m2r(raw)
   :format: html

**If you are installing with Docker, SKIP THIS PAGE**

Host Requirements
^^^^^^^^^^^^^^^^^

To install PWA using RPM packages, you will need a host or VM with RHEL 7/CentOS 7.

Minimum recommended resources:

* 4 CPU cores
* 4G memory
* 30G disk
* RHEL 7/CentOS 7

perfSONAR Repo
^^^^^^^^^^^^^^

**TODO: UPDATE**

You will need to have the proper perfSONAR repo installed:

.. code-block:: bash

    yum install http://software.internet2.edu/rpms/el7/x86_64/main/RPMS/perfSONAR-repo-nightly-minor-0.9-1.noarch.rpm


Installing PWA from RPMs
^^^^^^^^^^^^^^^^^^^^^^^^

There are several packages relating to PWA:

#. **perfsonar-psconfig-web-admin-ui**
   
   * The web UI, REST API, and cache service

#. **perfsonar-psconfig-web-admin-publisher**

   * The publisher (the component from which mesh nodes and maddash pull down the configs

#. **perfsonar-psconfig-web-admin-auth**

   * The authentication module that is used for the web UI

#. **perfsonar-psconfig-web-admin-shared**

   * Shared libraries for the PWA components (not useful by itself)

To install all of PWA at once. On CentOS7, run this as root (the other packages will be installed as dependencies):

.. code-block:: bash

   yum install -y perfsonar-psconfig-web-admin-ui perfsonar-psconfig-web-admin-publisher

It is also possible to install only specific components; you could run just a publisher on one host, and the UI on a different host, for instance.

Installing just the UI:

.. code-block:: bash

   yum install -y perfsonar-psconfig-web-admin-ui

Installing just the publisher:

.. code-block:: bash

   yum install -y perfsonar-psconfig-web-admin-publisher

Before you start the docker engine, you might want to add any VM specific configuration. For example, your VM might be using /usr/local as a primary partition for your VM. If so, you should have something like following..

By default, your configuration files will be placed under:

* ``/etc/perfsonar/psconfig-web``

PWA code and libraries will be stored under:

* ``/usr/lib/perfsonar/psconfig-web-admin``

Data will be stored under:

* ``/var/lib/perfsonar/psconfig-web-admin``

Managing Services
^^^^^^^^^^^^^^^^^

The PWA services are managed by ``systemd``, as with any standard daemon. Upon installing the packages, the appropriate servies will be enabed and started.

Getting the status of the services, run this as root:

.. code-block:: bash

    systemctl status perfsonar-psconfig-web-admin-*

Similarly, you can (re)start/enable/disable services using ``systemctl``

Depending on which packages you installd, the following daemons are available:

UI API:

* ``perfsonar-psconfig-web-admin-api``

Host/LS Cache:

* ``perfsonar-psconfig-web-admin-cache``

Publisher API:

* ``perfsonar-psconfig-web-admin-publisher``

Authentication API:

* ``perfsonar-psconfig-web-admin-auth``
