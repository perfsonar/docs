********************
Updating the Toolkit
********************

Just like any other host on your network, it is critical to stay up-to-date with the latest packages on your perfSONAR Toolkit. You will want to make sure you have the latest security fixes as well as the ability to take advantage of the great new features constantly being added to the tools. In general you will keep your host up-to-date with the operating system's package manager (e.g. yum), but in some special cases things may be more involved. Be sure to watch release notes and this page when such cases arise.

Manually Updating with Yum
==========================
Anytime you want to manually update your host, simply run the following::
    
    yum update
    
The *yum* package manager is used by RedHat-based operating systems like CentOS to update packages. Running the command above will download the latest perfSONAR packages as well as any operating system packages available.

.. note:: The Toolkit runs a `Web100 <http://www.web100.org>`_ patched version of the kernel. In some cases CentOS may release a new kernel before the perfSONAR development team has had a chance to create and test a patched version. This will cause an unpatched version to be downloaded, thus disabling the tools NDT and NPAD that rely on the patch. For some users that do not leverage these tools this may not be a concern. Please see our `FAQ <http://www.perfsonar.net/about/faq/#Q25>`_ for more details.

Enabling Auto-Updates
=====================
If you do not want to manually keep your system updated, you may choose to enable automatic updates. As with most decisions there are advantages and disadvantages. The main advantage is that your host should receive updates as soon as they are available. The downside is you are giving-up control as to when updates are applied, including those that may unexpectedly make changes that break the system. `Fedora <http://fedoraproject.org/wiki/AutoUpdates>`_ offers the following advice when making this decision:

    .. epigraph::
        
        If the machine is a critical server, for which unplanned downtime of a service on the machine can not be tolerated, then you should not use automatic updates. Otherwise, you **may** choose to use them.

It is up to the system administrator to make this determination. You may enable auto-updates as a simple cronjob with the following steps:

    #. Login to your host via SSH or terminal
    #. Install the *yum-cron* package via yum::
        
        yum install yum-cron 
    #. Enable and start the yum-cron daemon with the following commands::
    
        /sbin/chkconfig yum-cron on
        /sbin/service yum-cron start
   
Nightly updates should now be running. The main configuration file lives at */etc/sysconfig/yum-cron*. See the yum-cron man page or the page `here <http://fedoraproject.org/wiki/AutoUpdates>`_ for more information on using auto-updates and advanced options like excluding packages from updates. 


Migrating from a 3.3.2 LiveCD
=============================
Starting in 3.4, the LiveCD distribution is no longer provided. If you do not wish to keep any existing data you may ignore this section and do a normal :ref:`clean installation <GettingChooseInstall>`. For existing users of the LiveCD wishing to migrate their data to the latest distribution see the steps below:
    
    #. Login in to your 3.3.2 LiveCD via SSH or the terminal
    #. Run the command below to create a backup of all relevant files in *~/ps-toolkit-livecd-backup.tgz* ::
    
        /opt/perfsonar_ps/toolkit/scripts/ps-toolkit-migrate-backup.sh  ~/ps-toolkit-livecd-backup.tgz
    #. Copy the backup file *~/ps-toolkit-livecd-backup.tgz* from your LiveCD host to a safe location. We will need to copy this to our new installation later. If you will be overwriting the LiveCD with the new installation, make sure this file is stored safely on another system, so it can be copied to the new installation later.
    #. Logout of the LiveCD host
    #. Perform a clean installation of the Toolkit using the latest released version. See :ref:`GettingChooseInstall` for help choosing the right distribution and pointers to installation instructions. You may choose to install on the existing LiveCD hardware or a completely new host. If it is the former, make sure you have downloaded your LiveCD backup file to a safe location.
    #. Copy the file ~/ps-toolkit-livecd-backup.tgz from the location chosen in step 3 to your new system. The exact command to do this will depend on where you placed the file (e.g. use *scp*). 
    #. Login to your new installation via SSH or the terminal
    #. Run the following commands to create a few databases and directories to hold the old LiveCD data::
        
        mkdir -p /opt/perfsonar_ps/perfsonarbuoy_ma/etc
        mysql -u root -e "CREATE DATABASE owamp"
        mysql -u root -e "CREATE DATABASE bwctl"
        mysql -u root -e "CREATE DATABASE traceroute_ma"
        mysql -u root -e "CREATE DATABASE pingerMA"
        mysql -u root -e "CREATE DATABASE cacti"
    #. Run the command below to restore your data::
    
        /opt/perfsonar_ps/toolkit/scripts/ps-toolkit-migrate-restore.sh  ~/ps-toolkit-livecd-backup.tgz
    #. Run the command below to re-install the toolkit which should apply any required updates to the transfered configuration files:
        
        yum reinstall perl-perfSONAR_PS-Toolkit
    #. Reboot your host::
    
        reboot
        
Your host should now be migrated.

.. note:: After the reboot, it still may take many hours to migrate all historical OWAMP, BWCTL and traceroute data to the new measurement archive so please be patient. You may look in */var/log/perfsonar_ps/psb_to_esmond.log* for information on the progress of the migration. 

Special Upgrade Notes
=====================
* Note that updates from versions older than 3.3 are not currently supported. You will need to do a :ref:`clean installation <GettingChooseInstall>` if you wish to move to a newer version.
* When upgrading from version 3.3 to 3.4, your archived BWCTL, OWAMP and traceroute data will automatically be migrated to the new measurement archive introduced in that version. This may take many hours depending on the amount of historical data on your system. See */var/log/perfsonar_ps/psb_to_esmond.log* for logs and progress on the conversion. If you do not wish to convert data you may discard all old data with the following::
 
    mysql -u root -e "DROP DATABASE owamp"
    mysql -u root -e "DROP DATABASE bwctl"
    mysql -u root -e "DROP DATABASE traceroute_ma"
    
    