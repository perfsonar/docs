**********************
Installation on Debian
**********************

For perfSONAR 3.5.1 we provide part of the perfSONAR toolkit as Debian packages for four different architectures.  This should enable you to deploy a perfSONAR measurement point on one of the following distributions:

* Debian 7 Wheezy
* Debian 8 Jessie
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

* **Operating System:**  Any system running a Debian 7, Debian 8, Ubuntu 12 or Ubuntu 14 OS is supported.  Other Debian flavours derived from Debian 7 or 8 or Ubuntu 12 or 14 might work too but are not officially supported.

Installation Instructions
=========================

.. _install_debian_step1:

Step 1: Configure APT
---------------------

All you need to do is to configure the perfSONAR Debian repository source, along with our signing key, on your Debian/Ubuntu machine.  This can be done with the following commands for Debian 7, Ubuntu 12 or Ubuntu 14:
::

   cd /etc/apt/sources.list.d/
   wget http://downloads.perfsonar.net/debian/perfsonar-wheezy-3.5.list
   wget -qO - http://downloads.perfsonar.net/debian/perfsonar-debian-official.gpg.key | apt-key add -

And with the following commands for Debian 8:
::

   cd /etc/apt/sources.list.d/
   wget http://downloads.perfsonar.net/debian/perfsonar-jessie-3.5.list
   wget -qO - http://downloads.perfsonar.net/debian/perfsonar-debian-official.gpg.key | apt-key add -
   
Then refresh the packages list:
::

   apt-get update

.. _install_debian_step2:

Step 2: Install the packages
----------------------------

The two :doc:`bundles <install_options>` we currently provide for Debian contains the following packages:

* **perfsonar-tools** contains all the tools you need to make measurements from the CLI:

  * iperf and iperf3
  * owamp client and server
  * bwctl client and server
  * paris traceroute
  * ndt client

* **perfsonar-testpoint** contains the perfsonar-tools and the perfSONAR software you need to get your perfSONAR measurement point part of the global perfSONAR measurement infrastructure:

  * ls-registration daemon
  * regular-testing daemon
  * oppd
  * meshconfig-agent to participate in a test mesh, see :doc:`multi_mesh_agent_config` for more details

Choose the bundle you want to install and call ``apt-get install`` with it:
::

   apt-get install perfsonar-testpoint

*Optional Packages*

Additionally, you may also install the toolkit security, sysctl and ntp configuration packages manually:

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
  
  It is important to make sure that your host is properly tuned for maximum TCP performance on the WAN. You should verify that cubic, not reno, is the default TCP congestion control algorithm, and that the maximum TCP buffers are big enough for your paths of interest.  If you have installed the ``perfsonar-toolkit-sysctl`` package, all should be ready for you.

  Please refer to `linux host tuning <http://fasterdata.es.net/host-tuning/linux/>`_ for more information.


.. _install_debian_step4:

Step 4: Firewall and Security Considerations 
--------------------------------------------- 
If you have installed the `perfsonar-toolkit-security` package, then your iptables are already configured with our default rules.  The package also installs fail2ban.

If you would like to configure the rules manually, then please review the `document here <http://www.perfsonar.net/deploy/security-considerations/>`_ on the ports that need to be open.

Additionally, bwctl allows you to limit the parameters of tests such as duration and bandwidth based on the requesters IP address. It does this through a file called bwctl-server.limits. You may read the bwctl-server.limits man page or look at the example file provided under /etc/bwctl-server/bwctl-server.limits file. ESnet uses a bwctl-server.limits file that some sites may find useful. This file is based on the routing table and is updated regularly. It implements the following general policies:

* Allow unrestricted UDP tests from ESnet test system prefixes.
* Allow up to 200Mbps UDP tests from ESnet sites.
* Deny UDP tests from any other locations.
* Allow TCP tests from IPV4 and IPv6 addresses in the global Research and Education community routing table.
* Deny TCP tests from everywhere else.

To use the ESnet bwctl-server.limits file, get this file from ESnet as follows:
::

    cd /etc/bwctl-server
    mv bwctl-server.limits bwctl-server.limits.dist
    wget --no-check-certificate http://stats.es.net/sample_configs/bwctld.limits
    mv bwctld.limits bwctl-server.limits

ESnet provides a shell script that will download and install the latest bwctl-server.limits file. The bwctl-server.limits file is generated once per day between 20:00 and 21:00 Pacific Time. You can run the shell script from cron to keep your bwctl-server.limits file up to date (it is recommended that you do this outside the time window when the new file is being generated). To download the shell script from the ESnet server do the following:
::

    cd /etc/bwctl
    wget --no-check-certificate http://stats.es.net/sample_configs/update_limits.sh
    chmod +x update_limits.sh

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

In order to publish the existence of your measurement services there is a single file with some details about your host. You may edit this information by opening **/etc/perfsonar/lsregistrationdaemon.conf**. You will see numerous properties you may populate. They are commented out meaning you need to remove the ``#`` at the beginning of the line for them to take effect. However in most cases, the defaults of this file will be suitable and you should not need to make any changes. The auto-discovery directives indicate whether the system automatically determines the value of any property not manually set in this file. The properties you may additionaly set are administrative data like for example administrator's name, email, site_name, city, country, latitude, longitude, etc. None of them are required but it is highly recommended you set them since it will make finding your services easier for others. More information on the available fields can be found in :doc:`config_ls_registration`. 

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
    /etc/init.d/perfsonar-regulartesting start
    /etc/init.d/perfsonar-oppd-server start

Note that you may have to wait a few hours for NTP to synchronize your clock before starting bwctl-server and owamp-server.


Configuring Central Management
------------------------------

Refer to the documentation here: :doc:`/multi_overview`

Support
=======

Support for Debian installations is provided by the perfSONAR community through the usual communication channels.

Beta packages
=============

Additionaly to the above listed packages, we also provide beta level Debian/Ubuntu packages of the following perfSONAR components:

* **perfsonar-core** contains the perfsonar-testpoint and the measurement archive (esmond)
* **perfsonar-centralmanagement** contains the cental mesh config, MaDDash and the autoconfig tools.

At the moment, these packages have not undergone a thourough testing, reason why we release them as beta level packages.  Your feedback about their usability and report about any bug you find in them are welcome on the perfsonar-user mailing list.

