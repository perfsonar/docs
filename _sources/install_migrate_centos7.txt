************************************
Migrating from CentOS 6 to CentOS 7
************************************

This page describes the migration procedure for moving a perfSONAR installation from a CentOS 6 to a CentOS 7 host. It assumes both hosts have the same :doc:`bundle <install_options>` and version of perfSONAR installed. If you do not wish to keep any existing data or configuration from the CentOS 6 host you may ignore this section and do a normal clean installation. 

.. note:: These steps can also be used to migrate an existing host to new hardware even if both systems are running the same OS version. There is nothing specific to CentOS 6 or CentOS 7 in this procedure. It is only labelled as such for convenience since for the time-being this is likely the most common type of migration to be performed by perfSONAR users.

Migration Process
=================
#. Login in to your CentOS 6 host via SSH or the terminal. You must do so as a user that has superuser privileges or is allowed to run the `sudo` command. **All commands in this section require superuser privileges.**

#. Upgrade your CentOS 6 host to the same version of perfSONAR as the CentOS 7 host if you have not already done so. See :doc:`manage_update` for more details on the update process

#. Run **one** of the commands below to create a backup of all relevant files in `~/ps-backup.tgz`. The option you choose depends on whether you also want to preserve your measurement archive data:

    * *Option 1:* Ignore measurement archive data (quicker since measurement archive data may be large)::

        /usr/lib/perfsonar/scripts/ps-migrate-backup.sh ~/ps-backup.tgz

    * *Option 2:* Alternatively, if you also wish to migrate the measurement archive databases add the `--data` parameter. Please note, **this may take several minutes to several hours depending on the amount of data in your measurement archive**::

        /usr/lib/perfsonar/scripts/ps-migrate-backup.sh --data ~/ps-backup.tgz

#. Copy the backup file `~/ps-backup.tgz` from your CentOS 6 host to a safe location. This will need to be copied to the new installation later. If you will be overwriting the CentOS 6 host with the new installation, make sure this file is stored safely on another system, so it can be copied to the new installation later.

#. Logout of the CentOS 6 host

#. Perform a clean installation of the perfSONAR on a CentOS 7 host using the same perfSONAR bundle and version that was installed on the CentOS 6 host. You may choose to install on the existing CentOS 6 hardware or a completely new host. If it is the former, make sure you have downloaded your CentOS 6 backup file to a safe location.

#. Copy the file `~/ps-backup.tgz` from the location chosen in step 3 to your new system. The exact command to do this will depend on where you placed the file (e.g. use scp).

#. Login to your new CentOS 7 Toolkit installation via SSH or the terminal

#. Run **one** of the commands below to restore your configuration. The option you choose will be dependent on whether you wish to restore your measurement archive data:

    * *Option 1:* Ignore measurement archive data (quicker since measurement archive data may be large)::
    
        /usr/lib/perfsonar/scripts/ps-migrate-restore.sh ~/ps-backup.tgz

    * *Option 2:* Alternatively, to also restore the measurements databases add the `--data` paremeter. Please note, **this may take several minutes to several hours depending on the amount of data in your measurement archive**::

        /usr/lib/perfsonar/scripts/ps-migrate-restore.sh --data ~/ps-backup.tgz

#. Reboot your host::

    reboot

Your host should now be migrated.

Changing IP Address/Hostname
=============================
When migrating an installation, there is no requirement to change IP or hostname, in fact its likely simpler if you do not. You may stop reading if you wish to keep the address the same.  

If for your own purposes you need/desire to use a new address on a host you should be to do so with little to no additional configuration changes. It's largely dependent on your perfSONAR setup. Below are some notes to help you determine if any further configuration changes are needed:

    - If you are running the toolkit, everywhere your address is displayed is dynamically generated. There are no configuration files that need to be changed to display the new address. If you are still seeing the old address, check your network configuration or verify that DNS has been properly updated.
    - The most likely configuration file where you will see your local address is in */etc/perfsonar/meshconfig-agent-tasks.conf*. In particular the following two cases:
    
        #. If it is running tests defined by a remote mesh configuration. In this case the perfsonar-meshconfig-agent will overwrite the definitions when it runs (defaults to every hour or on service restart) so you are not strictly required to manually update it. 
        #. It may also contain the address or interface name if you explicitly selected it through the Toolkit GUI or manually defined tests. If this is the case, the manual definitions will need to be updated manually by replacing the old address with the new.
    - By default, perfSONAR does not insert the local address in any files, but there are a number of advanced options that may contain it if manually set. If you are unsure, it may be a good idea to run `grep -r OLDADDRESS /etc/perfsonar` where `OLDADDRESS` is the previous IP address, hostname or interface you are looking to replace. Generally you should be safe to manually update any references you find. 
