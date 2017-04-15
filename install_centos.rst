******************************
Bundle Installation on CentOS 
******************************

perfSONAR combines various sets of measurement tools and services. Commonly people install the entire set of tools using the Toolkit ISO (as detailed at :doc:`install_getting`) but this may not be optimal for every situation. For example if you only need a subset of the tools, you have an existing CentOS system on which you'd like to install the software and/or you are doing a large deployment of perfSONAR nodes. With this in mind RPMs are available that install the bundles described in :doc:`install_options`. The steps in the remaining sections of this document detail the steps required for installing these bundles.

System Requirements 
==================== 
* **Operating System:**

  * Any system running **CentOS 7**. perfSONAR 4.X toolkit ISOs are only available as CentOS 7. CentOS 7 drops support for i386/i686 architectures, so there are only x86_64 versions of the CentOS 7 perfSONAR packages available.
  * We still offer packages support for any system running either a 32-bit or 64-bit **CentOS 6**.  Existing CentOS 6 users will be able to auto-update.
  * Other RedHat-based operating systems may work, but are not officially supported at this time.

* See :doc:`install_hardware` for hardware requirements and more.

.. note:: Installing a graphical/desktop environment with perfSONAR is not supported.  These environments generally come with a Network Manager that conflicts with the way that perfSONAR is tuning the network interface parameters.  We recommend doing only server grade OS installs.

.. _install_centos_installation:

Installation 
============

.. _install_centos_step1:

Step 1: Configure Yum 
---------------------- 
The process configures yum to point at the necessary repositories to get packages needed for perfSONAR. **You will need to follow the steps below as privileged user**:

#. Install the EPEL RPM:
    *CentOS 6*::

        rpm -hUv https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

    *CentOS 7*::

        rpm -hUv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

#. Install the Internet2-repo RPM:

    *CentOS 6*::

        rpm -hUv http://software.internet2.edu/rpms/el6/x86_64/main/RPMS/Internet2-repo-0.6-1.noarch.rpm

    *CentOS 7*::

        rpm -hUv http://software.internet2.edu/rpms/el7/x86_64/main/RPMS/Internet2-repo-0.7-1.noarch.rpm

#. Refresh yum's cache so it detects the new RPMS::

    yum clean all


.. _install_centos_step2:

Step 2: Install a Bundle 
-------------------------------- 
Choose one of the following bundles and see :doc:`install_options` page for more information about what these bundles are.

* **perfSONAR Test Point**::

    yum install perfsonar-testpoint  

  Additionally, you may also install the Toolkit service-watcher, ntp, security (firewall rules) and sysctl packages.

  *Optional Packages*

    To install additional packages, run::

    /usr/lib/perfsonar/scripts/install-optional-packages.py

    Or, you can manually install them to your liking by running:

     * ``yum install perfsonar-toolkit-servicewatcher``
     * ``yum install perfsonar-toolkit-ntp``
     * ``yum install perfsonar-toolkit-security``
     * ``yum install perfsonar-toolkit-sysctl``

  In particular, you should install perfsonar-toolkit-ntp if you are not managing your ``ntp.conf`` file in some other manner.

* **perfSONAR Core**::

    yum install perfsonar-core

  Just as in TestPoint Bundle, optional packages are available and can be installed via a script or manually.

  *Optional Packages*

    To install additional packages, run::

    /usr/lib/perfsonar/scripts/install-optional-packages.py


    Or, you can manually install them to your liking by running:

       * ``yum install perfsonar-toolkit-servicewatcher``
       * ``yum install perfsonar-toolkit-ntp``
       * ``yum install perfsonar-toolkit-security``
       * ``yum install perfsonar-toolkit-sysctl``



* **perfSONAR Central Management**::

    yum install perfsonar-centralmanagement

  The Central Management bundle might be installed alongside another bundle.
  
* **perfSONAR Toolkit**::

    yum install perfsonar-toolkit


.. _install_centos_step3:

Step 3: Verify NTP and Tuning Parameters 
----------------------------------------- 
*Step 3 can be ignored for perfsonar-toolkit package installation as its instructions are included and run automatically*

* **NTP Tuning**

  - **Auto-select NTP servers based on proximity**
    
    The Network Time Protocol (NTP) is required by the tools in order to obtain accurate measurements. Some of the tools such as BWCTL/pscheduler will not even run unless NTP is configured. If an optional package was installed, then run::

        /usr/lib/perfsonar/scripts/configure_ntpd new
        
    For CentOS6::
        
        service ntpd restart
        
    For CentOS7::
        
        systemctl restart ntpd

  You can verify if NTP is running with the following command::

    /usr/sbin/ntpq -p  

