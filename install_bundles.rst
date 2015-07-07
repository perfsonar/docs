***************************
Bundle Installations
***************************

perfSONAR combines a number of measurement tools and services. Depending on your needs, you may need only a subset of the software. We have defined the following types of Bundles.

#. **perfSONAR-TestPoint:** This is the most basic perfSONAR installation. It contains a bwctl and owamp server along with tools to publish the location of these services to the perfSONAR-PS Simple Lookup Service.  This type of installation also contains the bwctl, owamp and ndt command-line clients so that you may run one-time tests to other servers. This installation does not include tools on the target host to initiate tests that run on regular time intervals nor does it contain measurement archives that store result of tests.  The perfSONAR-TestPoint install includes everything you need to run one-time tests and for others to find/schedule tests to your site. Full install instructions are contained within the document.
#. **perfSONAR-Core:** The perfSONAR-Core install includes everything in the perfSONAR-TestPoint install plus clients to automatically run scheduled tests over specified time intervals. Full install instructions can be found within this document.
#. **perfSONAR-Complete:** This is considered the full perfSONAR-PS Toolkit rpms. It includes everything in perfSONAR-Core and also contains web interfaces and Toolkit configuration. It is useful if you already have a CentOS host and want to install only the rpms. Full install instructions is included in the document.
#. **perfSONAR-Toolkit ISO:** This installs CentOS and all the Toolkit rpms in perfSONAR-Complete. This is the usual perfSONAR-NetInstall. Full install instructions can be found at :doc:`install_centos_netinstall`.
#. **perfSONAR-CentralManagement:** The perfSONAR-CentralManagement Bundle installs the central mesh config, Maddash, centralized config service and the autoconfig. Full install instructions is included in the document.

System Requirements 
==================== 
* **Operating System:** Any system running either a 32-bit or 64-bit CentOS 6 operating system should be able to follow the process outlined in this document. Other RedHat-based operating systems may work, but are not officially supported at this time.
* **Hardware:** Most base-level systems should be adequate to run the measurement tools. You may want to explore a 10Gbps network interface card depending on the throughput testing you wish to perform. See the `fasterdata.es.net hardware page <http://fasterdata.es.net/performance-testing/perfsonar/ps-howto/hardware/>`_ for some suggested configurations.

Installation 
============

Step 1 is common for all the installs. It specifies how to configure the yum repository. Do this step and then proceed to the installation instructions for the bundle of your choice.

.. _install_step1:

Step 1: Configure Yum 
---------------------- 
The process configures yum to point at the necessary repositories to get packages needed for perfSONAR. You will need to follow the steps below:

1. Install the EPEL RPM:
::

    rpm -hUv https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm


2. Install the Internet2-repo RPM:
::

    rpm -hUv http://software.internet2.edu/rpms/el6/x86_64/main/RPMS/Internet2-repo-0.6-1.noarch.rpm


4. Refresh yum's cache so it detects the new RPMS
::

    yum clean all


.. _install_step2:

Step 2: Install RPM 
-------------------------------- 

