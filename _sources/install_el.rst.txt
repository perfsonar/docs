************************************************************
Bundle Installation on RedHat Enterprise Linux Variants 
************************************************************

perfSONAR combines various sets of measurement tools and services bundled in different useful ways. RPMs are available that install the bundles described in :doc:`install_options`. The steps in the remaining sections of this document detail the steps required for installing these bundles.

System Requirements 
==================== 
* **Operating System:**

  * **Alma 9 or Rocky 9** x86_64 installations are supported. Other RedHat-based operating systems based on EL9 may work, but are not officially supported at this time.
  * See :doc:`install_hardware` for hardware requirements and more.

.. note:: Installing a graphical/desktop environment with perfSONAR is not supported.  These environments generally come with a Network Manager that conflicts with the way that perfSONAR is tuning the network interface parameters.  We recommend doing only server grade OS installs.

Installation (Automated Script)
====================================
perfSONAR provides a script that will automatically perform the first two steps in :ref:`install_el_installation`. You can install your choice of bundle with one of the commands below.

* **perfSONAR Tools**::

    curl -s https://downloads.perfsonar.net/install | sh -s - tools

* **perfSONAR Test Point**::

    curl -s https://downloads.perfsonar.net/install | sh -s - testpoint

* **perfSONAR Toolkit**::

    curl -s https://downloads.perfsonar.net/install | sh -s - toolkit

* **perfSONAR Archive**::

    curl -s https://downloads.perfsonar.net/install | sh -s - archive

If you would prefer to perform these steps manually see :ref:`install_el_step1` and :ref:`install_el_step2`.

.. _install_el_installation:

Installation (Manual)
========================

.. _install_el_step1:

Step 1: Configure DNF 
---------------------- 
.. note:: If your system is using dnf priorities make sure that repositories required for perfSONAR are higher priority than anything else to avoid conflicts with older versions. Please note that dnf maintainers do not recommend using priorities.

The process configures dnf to point at the necessary repositories to get packages needed for perfSONAR. **You will need to follow the steps below as privileged user**:

#. Install the EPEL RPM::

    dnf install epel-release

#. Enable the CBR repository::

    dnf config-manager --set-enabled crb

#. Install the perfsonar-repo RPM for EL9::

    dnf install http://software.internet2.edu/rpms/el9/x86_64/latest/packages/perfsonar-repo-0.11-1.noarch.rpm

#. Refresh dnf's cache so it detects the new RPMS::

    dnf clean all


.. _install_el_step2:

Step 2: Install a Bundle 
-------------------------------- 
**CHOOSE ONE** of the following bundles and see :doc:`install_options` page for more information about what these bundles are.

* **perfSONAR Tools**::

    dnf install perfsonar-tools  
  
* **perfSONAR Test Point**::

    dnf install perfsonar-testpoint  

* **perfSONAR Core**::

    dnf install perfsonar-core

* **perfSONAR Archive**::

    dnf install perfsonar-archive

* **perfSONAR Toolkit**::

    dnf install perfsonar-toolkit

Optional Packages
++++++++++++++++++
In addition to any of the bundles above you may also **optionnally** choose to install one or more of our add-on packages (these are automatically added on the perfsonar-toolkit bundle):

     * ``dnf install perfsonar-toolkit-security`` - Adds default firewall rules and installs fail2ban
     * ``dnf install perfsonar-toolkit-sysctl`` - Adds default sysctl tuning settings
     * ``dnf install perfsonar-toolkit-systemenv-testpoint`` - Configures auto-update and set some default logging locations


.. _install_el_step3:

Step 3: Verify Tuning Parameters 
----------------------------------------- 
*Step 3 can be ignored for perfsonar-toolkit package installation as its instructions are included and run automatically* 

* **System Tuning**
  
  It is important to make sure that your host is properly tuned for maximum TCP performance on the WAN. You should verify that htcp, not reno, is the default TCP congestion control algorithm, and that the maximum TCP buffers are big enough for your paths of interest. You can also re-run this script any time you need e.g. when host interface speed changes. 

  - **Configure perfSONAR sysctl settings**
    
    If the optional package was installed, then run::  

    /usr/lib/perfsonar/scripts/configure_sysctl

  - **Advanced Manual Tuning**
    
    For more information please refer to `http://fasterdata.es.net/host-tuning/linux/`  



.. _install_el_step4:

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

.. _install_el_step5:

Step 5: Auto updates
--------------------

You can also enable dnf ‘auto updates’ to ensure you always have the most current and hopefully most secure packages. To do this follow the steps in :ref:`manage_update-auto-cli`.

.. note:: Automatic updates are enabled by default in the perfSONAR Toolkit.

.. _install_el_step6:

Step 6: Register your services 
------------------------------- 

Note: this step can be done through the web interface if the perfsonar-toolkit bundle was installed. 
See :doc:`manage_admin_info`.

No actual configuration is required but filling fields such as administrator_email, site_name, city, country, latitude, longitude, etc. are **highly recommended**. You can add these by removing the leading `#` of any property and filling it out with a proper value for your host. Changes will be picked-up automatically without need for any restarts.

.. _install_el_step7:

Step 7: Starting your services 
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

Configuring an Archive
-------------------------------
If you installed the perfsonar-archive bundle see the following document :doc:`multi_ma_install`
