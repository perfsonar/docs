***********************************
Bundle Installation on Debian
***********************************

perfSONAR combines various sets of measurement tools and services. For perfSONAR 4.0 we provide the whole perfSONAR toolkit as Debian packages for five different architectures.  This should enable you to deploy a full perfSONAR node on one of the following distributions:

* Debian 8 Jessie
* Debian 9 Stretch
* Ubuntu 14 Trusty Tahr
* Ubuntu 16 Xenial Xerus

Debian meta packages are available to install the bundles described in :doc:`install_options`. The steps in the remaining sections of this document detail the steps required for installing these bundles.


System Requirements
===================

* **Architecture:** We provide Debian packages for 5 different architectures:

  * 32-bit (i386)
  * 64-bit (amd64)
  * ARMv4t and up (armel)
  * ARMv7 and up (armhf)
  * ARM64 (arm64) (only for Debian 8/9)

* **Operating System:**  Any system running a Debian 8, Debian 9, Ubuntu 14 or Ubuntu 16 server OS is supported.  Other Debian flavours derived from Debian 8/9 or Ubuntu 14/16 might work too but are not officially supported.

* See :doc:`install_hardware` for hardware requirements and more.

.. note:: Installing a graphical/desktop environment with perfSONAR is not supported.  These environments generally come with a Network Manager that conflicts with the way that perfSONAR is tuning the network interface parameters.  We recommend doing only server grade OS installs.

.. _install_debian_installation:

Installation 
============

.. _install_debian_step1:

Step 1: Configure APT
---------------------
All you need to do is to configure the perfSONAR Debian repository source, along with our signing key, on your Debian/Ubuntu machine. **You will need to follow the steps below as privileged user**:

       cd /etc/apt/sources.list.d/
       wget http://downloads.perfsonar.net/debian/perfsonar-jessie-release.list
       wget -qO - http://downloads.perfsonar.net/debian/perfsonar-debian-official.gpg.key | apt-key add -
   
Then refresh the packages list so APT knows about the perfSONAR packages::

   apt-get update


.. _install_debian_step2:

Step 2: Install a Bundle 
------------------------ 
**Choose one** of the following bundles and see :doc:`install_options` page for more information about what these bundles are.

* **perfSONAR Tools**::

    apt-get install perfsonar-tools

* **perfSONAR Test Point**::

    apt-get install perfsonar-testpoint  

  During the installation process, you'll be asked to choose a password for the pscheduler database.

* **perfSONAR Core**::

    apt-get install perfsonar-core

  During the installation process, you'll be asked to choose a password for the pscheduler and the esmond databases.

* **perfSONAR Central Management**::

    apt-get install perfsonar-centralmanagement

  During the installation process, you'll be asked to choose a password for the esmond database.

* **perfSONAR Toolkit**::

    apt-get install perfsonar-toolkit

  During the installation process, you'll be asked to choose a password for the pscheduler and the esmond databases.

Optional Packages
++++++++++++++++++
In addition to any of the bundles above you may also **optionnally** choose to install one or more of our add-on packages (these are automatically added on the perfsonar-toolkit bundle):

     * ``apt-get install perfsonar-toolkit-ntp`` - Automatically detects closest NTP servers and sets them in ntp.conf
     * ``apt-get install perfsonar-toolkit-security`` - Adds default firewall rules and installs fail2ban
     * ``apt-get install perfsonar-toolkit-servicewatcher`` - Adds a cron job that checks if services are still running
     * ``apt-get install perfsonar-toolkit-sysctl`` - Adds default sysctl tuning settings
     * ``apt-get install perfsonar-toolkit-systemenv-testpoint`` - Configures auto-update and set some default logging locations

You may also run the command below to get everything listed above on **perfsonar-testpoint** and **perfsonar-core** bundles::

    /usr/lib/perfsonar/scripts/install-optional-packages.py

Reducing installation size
++++++++++++++++++++++++++
If you want to reduce the perfSONAR installation size as much as possible, you can call ``apt-get`` with the ``--no-install-recommends`` option.  This will prevent Debian recommended packages to be automatically installed (you can also configure this globaly in the APT configuration files with the statement ``APT::Install-Recommends "0";``).  This can become useful when you want to install the perfsonar-testpoint bundle with the less overhead possible.


