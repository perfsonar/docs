***********
Quick Start
***********

#. Download the NetInstall ISO for :centos_netinstall_iso:`i386` or :centos_netinstall_iso:`x86_64` depending on your system's architecture. The NetInstall is the recommended installation type, but for more information on other installation types see :doc:`install_getting`.

        .. seealso:: The NetInstall is the recommended installation type, but for more information on other installation types see :doc:`install_getting`.
#. Using your favorite software, burn the image to a CD, DVD or USB drive and insert the chosen installation media into your host
#. Follow the prompts provided by the CentOS installer to install the required packages. If you have installed a Linux operating system before, these prompts should be relatively self-explanatory. 

        .. seealso:: For a complete walkthrough of these prompts see :doc:`install_centos_netinstall`
#. Once the installation completes and the host reboots, from the console login using the root password you created during the previous step
#. Run the command ``/opt/perfsonar_ps/toolkit/scripts/nptoolkit-configure.py`` to create a new user that can log in to the web administrator interface. At the prompts enter **2**, **1**, **no**, **yes**, the new username, your desired password (twice), and **0** as shown below (where the new username is **webadmin**):

    .. code-block:: console

        [root@localhost ~]# /opt/perfsonar_ps/toolkit/scripts/nptoolkit-configure.py
        
        Internet2 Network Performance Toolkit customization script
        Options in MAGENTA have yet to be configured
        Options in GREEN have already been configured

        1. Configure Networking
        2. Manage Users
        0. exit

        Make a selection: 2
  
        Welcome to the Internet2 pS-Performance Toolkit user administration program.
        This program will help you administer users.
        You may configure any of the options below with this program: 
            1. Add a new user
            2. Delete a user
            3. Change a user's password
            0. exit
        Make a selection: 1
 
        Enter the user whose account you'd like to add. Just hit enter to exit: webadmin
        Should this user be able to login via SSH? [yes] no


        NOTE: you must enable SSH via the web interface before this user can login remotely


        Is this user an administrator? [yes] 
        Please specify a password for the webadmin account.
        Changing password for user webadmin.
        New password: 
        Retype new password: 
        passwd: all authentication tokens updated successfully.


        You may configure any of the options below with this program: 
            1. Add a new user
            2. Delete a user
            3. Change a user's password
            0. exit
        Make a selection: 0

    .. seealso:: For more information on adding new users see :doc:`manage_users`
#. Open *http://<hostname>* in a web browser where *<hostname>* is the name or address of your host
#. Click on **Administrative Info** in the left menu and login as the user created in the previous step
    
    .. image:: images/install_quick_start-admininfo.png
#. On the page that loads, click the *Edit* button (1) and enter the requested information in the provided fields. Click *OK* (2) and then *Save* (3) when you are done.

    .. image:: images/install_quick_start-admininfo2.png
    .. seealso:: For more information on updating administrative information see :doc:`manage_admin_info`
#. You are now ready to add some regular tests. Click on *Configure Tests* in the left menu.

    .. image:: images/install_quick_start-configtests1.png
#. On the page that loads use the buttons to select the types of tests you want to add (1). You will initially be prompted for test parameters. Enter a human-readable description of the tests and change any parameters you desire (2). In general the defaults will be fine for most cases. Click *Add* when done (3).

    .. image:: images/install_quick_start-configtests2.png
#. You now need to select other hosts to test against. You may do so by explicitly adding a host or selecting a *community* and browsing the list (1). When you are done adding tests, hit *Save* (2).

    .. image:: images/install_quick_start-configtests3.png
    .. seealso:: For more information on adding regular tests see :doc:`config_regular_testing`
#. After some time you may view the results of your tests by clicking on **Throughput/Latency Graphs** or **Traceroute Graphs** in the left menu (depending on the test type).

    .. image:: images/install_quick_start-graphs.png

    .. warning:: It will take time for data to be collected and display on the graphs. For throughput data this may be serveral hours depending on the test interval. For all other test types, you should see data within 30 minutes.
    .. seealso:: For more information on using the graphs :doc:`using_graphs`


