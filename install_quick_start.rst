***********
Quick Start
***********

#. Download the NetInstall ISO for :centos_netinstall_iso:`i386` or :centos_netinstall_iso:`x86_64` depending on your system's architecture.

        .. seealso:: The NetInstall is the recommended installation type, but for more information on other installation types see :doc:`install_getting`.
#. Using your favorite software, burn the image to a CD, DVD or USB drive and insert the chosen installation media into your host.  Linux and Macintosh users can use the dd tool: *sudo dd if=/PATH/TO/FILE.iso of=/dev/DISK*
#. Follow the prompts provided by the CentOS installer to install the required packages. If you have installed a Linux operating system before, these prompts should be relatively self-explanatory. 

        .. seealso:: For a complete walkthrough of these prompts see :doc:`install_centos_netinstall`
#. Once the installation completes and the host reboots, login from the console using the root password you created during the previous step
#. You will be prompted to create a user and password that can be used to administer the host through the web interface. Follow the prompts to complete this step.
    .. image:: images/install_config_first_time-user5.png
#. Open *http://<hostname>* in a web browser where *<hostname>* is the name or address of your host
#. Click on **Administrative Info** in the left menu and login as the user created in the previous step
    
    .. image:: images/install_quick_start-admininfo.png
#. On the page that loads, click the *Edit* button (1) and enter the requested information in the provided fields. Click *OK* (2) and then *Save* (3) when you are done.

    .. image:: images/install_quick_start-admininfo2.png
    .. seealso:: For more information on updating administrative information see :doc:`manage_admin_info`
#. After this step, you can configure NTP.  Click on *NTP* in the left menu.  When the page loads click **Select Closest Servers** and wait for the operation to complete.  Click **Save** to apply your changes

    .. image:: images/manage_ntp-closest1.png
    .. seealso:: For more information on updating NTP settings see :doc:`manage_ntp`
#. You are now ready to add some regular tests. Click on *Configure Tests* in the left menu.

    .. image:: images/install_quick_start-configtests1.png
#. On the page that loads use the buttons to select the types of tests you want to add (1). You will initially be prompted for test parameters. Enter a human-readable description of the tests and change any parameters you desire (2). In general the defaults will be fine for most cases. Click *Add* when done (3).

    .. image:: images/install_quick_start-configtests2.png
#. You now need to select other hosts to test against. You may do so by explicitly adding a host or selecting a *community* and browsing the list (1). When you are done adding tests, hit *Save* (2).

    .. image:: images/install_quick_start-configtests3.png
    .. seealso:: For more information on adding regular tests see :doc:`manage_regular_tests`
#. After some time you may view the results of your tests by clicking on **Throughput/Latency Graphs** or **Traceroute Graphs** in the left menu (depending on the test type).

    .. image:: images/install_quick_start-graphs.png

    .. warning:: It will take time for data to be collected and display on the graphs. For throughput data this may be serveral hours depending on the test interval. For all other test types, you should see data within 30 minutes.
    .. seealso:: For more information on using the graphs :doc:`using_graphs`