* **perfSONAR-TestPoint**::

    yum install perfSONAR-Bundles-TestPoint  

  Additionally, you may also install the Toolkit service-watcher, ntp, security(firewall rules and sysctl packages

  *Optional Packages*

    To install additional packages, run::

    /opt/perfsonar_ps/toolkit/scripts/install-optional-packages.py

    Or, you can manually install them by running:  

     * ``yum install perfSONAR_PS-Toolkit-service-watcher``
     * ``yum install perfSONAR_PS-Toolkit-ntp``
     * ``yum install perfSONAR_PS-Toolkit-security``
     * ``yum install perfSONAR_PS-Toolkit-sysctl``


* **perfSONAR-Core**::

    yum install perfSONAR-Bundles-Core

  Just as in TestPoint Bundle, optional packages are available and can be installed via a script or manually.

  *Optional Packages*

    To install additional packages, run::

    /opt/perfsonar_ps/toolkit/scripts/install-optional-packages.py


    Or, you can manually install them by running:

       * ``yum install perfSONAR_PS-Toolkit-service-watcher``
       * ``yum install perfSONAR_PS-Toolkit-ntp``
       * ``yum install perfSONAR_PS-Toolkit-security``
       * ``yum install perfSONAR_PS-Toolkit-sysctl``



* **perfSONAR-CentralManagement**::

    yum install perfSONAR-Bundles-CentralManagement


* **perfSONAR-Complete**::

    yum install perfSONAR-Bundles-Complete


.. _level1_step3:

Step 3: Verify NTP and Tuning Parameters 
----------------------------------------- 
*Can be ignored for perfSONAR-Toolkit iso and perfSONAR-Complete*

* **NTP**

  - **Package Install**:
  
    If the optional package was installed, then run::
    
    /opt/perfsonar_ps/toolkit/scripts/system_environment/configure_ntpd
    /opt/perfsonar_ps/toolkit/scripts/system_environment/enable_ntpd

  - **Manual**: 
  
    The Network Time Protocol (NTP) is required by the tools in order to obtain accurate measurements. Some of the tools such as BWCTL will not even run unless NTP is configured. You can verify NTP is running with the following command::

    /usr/sbin/ntpq -p  



* **System Tuning**
  
  It is important to make sure that your host is properly tuned for maximum TCP performance on the WAN. You should verify that cubic, not reno, is the default TCP congestion control algorithm, and that the maximum TCP buffers are big enough for your paths of interest.  

  - **Package Install**
    
    Run::  

    /opt/perfsonar_ps/toolkit/scripts/system_environment/configure_sysctl

  - **Manual Tuning**
    
    Please refer to `http://fasterdata.es.net/host-tuning/linux/`  



.. _install_step4:

Step 4: Firewall and Security Considerations 
--------------------------------------------- 
**Package Install**
If you have installed the perfSONAR_PS-Toolkit-security package, then you can configure the IPTable entries by running::

    /opt/perfsonar_ps/toolkit/scripts/system_environment/configure_firewall

The package also installs fail2ban.


Or, if you would like to configure the rules manually, then please review `perfSONAR FAQ entry <http://www.perfsonar.net/about/faq/#Q6>`_ and/or the `document here <http://stats.es.net/ps-downloads/20130308-Firewall-PerfWG.pdf>`_ on the ports that need to be open.

Additionally, bwctl allows you to limit the parameters of tests such as duration and bandwidth based on the requesters IP address. It does this through a file called bwctld.limits. You may read the bwctld.limits man page or look at the example file provided under /etc/bwctld/bwctld.limits file. ESnet uses a bwctld.limits file that some sites may find useful. This file is based on the routing table and is updated regularly. It implements the following general policies:

* Allow unrestricted UDP tests from ESnet test system prefixes.
* Allow up to 200Mbps UDP tests from ESnet sites.
* Deny UDP tests from any other locations.
* Allow TCP tests from IPV4 and IPv6 addresses in the global Research and Education community routing table.
* Deny TCP tests from everywhere else.

To use the ESnet bwctld.limits file, get this file from ESnet as follows:
::

    cd /etc/bwctld
    mv bwctld.limits bwctld.limits.dist
    wget --no-check-certificate http://stats.es.net/sample_configs/bwctld.limits

ESnet provides a shell script that will download and install the latest bwctld.limits file. The bwctld.limits file is generated once per day between 20:00 and 21:00 Pacific Time. You can run the shell script from cron to keep your bwctld.limits file up to date (it is recommended that you do this outside the time window when the new file is being generated). To download the shell script from the ESnet server do the following:
::

    cd /etc/bwctld
    wget --no-check-certificate http://stats.es.net/sample_configs/update_limits.sh
    chmod +x update_limits.sh

.. _install_step5:

Step 5: Service Watcher
------------------------
The perl-perfSONAR_PS-Toolkit-service-watcher installs scripts that check if bwctl, owamp and other processes are running and restarts if they have stopped unexpectedly. 

The install automatically, configures cron to run the service_watcher regularly.

To run the script manually, run::

  /opt/perfsonar_ps/toolkit/scripts/service_watcher

.. _install_step6:

Step 6: Register your services 
------------------------------- 

In order to publish the existence of your measurement services there is a single file you need to edit with some details about your host. You may populate this information by opening **/opt/perfsonar_ps/ls_registration_daemon/etc/ls_registration_daemon.conf**. You will see numerous properties you may populate. They are commented out meaning you need to remove the ``#`` at the beginning of the line for them to take effect. The properties you are **required** to set are as follows:

::

    ##Hostname or IP address others can use to access your service
    #external_address   myhost.mydomain.example
    
    ##Primary interface on host
    #external_address_if_name eth0

and the other entries (administrator_email, site_name, city, country, latitude, longitude, etc.) are **highly recommended**.

In the example above remove the leading ``#`` before external_address and external_address_if_name respectively. Also replace *myhost.mydomain.example* and *eth0* with the values relevant to your host. There are additional fields available for you to set. None of them are required but it is highly recommended you set as many as possible since it will make finding your services easier for others. More information on the available fields can be found in the configuration file provided by the RPM install. 

.. _install_step7:

Step 7: Starting your services 
------------------------------- 
You can start all the services by rebooting the host since all are configured to run by default. Otherwise you may start them with the following commands as a root user:
::

    /etc/init.d/bwctld start
    /etc/init.d/owampd start
    /etc/init.d/ls_registration_daemon start

Note that you may have to wait a few hours for NTP to synchronize your clock before starting bwctld and owampd.


Configuring Central Management
------------------------------

Refer to the documentation here: :doc:`/multi_overview`
