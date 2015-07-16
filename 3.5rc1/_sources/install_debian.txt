**********************
Installation on Debian
**********************

For perfSONAR 3.5 we provide part of the perfSONAR toolkit as Debian packages for four different architectures.  This should enable you to deploy a perfSONAR measurement point on one of the following distributions:

* Debian 7 Wheezy
* Ubuntu 12 Precise
* Ubuntu 14 Trusty

Here are some instructions to get you started with the perfSONAR toolkit on Debian hosts.

System Requirements
===================

* **Hardware:** We provide Debian packages for 4 different architectures:

  * 32-bit (i386)
  * 64-bit (amd64)
  * ARMv4t and up (armel)
  * ARMv7 and up (armhf)

* **Operating System:**  Any system running a Debian 7, Ubuntu 12 or Ubuntu 14 OS is supported.  Other Debian flavours derived from Debian 7 or Ubuntu 12 or 14 might work too but are not officially supported.

Installation Instructions
=========================

All you need to do is to configure the perfSONAR Debian repository source, along with our signing key, on your Debian/Ubuntu machine.  This can be done with the following commands:
::

   cd /etc/apt/sources.list.d/
   wget http://downloads.perfsonar.net/debian/perfsonar-wheezy-3.5.list
   wget -qO - http://downloads.perfsonar.net/debian/perfsonar-wheezy-3.5.gpg.key | apt-key add -

Then, after refreshing the apt packages list, you'll be able to install one of the perfSONAR bundles:
::

   apt-get update
   apt-get install perfsonar-testpoint

Bundles Description
===================

The two :doc:`bundles <install_bundles>` we currently provide for Debian contains the following packages:

* **perfsonar-tools** contains all the tools you need to make measurements from the CLI:

  * iperf and iperf3
  * owamp client and server
  * bwctl client and server
  * ndt client

* **perfsonar-testpoint** contains the perfsonar-tools and the perfSONAR software you need to get your perfSONAR measurement point part of the global perfSONAR measurement infrastructure:

  * ls-registration daemon
  * regular-testing daemon
  * oppd
  * toolkit-security containing iptables rules to protect your node
  * toolkit-sysctl fine tuning your host for better performance measurements

Configuration
=============

If you're used to the perfSONAR toolkit deployed on a CentOS/RHEL host, the configuration files for the different perfSONAR tools are the same as for the regular toolkit, but they are located in a different location.  You'll have to look for configuration files directly in ``/etc/``:

  * ``/etc/bwctl/`` for the bwctl server
  * ``/etc/owampd/`` for the owamp server
  * ``/etc/perfsonar/`` for the oppd, the ls-registration daemon and the regular-testing daemon

Also, the name of the services are a bit different from the CentOS/RHEL ones, Debian services names are:

  * ``bwctl-server``
  * ``owampd``
  * ``perfsonar-lsregistrationdaemon``
  * ``perfsonar-oppd-server``
  * ``perfsonar-regulartesting``

Support
=======

Support for Debian installations is provided by the perfSONAR community through the usual communication channels.
