************************************
Migrating from CentOS 6 to CentOS 7
************************************

This page describes the migration procedure for moving a Toolkit installation from a CentOS 6 to a CentOS 7 host. It assumes both hosts have the same version of perfSONAR Toolkit installed. If you do not wish to keep any existing data from the CentOS 6 host you may ignore this section and do a normal clean installation. 

Migration Process
=================
For existing users wishing to migrate their configuration and data to the CentOS 7 installation see the steps below:

#. Login in to your CentOS 6 host via SSH or the terminal

#. Upgrade your CentOS 6 host to the same version of perfSONAR as the CentOS 7 host if you have not already done so. 

#. Run one of the commands below to create a backup of all relevant configuration files in `~/ps-toolkit-backup.tgz` and/or optionally your data:

    * Ignore measurement archive data (quicker since measurement archive data may be large)::

        /usr/lib/perfsonar/scripts/ps-toolkit-migrate-backup.sh ~/ps-toolkit-backup.tgz

    * Alternatively, if you also wish to migrate the measurement archive databases add the `--data` paremeter::

        /usr/lib/perfsonar/scripts/ps-toolkit-migrate-backup.sh --data ~/ps-toolkit-backup.tgz

#. Copy the backup file `~/ps-toolkit-backup.tgz` from your CentOS 6 host to a safe location. We will need to copy this to our new installation later. If you will be overwriting the CentOS 6 host with the new installation, make sure this file is stored safely on another system, so it can be copied to the new installation later.

#. Logout of the CentOS 6 host

#. Perform a clean installation of the Toolkit on a CentOS 7 host using the same Toolkit version that was installed on a CentOS 6 host. You may choose to install on the existing CentOS 6 hardware or a completely new host. If it is the former, make sure you have downloaded your CentOS 6 backup file to a safe location.

#. Copy the file `~/ps-toolkit-backup.tgz` from the location chosen in step 3 to your new system. The exact command to do this will depend on where you placed the file (e.g. use scp).

#. Login to your new CentOS 7 Toolkit installation via SSH or the terminal

#. Run one of the commands below to restore your configuration:

    * Ignore measurement archive data (quicker since measurement archive data may be large)::
    
        /usr/lib/perfsonar/scripts/ps-toolkit-migrate-restore.sh ~/ps-toolkit-backup.tgz

    * Alternatively, to also restore the measurements databases add the `--data` paremeter::

        /usr/lib/perfsonar/scripts/ps-toolkit-migrate-restore.sh --data ~/ps-toolkit-backup.tgz

#. Reboot your host::

    reboot

Your host should now be migrated.
