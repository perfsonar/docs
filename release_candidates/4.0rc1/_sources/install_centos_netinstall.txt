************************
Toolkit NetInstall Guide
************************

The CentOS NetInstall distribution of the perfSONAR Toolkit is an ISO image that can be mounted to a CD, DVD, or USB drive. The image does not contain any of the packages, but will download them from a remote location at install time. The document describes step-by-step how to install the NetInstall distribution.

.. seealso::  See :ref:`GettingChooseInstall` for more information on choosing an installation type.

Downloading installation media and booting the system
=====================================================
#. Download the ISO image from :ref:`GettingDownloads` or below:

    +--------------+-------------------------------------------------------------------------------+
    | Architecture | Downloads                                                                     |
    +==============+===============================================================================+
    | x86_64       | :centos_netinstall_iso:`iso <x86_64>` :centos_netinstall_md5:`md5 <x86_64>`   |
    +--------------+-------------------------------------------------------------------------------+
#. Verify the md5 checksum by verifying the two lines output are the same when you run the command below (replace the filenames with that of the downloaded iso and md5). If they do no match then you may need to re-download the iso images:

        .. code-block:: console

            $ md5sum pS-Toolkit-4.X-CentOS7-NetInstall-x86_64.iso;cat pS-Toolkit-4.X-CentOS7-NetInstall-x86_64.iso.md5

#. Mount the ISO to a CD, DVD, or USB drive
     .. note:: Detailed instructions on mounting an ISO image to the above media is beyond the scope of this document. Linux and Macintosh users may consider using the dd tool: ``sudo dd if=/PATH/TO/FILE.iso of=/dev/DISK``
#. Insert the media containing the ISO into the target end system
#. Power on the host
	.. note:: By default the NetInstall will use a graphical installer. This provides more options related to partitioning and may be more appropriate for those with access to a monitor. For text mode installation guide see :ref:`install_centos_net_text`
	
Step-by-Step Guide using graphical installer
============================================
.. note:: NetInstall will use a text mode for a few first screens. After downloading the image it will enter graphical mode.
	
#. You will be presented with a screen asking you to select how you want to install the system. Select **Install the perfSONAR Toolkit** and hit enter.
    .. image:: images/install_netinstall-graph-1boot.png
#. You will first be asked to select your language. Make your choice and select **OK** to continue.
    .. image:: images/install_netinstall-language.png
#. On the next prompt select your keyboard layout and select **OK** to continue.
    .. image:: images/install_netinstall-keyboard.png
#. If CentOS is able to detect your DHCP server and access the images then your installer will automatically move ahead to the welcome screen and you can skip this step. If you instead see a prompt asking you about your network settings, see the special topic below:
    .. container:: topic

        **Special Topic: Static Networking and Web Proxies**
        
        #. First you will be presented with a screen asking how to configure IPv4 and IPv6 on your host. You may assign a static address by using the *tab* key to select *Manual Configuration*.

            .. image:: images/install_netinstall-static2.png
        #. If you select *Manual Configuration* you will get the screen below asking you to enter the IP addresses, netmask, gateway and DNS server. Enter the required information and select *OK* to continue. 

            .. image:: images/install_netinstall-static3.png
        #. If you are not behind a web proxy, you may see the welcome screen and return to the regular instructions. If you are behind a web proxy you may enter that information in the screen presented (shown below). After this screen you should be presented with a welcome screen. If not you should check your settings and network connection.

            .. image:: images/install_netinstall-static4.png
    
        .. note::  After installation you may need to re-enter the network settings. These settings are only expected for use during the installation process and may be discarded once the process completes.

#. The next screen will download some of the initial installation files. If any errors occur during this phase, you may need to check your network settings. 
    .. image:: images/install_netinstall-2retrieve.png
#. You will next be prompted to choose your timezone. You may do so by using the *tab* and *arrow* keys on your keyboard. When you have chosen your timezone, *tab* to the **OK** box and hit *Enter*.
    .. image:: images/install_netinstall-graph-3timezone.png
#. You will now be asked to set your root password. Please make note of this password as it will be required to login to the host after installation completes. Normal precautions should be taken to protect the root password as it can be used to make changes to the system. For example, safe password practices would recommend a password that contains a mixture of letters of different case, numbers, symbols, and a length greater than 8.  It is also not recommend to re-use passwords on multiple machines, in the event of a system breach. After entering and confirming the password *tab* to the **OK** box and hit *Enter* on your keyboard.
    .. image:: images/install_netinstall-graph-4password.png
#. The next screen asks you where you would like to install the operating and how you would like to partition the drive. After you have selected the desired partitioning scheme and hard drive, select **OK** and hit *Enter* on your keyboard. The following options are available for partitioning:
    * *Use entire drive* - Use this option if there is nothing else installed on the selected hard drive. It will remove any existing data on the hard drive and dedicate the entire disk to the operating system
    * *Replace existing Linux system* - This option removes any Linux partitions on the disk but will keep any non-Linux partitions. 
    * *Use free space* - This option will not touch any existing partitions and will give any remaining space to the hard drive.

    .. image:: images/install_netinstall-graph-5drive.png
    .. note:: You may select the *Review and modify partitioning layout* checkbox to setup a custom partitioning scheme
