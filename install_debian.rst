**********************
Installation on Debian
**********************

perfSONAR combines various sets of measurement tools and services. For perfSONAR 4.0 we provide the whole perfSONAR toolkit as Debian packages for four different architectures.  This should enable you to deploy a full perfSONAR node on one of the following distributions:

* Debian 7 Wheezy
* Debian 8 Jessie
* Ubuntu 14 Trusty

Debian meta packages are available to install the bundles described in :doc:`install_options`. Here are some instructions to get you started with the perfSONAR toolkit on Debian hosts.

System Requirements
===================

* **Hardware:** We provide Debian packages for 5 different architectures:

  * 32-bit (i386)
  * 64-bit (amd64)
  * ARMv4t and up (armel)
  * ARMv7 and up (armhf)
  * ARM64 (arm64) (only for Debian 8)

* **Operating System:**  Any system running a Debian 7, Debian 8, or Ubuntu 14 OS is supported.  Other Debian flavours derived from Debian 7 or 8 or Ubuntu 14 might work too but are not officially supported.

Installation Instructions
=========================

.. _install_debian_step1:

Step 1: Configure APT
---------------------

All you need to do is to configure the perfSONAR Debian repository source, along with our signing key, on your Debian/Ubuntu machine.  This can be done with the following commands for Debian 7 or Ubuntu 14:
::

   cd /etc/apt/sources.list.d/
   wget http://downloads.perfsonar.net/debian/perfsonar-wheezy-release.list
   wget -qO - http://downloads.perfsonar.net/debian/perfsonar-debian-official.gpg.key | apt-key add -

Or with the following commands for Debian 8:
::

   cd /etc/apt/sources.list.d/
   wget http://downloads.perfsonar.net/debian/perfsonar-jessie-release.list
   wget -qO - http://downloads.perfsonar.net/debian/perfsonar-debian-official.gpg.key | apt-key add -
   
Then refresh the packages list:
::

   apt-get update

.. _install_debian_step2:

Step 2: Install the packages
----------------------------

You're now ready to choose which bundle, as describe in :doc:`install_options`, you want to install on your Debian/Ubuntu host:

* **perfsonar-toolkit** (the full perfSONAR toolkit, containing perfsonar-core)
* **perfsonar-core** (which contains perfsonar-testpoint)
* **perfsonar-tools** (contains all the tools you need to make measurements from the CLI)
* **perfsonar-testpoint** (which contains perfsonar-tools and the meshconfig-agent to participate in a test mesh, see :doc:`multi_mesh_agent_config` for more details)
* **perfsonar-centralmanagement** (to host a central MA and a dashboard)

Choose the bundle you want to install and call ``apt-get install`` with it:
::

   apt-get install perfsonar-testpoint

*Optional Packages*

Additionally, if not installing the perfsonar-toolkit bundle, you may also install the toolkit security, sysctl and ntp configuration packages manually:

  * **perfsonar-toolkit-security** containing iptables rules and fail2ban to protect your node, see :doc:`manage_security` for more details.
  * **perfsonar-toolkit-sysctl** fine tuning your host for better performance measurements, see :doc:`manage_tuning` for more details.
  * **perfsonar-toolkit-ntp** provides you with a list of known NTP servers and a script to choose the closest ones.

The installation of these packages can be done with each of the commands:
::

   apt-get install perfsonar-toolkit-security
   apt-get install perfsonar-toolkit-sysctl
   apt-get install perfsonar-toolkit-ntp

During the installation of the ``perfsonar-toolkit-security`` package you'll be asked if you want to keep your current set of iptables rules, both for IPV4 and for IPv6. This is part of the usual installation process of the ``iptables-persistent`` package that we use to setup the firewall protecting your perfSONAR node.  Whatever you answer to the question, your current rules will be saved as part of the ``perfsonar-toolkit-security`` package installation.

.. _install_debian_step3:

Step 3: Verify NTP and Tuning Parameters 
----------------------------------------- 

