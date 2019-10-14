******************************
Bundle Installation on CentOS 
******************************

perfSONAR combines various sets of measurement tools and services. Commonly people install the entire set of tools using the Toolkit ISO (as detailed at :doc:`install_getting`) but this may not be optimal for every situation. For example if you only need a subset of the tools, you have an existing CentOS system on which you'd like to install the software and/or you are doing a large deployment of perfSONAR nodes. With this in mind RPMs are available that install the bundles described in :doc:`install_options`. The steps in the remaining sections of this document detail the steps required for installing these bundles.

System Requirements 
==================== 
* **Operating System:**

  * **CentOS 7** x86_64 installations are supported. Other RedHat-based operating systems may work, but are not officially supported at this time.
  * See :doc:`install_hardware` for hardware requirements and more.

.. note:: Installing a graphical/desktop environment with perfSONAR is not supported.  These environments generally come with a Network Manager that conflicts with the way that perfSONAR is tuning the network interface parameters.  We recommend doing only server grade OS installs.

.. _install_centos_installation:

Installation 
============

.. _install_centos_step1:

Step 1: Configure Yum 
---------------------- 
.. note:: If your system is using yum priorities make sure that repositories required for perfSONAR are higher priority than anything else to avoid conflicts with older versions. Please note that yum maintainers do not recommend using priorities.

The process configures yum to point at the necessary repositories to get packages needed for perfSONAR. **You will need to follow the steps below as privileged user**:

#. Install the EPEL RPM::

    yum install epel-release

#. Install the perfSONAR-repo RPM::

    yum install http://software.internet2.edu/rpms/el7/x86_64/latest/packages/perfSONAR-repo-0.9-1.noarch.rpm

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
     * ``yum install perfsonar-toolkit-servicewatcher`` - Adds a cron job that checks if services are still running.
     * ``yum install perfsonar-toolkit-sysctl`` - Adds default sysctl tuning settings
     * ``yum install perfsonar-toolkit-systemenv-testpoint`` - Configures auto-update and set some default logging locations

You may also run the command below to get everything listed above on **perfsonar-testpoint** and **perfsonar-core** bundles::

    /usr/lib/perfsonar/scripts/install-optional-packages.py

.. note:: On a **perfsonar-centralmanagement** system you probably only want the optional **perfsonar-toolkit-servicewatcher** package to be installed.

.. _install_centos_step3:

Step 3: Verify NTP and Tuning Parameters 
----------------------------------------- 
*Step 3 can be ignored for perfsonar-toolkit package installation as its instructions are included and run automatically*

* **NTP Tuning**

  - **Auto-select NTP servers based on proximity**
    
    The Network Time Protocol (NTP) is required by the tools in order to obtain accurate measurements. Measurements will not give accurate results unless NTP is configured. If an optional package was installed, then run::

        /usr/lib/perfsonar/scripts/configure_ntpd new
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

Additionally, pscheduler allows you to limit the parameters of tests such as duration and bandwidth based on the requesters IP address. It does this through the ``/etc/pscheduler/limits.conf``. 
ESnet provides a file containing all R&E subnets, which is updated nightly. Instructions on how to download this file and configure pScheduler to use it are described on the page :doc:`manage_limits`.

Note that the perfsonar-toolkit-security package is automatically included in the perfsonar-toolkit bundle.

.. _install_centos_step5:

Step 5: Auto updates
--------------------

You can also enable yum ‘auto updates’ to ensure you always have the most current and hopefully most secure packages. To do this follow the steps in :ref:`manage_update-auto-cli`.

.. note:: Automatic updates are enabled by default in the perfSONAR Toolkit.

.. _install_centos_step6:

Step 6: Service Watcher
------------------------
The ``perfsonar-toolkit-servicewatcher`` installs scripts that check if important processes are running and restarts if they have stopped unexpectedly. 

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
All services should be started after install. Additionally, you can start all the services by rebooting the host since all are configured to run by default. In order to check services status issue the following commands::

    systemctl status pscheduler-scheduler
    systemctl status pscheduler-runner
    systemctl status pscheduler-archiver
    systemctl status pscheduler-ticker
    systemctl status psconfig-pscheduler-agent
    systemctl status owamp-server
    systemctl status perfsonar-lsregistrationdaemon

If they are not running you may start them with appropriate init commands as a root user. For example::

    systemctl start pscheduler-scheduler
    systemctl start pscheduler-runner
    systemctl start pscheduler-archiver
    systemctl start pscheduler-ticker
    systemctl start psconfig-pscheduler-agent
    systemctl start perfsonar-lsregistrationdaemon
    systemctl start owamp-server

In order to find more information about services running in perfSONAR bundles visit :doc:`manage_daemons`.

Configuring Central Management
-------------------------------
If you installed the perfsonar-centralmanagement bundle see the following documents:

* :doc:`multi_ma_install`
* :doc:`psconfig_publish`
* :doc:`psconfig_maddash_agent`
* :doc:`maddash_intro`

Configuring perfSONAR through the web interface
------------------------------------------------
If you installed the perfsonar-toolkit or perfsonar-centralmanagement bundle on an existing CentOS host, 
you'll probably need to disable SELinux to gain access to the web interface. This is done with the following commands:
::

    echo 0 >/selinux/enforce
    sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

After that, you can refer to the general perfSONAR configuration from :doc:`install_config_first_time`.