#. You will now see a series of loading screesn as packages are downloaded and installed. You do not need to do anything except wait. 
    .. note:: This process may take several minutes or longer depending on your network connectivity to the download server.
    .. image:: images/install_netinstall-graph-6retrieveinfo.png
        :width: 49%
    .. image:: images/install_netinstall-graph-7dependencies.png
        :width: 49%
    .. image:: images/install_netinstall-graph-8startinstall.png
        :width: 49%
    .. image:: images/install_netinstall-graph-9install.png
        :width: 49%
#. If the installation is successful you will be presented with the screen below. Select **Reboot** to restart the host. 
    .. image:: images/install_netinstall-graph-10endinstall.png
#. After the reboot you will be presented with a login screen. You can login with the root user and the password set during the installation process. You are now ready to move on to :doc:`install_config_first_time`
    .. image:: images/install_netinstall-11login.png

.. _install_centos_net_text:

Step-by-Step Guide using text mode
==================================
#. You will be presented with a screen asking you to select how you want to install the system. Select **Install the perfSONAR Toolkit in text mode** and hit enter.
    .. image:: images/install_netinstall-1boot.png
#. You will be first asked to select your language. Make your choice and select **OK** to continue.
    .. image:: images/install_netinstall-language.png
#. On the next prompt select your keyboard layout and select **OK** to continue.
    .. image:: images/install_netinstall-keyboard.png
#. If CentOS was able to detect your DHCP server and access the images then your installer will automatically move ahead and you can skip this step. If you instead see a prompt asking you about your network settings, see the special topic below:
    .. container:: topic

        **Special Topic: Static Networking and Web Proxies**
        
        #. First you will be presented with a screen asking how to configure IPv4 and IPv6 on your host. You may assign a static address by using the *tab* key to select *Manual Configuration*.

            .. image:: images/install_netinstall-static2.png
        #. If you select *Manual Configuration* you will get the screen below asking you to enter the IP addresses, netmask, gateway and DNS server. Enter the required information and select *OK* to continue. 

            .. image:: images/install_netinstall-static3.png
        #. If you are not behind a web proxy, you may see the welcome screen and return to the regular instructions. If you are behind a web proxy you may enter that information in the screen presented (shown below). After this screen you should be presented with a welcome screen. If not you should check your settings and network connection.

            .. image:: images/install_netinstall-static4.png
    
        .. note::  After installation you may need to re-enter the network settings. These settings are only expected for use during the installation process and may be discarded once the process completes.

#. The next screen will download some of the initial installation files. If any errors occur during this phase, you may need to check your network settings. 
    .. image:: images/install_netinstall-2retrieve.png
#. You will now be presented with a welcome screen. Use *tab* on your keyboard to select the **OK** box and hit *Enter* to continue. 
    .. image:: images/install_netinstall-1welcome.png
#. You will next be prompted to choose your timezone. You may do so by using the *tab* and *arrow* keys on your keyboard. When you have chosen your timezone, *tab* to the **OK** box and hit *Enter*.
    .. image:: images/install_netinstall-3timezone.png
#. You will now be asked to set your root password. Please make note of this password as it will be required to login to the host after installation completes. Normal precautions should be taken to protect the root password as it can be used to make changes to the system. For example, safe password practices would recommend a password that contains a mixture of letters of different case, numbers, symbols, and a length greater than 8.  It is also not recommend to re-use passwords on multiple machines, in the event of a system breach. After entering and confirming the password *tab* to the **OK** box and hit *Enter* on your keyboard.
    .. image:: images/install_netinstall-4password.png
#. The next screen asks you where you would like to install the operating and how you would like to partition the drive. After you have selected the desired partitioning scheme and hard drive, select **OK** and hit *Enter* on your keyboard. The following options are available for partitioning:
    * *Use entire drive* - Use this option if there is nothing else installed on the selected hard drive. It will remove any existing data on the hard drive and dedicate the entire disk to the operating system
    * *Replace existing Linux system* - This option removes any Linux partitions on the disk but will keep any non-Linux partitions. 
    * *Use free space* - This option will not touch any existing partitions and will give any remaining space to the hard drive.

    .. image:: images/install_netinstall-5drive.png
#. You will now see a series of loading screesn as packages are downloaded and installed. You do not need to do anything except wait. 
    .. note:: This process may take several minutes or longer depending on your network connectivity to the download server.
    .. image:: images/install_netinstall-6retrieveinfo.png
        :width: 49%
    .. image:: images/install_netinstall-7dependencies.png
        :width: 49%
    .. image:: images/install_netinstall-8startinstall.png
        :width: 49%
    .. image:: images/install_netinstall-9install.png
        :width: 49%
#. If the installation is successful you will be presented with the screen below. Select **Reboot** to restart the host. 
    .. image:: images/install_netinstall-10endinstall.png
#. After the reboot you will be presented with a login screen. You can login with the root user and the password set during the installation process. You are now ready to move on to :doc:`install_config_first_time`
    .. image:: images/install_netinstall-11login.png