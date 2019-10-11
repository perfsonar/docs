********************
Updating perfSONAR
********************

Just like any other host on your network, it is critical to stay up-to-date with the latest packages on your perfSONAR Toolkit. You will want to make sure you have the latest security fixes as well as the ability to take advantage of the great new features constantly being added to the tools. In general you will keep your host up-to-date with the operating system's package manager (e.g. yum or apt), but in some special cases things may be more involved. Be sure to watch release notes and this page when such cases arise.

Manually Updating with Yum or APT
=================================
Anytime you want to manually update your host, simply run the following
    
*CentOS*::

    yum update
    
*Debian*::

    apt-get update
    apt-get dist-upgrade
    
The *yum* package manager is used by RedHat-based operating systems like CentOS to update packages, *apt-get* is used by Debian-based OS. Running the command above will download the latest perfSONAR packages as well as any operating system packages available.

.. _manage_update-auto:

Automatic Updates
=================

.. note:: Automatic updates are enabled by default in the perfSONAR Toolkit.

You may choose to enable automatic updates to aid in applying the latest software packages to your system. Automatic updates include all perfSONAR, operating system and third-party packages. Enabling this feature will help keep the latest security fixes on the system, but keep in mind it is possible some updates may break your host unexpectedly. The following rule of thumb from `Fedora <http://fedoraproject.org/wiki/AutoUpdates>`_ may be useful when considering whether to enable this feature:

.. epigraph::
        
    If the machine is a critical server, for which unplanned downtime of a service on the machine can not be tolerated, then you should not use automatic updates. Otherwise, you **may** choose to use them.

It is also important to note that automatic updates do not perform all required system reboots or service restarts. Also, auto-updates happen nightly so there may be a period of up to 24 hours where you do not receive a patch. Enabling this feature still requires close monitoring of the host to make sure all updates are applied completely and properly.

.. _manage_update-auto-cli:

Managing Automatic Updates from the Command-Line
------------------------------------------------
You can manage auto updates from the command-line by enabling/disabling the yum-cron service on CentOS and configuring the unattended-upgrades option of APT on Debian and Ubuntu.

Run the following commands to **enable** automatic updates (must be run as a root user):

*CentOS*::
  
    systemctl enable yum-cron
    systemctl start yum-cron

*Debian/Ubuntu*::

    apt-get install unattended-upgrades
    /usr/lib/perfsonar/scripts/system_environment/enable_auto_updates new
    
Likewise, you may **disable** auto-updates from the command-line by running the following:

*CentOS*::

    systemctl stop yum-cron
    systemctl disable yum-cron

*Debian/Ubuntu*::

    apt-get purge unattended-upgrades
    rm -f /etc/apt/apt.conf.d/60unattended-upgrades-perfsonar

*CentOS*:

These commands will automatically update **all packages** on the system. Also note that the main configuration file for auto-updates lives at */etc/yum*. See the yum-cron man page or the page `here <http://fedoraproject.org/wiki/AutoUpdates>`_ for more information on using auto-updates and advanced options like excluding packages from update. Also see :ref:`manage_update-auto-disable`. 

*Debian/Ubuntu*:

This configuration enables automatic updates for `Debian security updates <https://www.debian.org/security/>`_ or `Ubuntu security updates <https://wiki.ubuntu.com/Security/Upgrades>`_ and perfSONAR packages.

.. _manage_update-auto-gui:

Managing Automatic Updates from the Toolkit Web Interface
---------------------------------------------------------
If you are running the perfSONAR Toolkit, you may enable/disable automatic updates for **all packages** (not just perfSONAR) on the system from the web interface as follows:

#. Open your toolkit web interface in a browser.
#. Click on **Edit** (A) in the host information section of the main page or **Configuration** (B) button in the right-upper corner and login as the web administrator user created during installation.

    .. image:: images/manage_update-configure-icon.png

    .. seealso:: See :doc:`manage_users` for more details on creating a web administrator account.
#. On the **Host** tab click the button under the **Auto Updates** heading to enable or disable auto-updates as indicated by the color and status text of the button.
    
    .. image:: images/manage_update-enable.png

#. Click **Save** to apply your changes. After a loading screen you should see a green message at the bottom indicating your changes have been saved.


