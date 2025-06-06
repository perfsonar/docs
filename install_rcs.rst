****************************************
Testing Beta Versions of perfSONAR
****************************************

.. warning:: Please note that none of the steps in this document should be performed on production hosts. These are solely intended for development or testing hosts and may result in your host running unstable software.  


The perfSONAR project traditionally does public betas testing prior to major new releases. These are announced on the mailing lists when available. Participating in betas is open to anyone and feedback generated from these tests helps the development team formulate the best possible final release. You can help with testing by going through one or more of the following test scenarios:

* A clean installation of one of our EL or Debian bundles
* An upgrade of an existing EL or Debian installation

.. _install_rcs-automatic:

Testing Bundle Installation (Automated Script)
================================================
The easiest way to test a beta is by using an automated script that detects the operating system, sets-up necessary repos and installs the selected bundles. The key is to give it the parameter `--repo staging` to get the beta release. The following commands will install various bundles.

* **perfSONAR Tools**::

    curl -s https://downloads.perfsonar.net/install | sh -s - --repo staging tools

* **perfSONAR Test Point**::

    curl -s https://downloads.perfsonar.net/install | sh -s - --repo staging testpoint

* **perfSONAR Toolkit**::

    curl -s https://downloads.perfsonar.net/install | sh -s - --repo staging toolkit

* **perfSONAR Archive**::

    curl -s https://downloads.perfsonar.net/install | sh -s - --repo staging archive


.. _install_rcs-clean-el:

Testing EL Bundles Installation (Manual)
=========================================

If you would prefer to manually setup the repos on EL then install the staging yum repository where test versions of the software are kept. You may set this up with the following commands below.

**EL9**::

    dnf install http://software.internet2.edu/rpms/el9/x86_64/latest/packages/perfsonar-repo-staging-0.11-1.noarch.rpm

Once you are pointing at the staging repository you may follow the steps at :doc:`install_el` to choose and configure your bundle.
    
.. note:: If you have auto-updates enabled, once you point your host at the staging repository, you will automatically get any new test packages that are added within 24 hours.

.. _install_rcs-upgrade-el:

Testing Upgrades of an Existing Toolkit or EL Bundle Installation (Manual)
===========================================================================

You can test upgrades of any existing EL-based perfSONAR installation by first pointing your existing EL installation at the perfSONAR staging yum repository and then running yum update::

        dnf install perfsonar-repo-staging
        dnf update

.. note:: If you have auto-updates enabled, once you point your host at the staging repository, you will automatically get any new test packages that are added within 24 hours

.. _install_rcs-clean-debian:

Testing Debian Installation (Manual)
=====================================

The beta packages for Debian can be found in the source list below:

* https://downloads.perfsonar.net/debian/perfsonar-minor-staging.list

You may install this source list as follows::
    
    curl -o /etc/apt/sources.list.d/perfsonar-minor-staging.list https://downloads.perfsonar.net/debian/perfsonar-minor-staging.list
    curl -s -o /etc/apt/trusted.gpg.d/perfsonar-staging.gpg.asc https://downloads.perfsonar.net/debian/perfsonar-staging.gpg.key

These Debian packages should work on Debian 11 and 12, Ubuntu 20, 22 and 24.

On Ubuntu you need to make you have the **universe** repository enabled, this is done with the command ``add-apt-repository universe``

Once installed you may proceed to follow the steps in :doc:`install_debian` to complete the installation.

.. note:: If you have auto-updates enabled, once you point your host at this repository, you will automatically get any new test packages that are added within 24 hours


.. _install_rcs-upgrades-debian:

Testing Debian Upgrades (Manual)
================================

You may test upgrades of perfSONAR Debian packages by following the steps to setup the Debian repository in the :ref:`previous section <install_rcs-clean-debian>`. Once completed run the following to upgrade::

    apt update
    apt upgrade


Testing Docker Installation
============================

Docker images are provided for the latest staging and nightly builds. Installation works exactly as described in :doc:`install_docker`, except with adding ":staging" to the commands referencing perfsonar/testpoint. For example::

    docker pull perfsonar/testpoint:staging
    docker run --privileged -d -P --net=host perfsonar/testpoint:staging

Testing pSConfig Web Administrator Installation
================================================

The pSConfig Web Administrator is available via Docker. Since only the beta is available, see :doc:`pSConfig Web Administrator Installation <pwa_install>` for information on how to install the software.