* **NTP**

  After installing the ``perfsonar-toolkit-ntp`` package, you can run the following script to have perfSONAR choose the closest NTP servers for you: ::

    /usr/lib/perfsonar/scripts/configure_ntpd new
    service ntp restart

  You can also configure your own set of NTP servers manually.

  The Network Time Protocol (NTP) is required by the tools in order to obtain accurate measurements. Some of the tools such as BWCTL will not even run unless NTP is configured. You can verify NTP is running with the following command::

    ntpq -p

* **System Tuning**
  
  It is important to make sure that your host is properly tuned for maximum TCP performance on the WAN. You should verify that htcp or cubic, not reno, is the default TCP congestion control algorithm, and that the maximum TCP buffers are big enough for your paths of interest.  If you have installed the ``perfsonar-toolkit-sysctl`` package, all should be ready for you.

  Please refer to `linux host tuning <http://fasterdata.es.net/host-tuning/linux/>`_ for more information.


.. _install_debian_step4:

Step 4: Firewall and Security Considerations 
--------------------------------------------- 
If you have installed the `perfsonar-toolkit-security` package, then your iptables are already configured with our default rules.  The package also installs fail2ban.

If you would like to configure the rules manually, then please review the `document here <http://www.perfsonar.net/deploy/security-considerations/>`_ on the ports that need to be open.

Additionally, bwctl allows you to limit the parameters of tests such as duration and bandwidth based on the requesters IP address. It does this through a file called bwctl-server.limits. 
ESnet provides a file containing all R&E subnets, which is updated nightly. Instructions on how to download this file and cofigure pScheduler and
bwctl to use it are described on the page :doc:`manage_limits`.

.. _install_debian_step5:

Step 5: Auto updates
--------------------
To ensure you always have the most current and hopefully most secure packages you can install and configure ``cron-apt`` to be run every night.  You’ll need to configure it to actually install the available updates and not just download the newly available packages (which is the default configuration).  This can be done with the following commands:
::

    apt-get install cron-apt
    echo 'upgrade -y -o APT::Get::Show-Upgraded=true -o Dir::Etc::SourceList=/etc/apt/sources.list.d/perfsonar-wheezy-release.list -o Dir::Etc::SourceParts="/dev/null"' >> /etc/cron-apt/action.d/5-install

A cronjob will automatically install new packages present in the perfsonar-wheezy-release repository every night (check ``/etc/cron.d/cron-apt``). You may want to do the same with the security updates provided by Debian/Ubuntu.

A trace of all updates applied will be stored in ``/var/log/cron-apt/log``

Full perfSONAR toolkit upgrades might still need a manual intervention to properly conclude, but we will then announce that through our usual communication channels.

.. _install_debian_step6:

Step 6: Register your services 
------------------------------- 

In order to publish the existence of your measurement services there is a single file with some details about your host. You may edit this information by opening **/etc/perfsonar/lsregistrationdaemon.conf**. You will see numerous properties you may populate. They are commented out meaning you need to remove the ``#`` at the beginning of the line for them to take effect. However in most cases, the defaults of this file will be suitable and you should not need to make any changes. The auto-discovery directives indicate whether the system automatically determines the value of any property not manually set in this file. The properties you may additionally set are administrative data like for example administrator's name, email, site_name, city, country, latitude, longitude, etc. None of them are required but it is highly recommended you set them since it will make finding your services easier for others. More information on the available fields can be found in :doc:`config_ls_registration`. 

After configuring the registration daemon you need to start it using the following command:
::

	/etc/init.d/perfsonar-registrationdaemon start

.. _install_debian_step7:

Step 7: Starting your services 
------------------------------- 
You can start all the services by rebooting the host since all are configured to run by default. Otherwise you may start them with the following commands as a root user:
::

    /etc/init.d/bwctl-server start
    /etc/init.d/owamp-server start
    /etc/init.d/perfsonar-lsregistrationdaemon start

Note that you may have to wait a few hours for NTP to synchronize your clock before starting bwctl-server and owamp-server.

Configuration
=============

Configuring Central Management
------------------------------

Refer to the documentation here: :doc:`/multi_overview`

Configuring through the web interface
--------------------------------------
After installing the perfsonar-toolkit bundle, you can refer to the general perfSONAR configuration from :doc:`install_config_first_time`.

Support
=======

Support for Debian installations is provided by the perfSONAR community through the usual communication channels.