.. _manage_update-auto-disable:

Disabling Automatic Updates for perfSONAR Packages
--------------------------------------------------
The commands in the previous sections control updates for the entire system. If you want to leave automatic updates on for base system packages, but would like to just disable the perfSONAR updates you can do so by following the steps in the previous sections and editing the file **/etc/yum.repos.d/perfSONAR.repo** with the option **enabled** set to **0**. 

.. note:: If you are running against one of our testing repositories you may also need to update the files **/etc/yum.repos.d/perfSONAR-staging.repo** and **/etc/yum.repos.d/perfSONAR-nightly.repo**.

To disable the automatic updating of perfSONAR packages on Debian/Ubuntu delete the line with ``origin=perfSONAR`` pattern from ``/etc/apt/apt.conf.d/60unattended-upgrades-perfsonar``.  After that only the Debian security updates will be installed automatically.

.. _manage_update-notes:

Special Upgrade Notes
=====================

BWCTL Support
-------------
As of the perfSONAR 4.2 release in August 2019, all support for BWCTL tests is discontinued. When perfSONAR 4.0 was released in April 2017, the perfSONAR project began the deprecation of BWCTL. The timeline of events was that followed are below:

* perfSONAR 4.0 was end-of-life on **February 15, 2019** (six months after the final release of perfSONAR 4.1). BWCTL was also end-of-life at this time meaning it stopped receiving security updates. 
* perfSONAR 4.2.0 in August 2019 removes the BWCTL pScheduler plug-ins so pscheduler tests can no longer be run to hosts only running BWCTL. 
* Security updates for the old BWCTL pScheduler plug-ins discontinue in February 2020 when perfSONAR 4.1 is end-of-life. There will be no updates unless any critical security patches arise. 

BWCTL is NOT forcibly removed from CentOS systems that already have it installed. You can remove it manually with ``yum remove bwctl-server bwctl-client``. Debian systems do have an auto-remove function that may remove BWCTL since no packages will be dependent on it once you upgrade to 4.1 or later. Exact behavior depends on how you have apt configured.

With support discontinued, the following cases will no longer work:

#. The remote end is running an unsupported 3.5.1 (released March 2016) or older release. The remedy for this problem is for the remote end to update. 
#. A firewall is blocking port 443. This can be solved by opening port 443 or a non-standard pScheduler port. See :ref:`psconfig_templates_advanced-addresses-pscheduler_address` for more information.

If you are on a pre-4.2.0 release, you can determine which of your tests are still using BWCTL by running the following command on a toolkit installation::

    /usr/lib/perfsonar/scripts/find_bwctl_measurements

This will contact the measurement archive on the local machine and return any BWCTL tests that pScheduler ran and recorded in the last day. See `/usr/lib/perfsonar/scripts/find_bwctl_measurements --help` for information on command-line options to change the archive URL, time range fo data analyzed and other options. Since in 4.2.0 these tests are not possible, a pure 4.2.0 host should return no recent results.

Debian 8 and Ubuntu 14 Support Discontinued
-------------------------------------------
perfSONAR 4.2 is NOT available for Debian 8 (and `Debian 8 is now only supported on a limited set of architectures <https://www.debian.org/releases/jessie/>`_ anyways). If you wish to migrate an existing Debian 8 (Jessie) host to Debian 9 (Stretch) you are advised to do it with the following steps:

#. Lock your system on perfsonar-4.1 packages by replacing the ``perfsonar-release`` repository with a plain ``perfsonar-4.1`` repository entry.  This is done in the ``/etc/apt/sources.list.d/perfsonar-release.list`` file, where you just replace **perfsonar-release** with **perfsonar-4.1** in the ``deb`` and ``deb-src`` lines.
#. Upgrade Debian 8 to Debian 9 (following Debian instructions, here are `Stretch upgrade notes for i386 architecture <https://www.debian.org/releases/stretch/i386/release-notes/ch-upgrading.en.html>`_).
#. Reactivate the ``perfsonar-release`` repository in your perfSONAR APT source file.
#. Run ``apt-get update; apt-get dist-upgrade`` to get the latest version of perfSONAR.
#. Reboot your system one last time.

