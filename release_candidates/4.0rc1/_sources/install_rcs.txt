**************************
Testing Release Candidates
**************************

.. warning:: Please note that none of the steps in this document should be performed on production hosts. These are solely intended for development or testing hosts and may result in your host running unstable software.  


The perfSONAR project traditionally does public release candidate testing prior to major new releases. These are announced on the mailing lists when available. Participating in release candidates is open to anyone and feedback generated from these tests helps the development team formulate the best possible final release. You can help with testing by going through one or more of the following test scenarios:

* A clean installation of our Toolkit ISOs
* A clean installation of one of our CentOS bundles
* An upgrade of either a toolkit or CentOS bundle
* A clean installation of our Debian packages and/or bundles
* An upgrade of an existing Debian installation

You may consult `the testing checklist <https://github.com/perfsonar/project/wiki/Toolkit-Testing-Checklist>`_ to help guide your testing. For full instructions on how to get release candidate packages and ISOs, see the sections below.

.. _install_rcs-clean-isos:

Testing a Clean Installation of the Toolkit ISOs
================================================
You may download the latest release candidate ISOs at the following URL :

    * http://downloads.perfsonar.net/toolkit/release_candidates/
    
Once downloaded you may follow the instructions at :doc:`install_centos_fullinstall` or :doc:`install_centos_netinstall` for step-by-step instructions on installing the software.

.. _install_rcs-clean-centos:

Testing CentOS Bundles Installation
====================================
You can test CentOS bundle installation by first pointing your existing CentOS installation at the perfSONAR staging yum repository. This is where test versions of the software are kept. You may set this up with the following command::

    yum install Internet2-repo-staging

Once you are pointing at the staging repository you may follow the steps at :doc:`install_centos` to choose and configure your bundle.
    
.. note:: If you have auto-updates enabled, once you point your host at the staging repository, you will automatically get any new test packages that are added within 24 hours

.. _install_rcs-upgrade-centos:

Testing Upgrades of an Existing Toolkit or CentOS Bundle Installation
=====================================================================
You can test upgrades of any existing CentOS-based perfSONAR installation by first pointing your existing CentOS installation at the perfSONAR staging yum repository and then running yum update::

        yum install Internet2-repo-staging
        yum update

.. note:: If you have auto-updates enabled, once you point your host at the staging repository, you will automatically get any new test packages that are added within 24 hours

.. _install_rcs-clean-debian:

Testing Debian Installation
============================
The release candidate packages for Debian can be found in the source lists below for their respective Debian versions:

* **Debian 7 (Wheezy):** http://downloads.perfsonar.net/debian/perfsonar-wheezy-staging.list
* **Debian 8 (Jessie):** http://downloads.perfsonar.net/debian/perfsonar-jessie-staging.list

You may install the appropriate source list as follows for **Debian 7 (Wheezy)**::
    
    cd /etc/apt/sources.list.d/
    wget http://downloads.perfsonar.net/debian/perfsonar-wheezy-staging.list
    wget -qO - http://downloads.perfsonar.net/debian/perfsonar-wheezy-snapshot.gpg.key | apt-key add -
    
Likewise for **Debian 8 (Jessie)**::

    cd /etc/apt/sources.list.d/
    wget http://downloads.perfsonar.net/debian/perfsonar-jessie-staging.list
    wget -qO - http://downloads.perfsonar.net/debian/perfsonar-jessie-snapshot.gpg.key | apt-key add -

Once installed you may proceed to follow the steps in :doc:`install_debian` to complete the installation.

.. note:: If you have auto-updates enabled, once you point your host at the staging repository, you will automatically get any new test packages that are added within 24 hours


.. _install_rcs-upgrades-debian:

Testing Debian Upgrades
========================

You may test upgrades of perfSONAR Debian packages by following the steps to setup the Debian repository in the :ref:`previous section <install_rcs-clean-debian>`. Once completed run the following to upgrade::

    apt-get update
    apt-get dist-upgrade