.. _install_debian_step3:

Step 3: Verify NTP and Tuning Parameters 
----------------------------------------- 
*Step 3 can be ignored for perfsonar-toolkit package installation as its instructions are included and run automatically*

* **NTP Tuning**

  - **Auto-select NTP servers based on proximity**
    
    The Network Time Protocol (NTP) is required by the tools in order to obtain accurate measurements. Some of the tools such as OWAMP will give correct results unless NTP is running. If the optional package `perfsonar-toolkit-ntp` was installed this has already been done for you, but if you want to re-run manually::

        /usr/lib/perfsonar/scripts/configure_ntpd new
        service ntp restart

  You can also configure your own set of NTP servers if you want.

  You can verify if NTP is running with the following command::

        /usr/sbin/ntpq -p  

* **System Tuning**
  
  It is important to make sure that your host is properly tuned for maximum TCP performance on the WAN. You should verify that htcp, not reno, is the default TCP congestion control algorithm, and that the maximum TCP buffers are big enough for your paths of interest.  

  If you have installed the `perfsonar-toolkit-sysctl` package, all should be ready for you, but if you want to rerun manually::

    /usr/lib/perfsonar/scripts/configure_sysctl

  Please refer to `linux host tuning <http://fasterdata.es.net/host-tuning/linux/>`_ for more information.


.. _install_debian_step4:

Step 4: Firewall and Security Considerations 
--------------------------------------------- 
If you have installed the `perfsonar-toolkit-security` package, then your iptables are already configured with our default rules.  The package also installs fail2ban.

If you would like to configure the rules manually, then please review the `document here <http://www.perfsonar.net/deploy/security-considerations/>`_ on the ports that need to be open.

    The `perfsonar-toolkit-security` package uses `firewalld` to manage the firewall rules.

Additionally, pscheduler allows you to limit the parameters of tests such as duration and bandwidth based on the requesters IP address. It does this through the file ``pscheduler/limits.conf``. 
ESnet provides a file containing all R&E subnets, which is updated nightly. Instructions on how to download this file and configure pScheduler to use it are described on the page :doc:`manage_limits`.

Note that the `perfsonar-toolkit-security` package is automatically included in the `perfsonar-toolkit` bundle.

.. _install_debian_step5:

Step 5: Auto updates
--------------------
If you have installed the `perfsonar-toolkit-systemenv-testpoint` package, then you're all set for the auto-updates of perfSONAR packages and security fix for your OS.

To ensure you always have the most current and hopefully most secure packages you can install ``unattended-upgrades``. You’ll need to configure it to actually install the available updates with the following commands:
::

    apt-get install unattended-upgrades
    echo 'APT::Periodic::Update-Package-Lists "1";' > /etc/apt/apt.conf.d/60unattended-upgrades-perfsonar
    echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/60unattended-upgrades-perfsonar
    echo 'APT::Periodic::AutocleanInterval "31";' >> /etc/apt/apt.conf.d/60unattended-upgrades-perfsonar
    echo 'Unattended-Upgrade::Origins-Pattern:: "origin=perfSONAR";' >> /etc/apt/apt.conf.d/60unattended-upgrades-perfsonar

A cronjob will automatically install security updates from Debian/Ubuntu and new packages present in the perfsonar release repository every night. A trace of all updates applied will be stored in ``/var/log/unattended-upgrades/unattended-upgrades.log``.

Full perfSONAR toolkit upgrades (i.e. upgrade to new major versions) might still need a manual intervention to properly conclude, but we will then announce that through our usual communication channels.

.. note:: Automatic updates are enabled by default in the perfSONAR Toolkit.

.. _install_debian_step6:

Step 6: Service Watcher
------------------------
The `perfsonar-toolkit-servicewatcher` installs scripts that check if pscheduler, owamp, databases and other processes are running and restarts if they have stopped unexpectedly. 

The install automatically configures cron to run the service_watcher regularly.

