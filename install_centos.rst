******************************
Bundle Installation on CentOS 
******************************

perfSONAR combines various sets of measurement tools and services. Commonly people install the entire set of tools using the Toolkit ISO (as detailed at :doc:`install_getting`) but this may not be optimal for every situation. For example if you only need a subset of the tools, you have an existing CentOS system on which you'd like to install the software and/or you are doing a large deployment of perfSONAR nodes. With this in mind RPMs are available that install the bundles described in :doc:`install_options`. The steps in the remaining sections of this document detail the steps required for installing these bundles.

System Requirements 
==================== 
* **Operating System:**

  * **CentOS 7** and **CentOS 6** x86_64 installations are supported. Other RedHat-based operating systems may work, but are not officially supported at this time.
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

        yum install epel-release

    *CentOS 7*::

        yum install epel-release

#. Install the Internet2-repo RPM:

    *CentOS 6*::

        yum install http://software.internet2.edu/rpms/el6/x86_64/main/RPMS/Internet2-repo-0.6-1.noarch.rpm

    *CentOS 7*::

        yum install http://software.internet2.edu/rpms/el7/x86_64/main/RPMS/Internet2-repo-0.7-1.noarch.rpm

#. Refresh yum's cache so it detects the new RPMS::

    yum clean all


.. _install_centos_step2:

Step 2: Install a Bundle 
-------------------------------- 
**CHOOSE ONE** of the following bundles and see :doc:`install_options` page for more information about what these bundles are.

* **perfSONAR Tools**::

    yum install perfsonar-tools  
  
* **perfSONAR Test Point**::

    yum install perfsonar-testpoint  

* **perfSONAR Core**::

    yum install perfsonar-core

* **perfSONAR Central Management**::

    yum install perfsonar-centralmanagement

* **perfSONAR Toolkit**::

    yum install perfsonar-toolkit

Optional Packages
++++++++++++++++++
In addition to any of the bundles above you may also **optionnally** choose to install one or more of our add-on packages (these are automatically added on the perfsonar-toolkit bundle):

     * ``yum install perfsonar-toolkit-ntp`` - Automatically detects closest NTP servers and sets them in ntp.conf
     * ``yum install perfsonar-toolkit-security`` - Adds default firewall rules and installs fail2ban
     * ``yum install perfsonar-toolkit-servicewatcher``- Adds a cron job that checks if services are still running.
     * ``yum install perfsonar-toolkit-sysctl`` - Adds default sysctl tuning settings

You may also run the command below to get everything listed above on **perfsonar-testpoint** and **perfsonar-core** bundles::

    /usr/lib/perfsonar/scripts/install-optional-packages.py

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

    /usr/lib/perfsonar/scripts/configure_firewall install

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

No actual configuration is required but filling fields such as administrator_email, site_name, city, country, latitude, longitude, etc. are **highly recommended**. You can add these by removing the leading `#` of any property and filling it out with a proper value for your host. Changes will be picked-up automatically without need for any restarts.

.. _install_centos_step8:

Step 8: Starting your services 
------------------------------- 
You can start all the services by rebooting the host since all are configured to run by default. In order to check services status issue the following commands:
    
    For CentOS6::

        service pscheduler-scheduler status
        service pscheduler-runner status
        service pscheduler-archiver status
        service pscheduler-ticker status
        service owamp-server status
        service bwctl-server status
        service perfsonar-lsregistrationdaemon status

    For CentOS7::

        systemctl status pscheduler-scheduler
        systemctl status pscheduler-runner
        systemctl status pscheduler-archiver
        systemctl status pscheduler-ticker
        systemctl status owamp-server
        systemctl status bwctl-server  
        systemctl status perfsonar-lsregistrationdaemon

If they are not running you may start them with appropriate init commands as a root user. For example:

    For CentOS6::

        service pscheduler-scheduler start
        service pscheduler-runner start
        service pscheduler-archiver start
        service pscheduler-ticker start
        service owamp-server start
        service bwctl-server start
        service perfsonar-lsregistrationdaemon start

    For CentOS7::

        systemctl start pscheduler-scheduler
        systemctl start pscheduler-runner
        systemctl start pscheduler-archiver
        systemctl start pscheduler-ticker
        systemctl start perfsonar-lsregistrationdaemon
        systemctl start bwctl-server
        systemctl start owamp-server

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