* **System Tuning**
  
  It is important to make sure that your host is properly tuned for maximum TCP performance on the WAN. You should verify that htcp, not reno, is the default TCP congestion control algorithm, and that the maximum TCP buffers are big enough for your paths of interest.  

  - **Configure perfSONAR sysctl settings**
    
    If the optional package was installed, then run::  

    /usr/lib/perfsonar/scripts/configure_sysctl

  - **Advanced Manual Tuning**
    
    For more information please refer to `http://fasterdata.es.net/host-tuning/linux/`  



.. _install_centos_step4:

Step 4: Firewall and Security Considerations 
-------------------------------------------- 
**Package Install**

If you have installed the perfsonar-toolkit-security package, then you can configure the firewalld / IPTable entries by running::

    /usr/lib/perfsonar/scripts/configure_firewall

The package also installs fail2ban.


Or, if you would like to configure the rules manually, then please review the `document here <http://www.perfsonar.net/deploy/security-considerations/>`_ on the ports that need to be open.

Additionally, bwctl and pscheduler allow you to limit the parameters of tests such as duration and bandwidth based on the requesters IP address. It does this through the files ``bwctl-server.limits`` and ``pscheduler/limits.conf``. 
ESnet provides a file containing all R&E subnets, which is updated nightly. Instructions on how to download this file and configure pScheduler and
bwctl to use it are described on the page :doc:`manage_limits`.

Note that the perfsonar-toolkit-security package is automatically included in the perfsonar-toolkit bundle.

.. _install_centos_step5:

Step 5: Auto updates
--------------------

You can also enable yum ‘auto updates’ to ensure you always have the most current and hopefully most secure packages. To do this follow the steps in :ref:`manage_update-auto-cli`.

.. note:: Automatic updates are enabled by default in the perfSONAR Toolkit.

.. _install_centos_step6:

Step 6: Service Watcher
------------------------
The ``perfsonar-toolkit-servicewatcher`` installs scripts that check if bwctl, pscheduler, owamp, databases and other processes are running and restarts if they have stopped unexpectedly. 

The install automatically configures cron to run the service_watcher regularly.

To run the script manually, run::

  /usr/lib/perfsonar/scripts/service_watcher

.. _install_centos_step7:

Step 7: Register your services 
------------------------------- 

Note: this step can be done through the web interface if the perfsonar-toolkit bundle (or the ISO) was installed. 
See :doc:`manage_admin_info`.

In order to publish the existence of your measurement services there is a single file you need to edit with some details about your host. You may populate this information by opening **/etc/perfsonar/lsregistrationdaemon.conf**. You will see numerous properties you may populate. They are commented out meaning you need to remove the ``#`` at the beginning of the line for them to take effect. The properties you are **required** to set are as follows:

::

    ##Hostname or IP address others can use to access your service
    #external_address   myhost.mydomain.example
    
    ##Primary interface on host
    #external_address_if_name eth0

and the other entries (administrator_email, site_name, city, country, latitude, longitude, etc.) are **highly recommended**.

In the example above remove the leading ``#`` before external_address and external_address_if_name respectively. Also replace *myhost.mydomain.example* and *eth0* with the values relevant to your host. There are additional fields available for you to set. None of them are required but it is highly recommended you set as many as possible since it will make finding your services easier for others. More information on the available fields can be found in the configuration file provided by the RPM install. 

.. _install_centos_step8:

Step 8: Starting your services 
------------------------------- 
You can start all the services by rebooting the host since all are configured to run by default. In order to check services status issue the following commands:
    
    For CentOS6::

        service pscheduler-scheduler status
        service owamp-server status
        service bwctl-server status
        service perfsonar-lsregistrationdaemon status

    For CentOS7::

        systemctl status pscheduler-scheduler.service 
        systemctl status owamp-server.service 
        systemctl status bwctl-server  
        systemctl status perfsonar-lsregistrationdaemon.service

If they are not running you may start them with appropriate init commands as a root user. For example:

    For CentOS6::

        /etc/init.d/owamp-server start
        /etc/init.d/bwctl-server start
        service perfsonar-lsregistrationdaemon start

    For CentOS7::

        /etc/init.d/owamp-server start
        /etc/init.d/bwctl-server start
        systemctl start perfsonar-lsregistrationdaemon

Note that you may have to wait a few hours for NTP to synchronize your clock before starting bwctl-server and owamp-server.

Configuring Central Management
-------------------------------
If your node is part of a measurement mesh and you installed perfsonar-centralmanagement bundle refer to the documentation here: :doc:`/multi_overview`

Configuring perfSONAR through the web interface
------------------------------------------------
If you installed the perfsonar-toolkit or perfsonar-centralmanagement bundle on an existing CentOS host, 
you'll probably need to disable SELinux to gain access to the web interface. This is done with the following commands:
::

    echo 0 >/selinux/enforce
    sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

After that, you can refer to the general perfSONAR configuration from :doc:`install_config_first_time`.