To run the script manually, run::

  /usr/lib/perfsonar/scripts/service_watcher

.. _install_debian_step7:

Step 7: Register your services 
------------------------------- 
Note: this step can be done through the web interface if the perfsonar-toolkit bundle was installed. See :doc:`manage_admin_info`.

No actual configuration is required but filling fields such as administrator_email, site_name, city, country, latitude, longitude, etc. are **highly recommended**. You can add these by removing the leading `#` of any property and filling it out with a proper value for your host. Changes will be picked-up automatically without need for any restarts.

.. _install_debian_step8:

Step 8: Starting your services 
------------------------------- 
You can start all the services by rebooting the host since all are configured to run by default. In order to check services status issue the following commands::
    
    service pscheduler-scheduler status
    service pscheduler-runner status
    service pscheduler-archiver status
    service pscheduler-ticker status
    service owamp-server status
    service perfsonar-lsregistrationdaemon status

If they are not running you may start them with appropriate service commands as a root user. For example::

    service pscheduler-scheduler start
    service pscheduler-runner start
    service pscheduler-archiver start
    service pscheduler-ticker start
    service owamp-server start
    service perfsonar-lsregistrationdaemon start

Note that you may have to wait a few hours for NTP to synchronize your clock before (re)starting owamp-server.

Configuration
=============

Configuring Central Management
-------------------------------
If you installed the perfsonar-centralmanagement bundle see the following documents:

* :doc:`multi_ma_install`
* :doc:`psconfig_publish`
* :doc:`psconfig_maddash_agent`
* `Using MaDDash to build dashboards <http://software.es.net/maddash/>`_


Configuring perfSONAR through the web interface
------------------------------------------------
After installing the perfsonar-toolkit bundle, you can refer to the general perfSONAR configuration from :doc:`install_config_first_time`.

Upgrading from 4.0.2
====================
If you had installed a perfSONAR 4.0.2 bundle and you now want to upgrade to perfSONAR 4.1, you'll have to follow the instructions here below.

Add the 4.1 APT sources
-----------------------

Even though the sources.list file is named after the Debian 8 (Jessie) release, it is meant to work on Debian 8 and 9 and Ubuntu 14 and 16.  You can add it to your system with the following commands::

   cd /etc/apt/sources.list.d/
   wget http://downloads.perfsonar.net/debian/perfsonar-jessie-release.list
   
Then refresh the packages list so APT knows about the perfSONAR packages::

   apt-get update

Upgrade the perfSONAR installation
----------------------------------
To upgrade your perfsonar installation, you just need to run::

    apt-get dist-upgrade

During the installation process, you'll be asked to choose a password for the pscheduler database.  After the upgrade, the perfsonar-regulartesting daemon and the OPPD will be stoped as they are no longer required.

The measurements and the measurement archives that you already have defined in your 4.0.2 installation will be migrated to the 4.1 tools automatically.

Upgrade to another bundle
-------------------------
If you want to move from the `perfsonar-testpoint` bundle to another bundle that we provide for Debian, you can do so by following the instructions above from :ref:`install_debian_step2`.

Upgrade from Debian 7 to Debian 8 or 9
--------------------------------------
If you have a perfSONAR host running Debian 7 and you want to upgrade it to Debian 8 (Jessie) or 9 (Stretch), we recommend you to follow the following steps:

#. Upgrade Debian 7 to Debian 8 (following Debian instructions, here are `Jessie upgrade notes for i386 architecture <https://www.debian.org/releases/jessie/i386/release-notes/ch-upgrading.en.html>`_)
#. Reboot (to get systemd running)
#. Change perfSONAR repository from ``perfsonar-wheezy-release`` to ``perfsonar-jessie-release``
#. Upgrade Debian 8 to Debian 9 (following Debian instructions, here are `Stretch upgrade notes for i386 architecture <https://www.debian.org/releases/stretch/i386/release-notes/ch-upgrading.en.html>`_)

  * Alternatively, you can just run ``apt-get udpate; apt-get dist-upgrade`` if you prefer to stay with Debian 8.

