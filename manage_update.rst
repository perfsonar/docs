********************
Updating the Toolkit
********************

Just like any other host on your network, it is critical to stay up-to-date with the latest packages on your perfSONAR Toolkit. You will want to make sure you have the latest security fixes as well as the ability to take advantage of the great new features constantly being added to the tools. In general you will keep your host up-to-date with the operating system's package manager (e.g. yum), but in some special cases things may be more involved. Be sure to watch release notes and this page when such cases arise.

Manually Updating with Yum
==========================
Anytime you want to manually update your host, simply run the following::
    
    yum update
    
The *yum* package manager is used by RedHat-based operating systems like CentOS to update packages. Running the command above will download the latest perfSONAR packages as well as any operating system packages available.

.. _manage_update-auto:

Automatic Updates
=================

.. note:: Automatic updates are enabled by default in the perfSONAR Toolkit.

You may choose to enable automatic updates to aid in applying the latest software packages to your system. Automatic updates include all perfSONAR, operating system and third-party packages. Enabling this feature will help keep the latest security fixes on the system, but keep in mind it is possible some updates may break your host unexpectedly. The following rule of thumb from `Fedora <http://fedoraproject.org/wiki/AutoUpdates>`_ may be useful when considering whether to enable this feature:

.. epigraph::
        
    If the machine is a critical server, for which unplanned downtime of a service on the machine can not be tolerated, then you should not use automatic updates. Otherwise, you **may** choose to use them.

It is also important to note that automatic updates do not perform all required system reboots or service restarts. Also, auto-updates happen nightly so there may be a period of up to 24 hours where you do not receive a patch. Enabling this feature still requires close monitoring of the host to make sure all updates are applied completely and properly.

You may enable/disable automatic updates from the web interface as follows:

#. Open your toolkit web interface in a browser.
#. Click on **Edit** (A) in the host information section of the main page or **Configuration** (B) button in the right-upper corner and login as the web administrator user created during installation.

    .. image:: images/manage_update-configure-icon.png

    .. seealso:: See :doc:`manage_users` for more details on creating a web administrator account.
#. On the **Host** tab click the button under the **Auto Updates** heading to enable or disable auto-updates as indicated by the color and status text of the button.
    
    .. image:: images/manage_update-enable.png

#. Click **Save** to apply your changes. After a loading screen you should see a message at the bottom indicating your changes have been saved.
    
Alternatively, in CentOS7, you may enable auto updates from the command-line with the following commands (must be run as a root user):
  
    systemctl enable yum-cron
    systemctl start yum-cron
    
Likewise, you may disable auto-updates from the command-line by running:

    systemctl stop yum-cron
    systemctl disable yum-cron

For CentOS6, use *chkconfig* and *service* equivalents.

Also note that the main configuration file for auto-updates lives at */etc/yum*. See the yum-cron man page or the page `here <http://fedoraproject.org/wiki/AutoUpdates>`_ for more information on using auto-updates and advanced options like excluding packages from updates. 

Special Upgrade Notes
=====================
* 4.0 can run on both CentOS 6 and CentOS 7. If you wish to migrate an existing CentOS 6 host to CentOS 7 see the instructions at :doc:`install_migrate_centos7`.