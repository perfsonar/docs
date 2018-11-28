**************************
Toolkit Full Install Guide
**************************

The CentOS Full Install distribution of the perfSONAR toolkit is an ISO image that can be mounted to a DVD or USB drive. The image contains all the required packages so Internet connectivity is not required for the initial install. The document describes step-by-step how to install this distribution in the two available modes.

.. seealso::  See :ref:`GettingChooseInstall` for more information on choosing an installation type.

Downloading installation media and booting the system
=====================================================

#. Download the ISO image from :ref:`GettingDownloads` or below:

    +--------------+-------------------------------------------------------------------------------+
    | Architecture | Downloads                                                                     |
    +==============+===============================================================================+
    | x86_64       | :centos_fullinstall_iso:`iso <x86_64>` :centos_fullinstall_md5:`md5 <x86_64>` |
    +--------------+-------------------------------------------------------------------------------+
#. Verify the md5 checksum by verifying the two lines output are the same when you run the command below (replace the filenames with that of the downloaded iso and md5). If they do no match then you may need to re-download the iso images:

        .. code-block:: console

            $ md5sum pS-Toolkit-4.X-CentOS7-FullInstall-x86_64.iso;cat pS-Toolkit-4.X-CentOS7-FullInstall-x86_64.iso.md5

#. Mount the ISO to a DVD or USB drive 
     .. note:: The Full Install ISO is generally too large to fit on current writable CDs
     .. note:: Detailed instructions on mounting an ISO image to the above media is beyond the scope of this document. Linux and Macintosh users may consider using the dd tool: ``sudo dd if=/PATH/TO/FILE.iso of=/dev/DISK`` or the pv tool (as root): ``pv /PATH/TO/FILE.iso > /dev/DISK``
#. Insert the media containing the ISO into the target end system
#. Power on the host 
    .. note:: By default CentOS 7 will use a graphical installer.

Step-by-Step Guide using graphical installer
============================================
#. You will be presented with a screen asking you to select how you want to install the system. Select **Install the perfSONAR Toolkit** and hit enter.
    .. image:: images/install_fullinstall-graph-1boot.png
#. You will first be asked to select your language. Make your choice and select **OK** to continue.
    .. image:: images/install_fullinstall-language.png
#. The next screen will present installation summary and you will be prompted to complete a few sections including at minimum localization and installation destination sections. Sections to complete are marked with special exclamation icon.
    .. image:: images/install_fullinstall-install-summary.png

    .. container:: topic

        **Special Topic: Localization**
        
        #. Select **DATE&TIME** to choose your timezone. When you have chosen your timezone, hit **Done**.
            .. image:: images/install_fullinstall-install-summary-timezone.png
            
            .. note:: You will not be able to set NTP source as this installation assumes no network connectivity.
            
        #. Select **KEYBOARD** and choose your keyboard layout and select **Done** to continue.
            .. image:: images/install_fullinstall-install-summary-keyboard.png
            
        **Special Topic: Installation destination**
        
        #. Scroll down the screen and select **INSTALLATION DESTINATION** to choose where you would like to install the operating system and how you would like to partition the drive. 
        #. First select the device you would like to install to by clicking on a selected **Local Standard Disks**.
            .. image:: images/install_fullinstall-install-summary-disk-select.png
        #. If you use clean disk you may select **Automatically configure partitioning** under **Other Storage Options**. If you want to change partitioning schema or delete unused partitions go to **Other Storage Options** and select **I will configure partitioning**
            .. image:: images/install_fullinstall-install-summary-disk-select2.png
            
            .. note:: Manual partitioning will be required if you want to replace existing partitions on the disk.
        
        **Special Topic: Manual partitioning**
        
        #. **MANUAL PARTITIONING** screen allows you to setup a custom partitioning scheme including deleting unused partitions.
        #. If you choose to manually partition the disk this screen will allow you to edit existing partitions. Select them and use **-** (minus sign) to delete partitions to free disk space. Then select **Click here to create them automatically** in order to set new partitions with default setup.
            .. image:: images/install_fullinstall-install-summary-disk-manual-part1.png
        
        #. New partitioning will be shown under *New CentOS 7 Installation* section as shown in the image below.
            .. image:: images/install_fullinstall-install-summary-disk-manual-part2.png     
    
#. After you have selected the hard drive and the desired partitioning scheme, select **Done**. In case of disk partitioning customizations you will be then presented with a summary of changes screen. Select **Accept Changes** to proceed to the next step.
    .. image:: images/install_fullinstall-install-summary-disk-manual-changes.png
#. You will now be presented again with a completed installation summary screen. Click **Begin Installation** to start installation process.
    .. image:: images/install_fullinstall-install-summary-begin.png
#. During package installation you will be asked to configure at least the root user settings. 
    .. image:: images/install_fullinstall-install-user-settings.png
#. Select **ROOT PASSWORD** in order to configure root password. Please make note of this password as it will be required to login to the host after installation completes. Normal precautions should be taken to protect the root password as it can be used to make changes to the system. For example, safe password practices would recommend a password that contains a mixture of letters of different case, numbers, symbols, and a length greater than 8.  It is also not recommend to re-use passwords on multiple machines, in the event of a system breach. After entering and confirming the password hit **Done**.
    .. image:: images/install_fullinstall-install-user-settings-rootpasswd.png
#. The installation process will continue as shown below.
    .. image:: images/install_fullinstall-install-pkgs-installation.png
#. If the installation is successful you will be presented with the screen below. Select **Reboot** to restart the host. 
    .. image:: images/install_fullinstall-install-reboot.png
#. After the reboot you will be presented with a login screen. You can login with the root user and the password set during the installation process. You are now ready to move on to :doc:`install_config_first_time`
