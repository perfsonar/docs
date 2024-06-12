****************************************
Testing Beta Versions of perfSONAR
****************************************

.. warning:: Please note that none of the steps in this document should be performed on production hosts. These are solely intended for development or testing hosts and may result in your host running unstable software.  


The perfSONAR project traditionally does public betas testing prior to major new releases. These are announced on the mailing lists when available. Participating in betas is open to anyone and feedback generated from these tests helps the development team formulate the best possible final release. You can help with testing by going through one or more of the following test scenarios:

* A clean installation of our Toolkit ISOs
* A clean installation of one of our CentOS bundles
* An upgrade of either a toolkit or CentOS bundle
* A clean installation of our Debian packages and/or bundles
* An upgrade of an existing Debian installation

You may consult `the testing checklist <https://github.com/perfsonar/project/wiki/Toolkit-Testing-Checklist>`_ to help guide your testing. For full instructions on how to get beta packages and ISOs, see the sections below.

.. _install_rcs-clean-isos:

Testing a Clean Installation of the Toolkit ISOs
================================================
You may download the latest beta ISOs at the following URL :

    * http://downloads.perfsonar.net/toolkit/betas/
    
Once downloaded you may follow the instructions at :doc:`install_centos_fullinstall` or :doc:`install_centos_netinstall` for step-by-step instructions on installing the software.

.. _install_rcs-clean-centos:

Testing CentOS Bundles Installation
====================================

You can test CentOS bundle installation by first pointing your existing CentOS installation at the perfSONAR main yum repository (if not already)::

    rpm -hUv http://software.internet2.edu/rpms/el7/x86_64/latest/packages/perfSONAR-repo-0.10-1.noarch.rpm
    
Next, install the staging yum repository where test versions of the software are kept. You may set this up with the following command::

    yum install perfSONAR-repo-staging

Once you are pointing at the staging repository you may follow the steps at :doc:`install_centos` to choose and configure your bundle.
    
.. note:: If you have auto-updates enabled, once you point your host at the staging repository, you will automatically get any new test packages that are added within 24 hours.

.. _install_rcs-upgrade-centos:

Testing Upgrades of an Existing Toolkit or CentOS Bundle Installation
=====================================================================

You can test upgrades of any existing CentOS-based perfSONAR installation by first pointing your existing CentOS installation at the perfSONAR staging yum repository and then running yum update::

        yum install perfSONAR-repo-staging
        yum update

.. note:: If you have auto-updates enabled, once you point your host at the staging repository, you will automatically get any new test packages that are added within 24 hours

.. _install_rcs-clean-debian:

Testing Debian Installation
============================

The beta packages for Debian can be found in the source list below:

* http://downloads.perfsonar.net/debian/perfsonar-minor-staging.list

You may install this source list as follows::
    
    cd /etc/apt/sources.list.d/
    wget http://downloads.perfsonar.net/debian/perfsonar-minor-staging.list
    wget -qO - http://downloads.perfsonar.net/debian/perfsonar-snapshot.gpg.key | apt-key add -

These Debian packages should work on Debian 9, Ubuntu 16 and Ubuntu 18.

On Ubuntu you need to make you have the **universe** repository enabled, this is done with the command ``add-apt-repository universe``

Once installed you may proceed to follow the steps in :doc:`install_debian` to complete the installation.

.. note:: If you have auto-updates enabled, once you point your host at this repository, you will automatically get any new test packages that are added within 24 hours


.. _install_rcs-upgrades-debian:

Testing Debian Upgrades
========================

You may test upgrades of perfSONAR Debian packages by following the steps to setup the Debian repository in the :ref:`previous section <install_rcs-clean-debian>`. Once completed run the following to upgrade::

    apt-get update
    apt-get dist-upgrade


Testing Docker Installation
============================

Docker images are provided for the latest staging and nightly builds. Installation works exactly as described in :doc:`install_docker`, except with adding ":staging" to the commands referencing perfsonar/testpoint. For example::

    docker pull perfsonar/testpoint:staging
    docker run --privileged -d -P --net=host perfsonar/testpoint:staging

Testing pSConfig Web Administrator Installation
================================================

The pSConfig Web Administrator is available via Docker. Since only the beta is available, see :doc:`pSConfig Web Administrator Installation <pwa_install>` for information on how to install the software.




