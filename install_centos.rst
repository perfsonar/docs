******************************
Installation of CentOS Bundles
******************************

perfSONAR combines various sets of measurement tools and services. Commonly people install the entire set of tools using the Toolkit distribution (as detailed at :doc:`install_getting`) but this may not be optimal for every situation. For example if you only need a subset of the tools, you have an existing CentOS system on which you'd like to install the software and/or you are doing a large deployment of perfSONAR nodes. With this in mind RPMs are available that install the bundles described in :doc:`install_options`. The steps in the remaining sections of this document detail the steps required for installing these bundles.

.. _install_centos_sysreq:

System Requirements 
==================== 
* **Operating System:**

  * Any system running either a 32-bit or 64-bit **CentOS 6** operating system should be able to follow the process outlined in this document. Other RedHat-based operating systems may work, but are not officially supported at this time.

* See the general :ref:`install_options_sysreq` for hardware requirements and more

.. _install_centos_installation:

Installation 
============

.. _install_centos_step1:

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


.. _install_centos_step2:

Step 2: Install RPM 
-------------------------------- 

* **perfSONAR Test Point**::

    yum install perfsonar-testpoint  

  Additionally, you may also install the Toolkit service-watcher, ntp, security(firewall rules and sysctl packages

  *Optional Packages*

    To install additional packages, run::

    /usr/lib/perfsonar/scripts/install-optional-packages.py

    Or, you can manually install them by running:  

     * ``yum install perfsonar-toolkit-servicewatcher``
     * ``yum install perfsonar-toolkit-ntp``
     * ``yum install perfsonar-toolkit-security``
     * ``yum install perfsonar-toolkit-sysctl``

In particular, you should install perfsonar-toolkit-ntp if you are not managing your ntp.conf file in some other manner.

* **perfSONAR Core**::

    yum install perfsonar-core

  Just as in TestPoint Bundle, optional packages are available and can be installed via a script or manually.

  *Optional Packages*

    To install additional packages, run::

    /usr/lib/perfsonar/scripts/install-optional-packages.py


    Or, you can manually install them by running:

       * ``yum install perfsonar-toolkit-service-watcher``
       * ``yum install perfsonar-toolkit-ntp``
       * ``yum install perfsonar-toolkit-security``
       * ``yum install perfsonar-toolkit-sysctl``



* **perfSONAR Central Management**::

    yum install perfsonar-centralmanagement


* **perfSONAR Toolkit**::

    yum install perfsonar-toolkit


.. _install_centos_step3:

Step 3: Verify NTP and Tuning Parameters 
----------------------------------------- 
*Can be ignored for perfsonar-toolkit package*

* **NTP**

  - **Package Install**:
  
    If the optional package was installed, then run::
    
    /usr/lib/perfsonar/scripts/configure_ntpd new
    service ntpd restart

  - **Manual**: 
  
    The Network Time Protocol (NTP) is required by the tools in order to obtain accurate measurements. Some of the tools such as BWCTL will not even run unless NTP is configured. You can verify NTP is running with the following command::

    /usr/sbin/ntpq -p  



* **System Tuning**
  
  It is important to make sure that your host is properly tuned for maximum TCP performance on the WAN. You should verify that htcp, not reno, is the default TCP congestion control algorithm, and that the maximum TCP buffers are big enough for your paths of interest.  

  - **Package Install**
    
    Run::  

    /usr/lib/perfsonar/scripts/configure_sysctl

  - **Manual Tuning**
    
    Please refer to `http://fasterdata.es.net/host-tuning/linux/`  



.. _install_centos_step4:

Step 4: Firewall and Security Considerations 
--------------------------------------------- 
**Package Install**
If you have installed the perfsonar-toolkit-security package, then you can configure the IPTable entries by running::

    /usr/lib/perfsonar/scripts/configure_firewall

The package also installs fail2ban.


Or, if you would like to configure the rules manually, then please review the `document here <http://www.perfsonar.net/deploy/security-considerations/>`_ on the ports that need to be open.

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

    cd /etc/bwctl-server
    wget --no-check-certificate http://stats.es.net/sample_configs/update_limits.sh
    chmod +x update_limits.sh

You can also enable yum ‘auto updates’ to ensure you always have the most current and hopefully most secure packages. To do this, do the following:
::

    /sbin/chkconfig --add yum-cron
    /sbin/chkconfig yum-cron on
    /sbin/service yum-cron start

.. _install_centos_step5:

Step 5: Service Watcher
------------------------
The perfsonar-toolkit-servicewatcher installs scripts that check if bwctl, owamp and other processes are running and restarts if they have stopped unexpectedly. 

The install automatically, configures cron to run the service_watcher regularly.

To run the script manually, run::

  /usr/lib/perfsonar/scripts/service_watcher

.. _install_centos_step6:

Step 6: Register your services 
------------------------------- 
*Can be ignored and done through the web interface for he perfsonar-toolkit package*

In order to publish the existence of your measurement services there is a single file you need to edit with some details about your host. You may populate this information by opening **/etc/perfsonar/lsregistrationdaemon.conf**. You will see numerous properties you may populate. They are commented out meaning you need to remove the ``#`` at the beginning of the line for them to take effect. The properties you are **required** to set are as follows:

::

    ##Hostname or IP address others can use to access your service
    #external_address   myhost.mydomain.example
    
    ##Primary interface on host
    #external_address_if_name eth0

and the other entries (administrator_email, site_name, city, country, latitude, longitude, etc.) are **highly recommended**.

In the example above remove the leading ``#`` before external_address and external_address_if_name respectively. Also replace *myhost.mydomain.example* and *eth0* with the values relevant to your host. There are additional fields available for you to set. None of them are required but it is highly recommended you set as many as possible since it will make finding your services easier for others. More information on the available fields can be found in the configuration file provided by the RPM install. 

.. _install_centos_step7:

Step 7: Starting your services 
------------------------------- 
You can start all the services by rebooting the host since all are configured to run by default. Otherwise you may start them with the following commands as a root user:
::

    /etc/init.d/bwctl-server start
    /etc/init.d/owamp-server start
    /etc/init.d/perfsonar-lsregistrationdaemon start

Note that you may have to wait a few hours for NTP to synchronize your clock before starting bwctl-server and owamp-server.

Configuring Central Management
-------------------------------
Refer to the documentation here: :doc:`/multi_overview`

Configuring through the web interface
--------------------------------------
After installing the perfsonar-toolkit bundle, you should disable SELinux to gain access to the web interface.  This is done with the following commands:
::

    echo 0 >/selinux/enforce
    sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

After that, you can refer to the general perfSONAR configuration from :doc:`install_config_first_time`.

