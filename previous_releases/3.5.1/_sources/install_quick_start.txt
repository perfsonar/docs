*********************************
Toolkit Installation Quick Start
*********************************

These instructions are for the full Toolkit installation. For other perfSONAR installtion options, see :doc:`install_options`.

#. Download the NetInstall ISO for :centos_netinstall_iso:`i386` or :centos_netinstall_iso:`x86_64` depending on your system's architecture.

        .. seealso:: The NetInstall is the recommended installation type, but for more information on other installation types see :doc:`install_getting`.
#. Using your favorite software, burn the image to a CD, DVD or USB drive and insert the chosen installation media into your host.  

    .. note:: Linux and Macintosh users may consider using the dd tool: *sudo dd if=/PATH/TO/FILE.iso of=/dev/DISK*
#. Follow the prompts provided by the CentOS installer to install the required packages. If you have installed a Linux operating system before, these prompts should be relatively self-explanatory. 

        .. seealso:: For a complete walkthrough of these prompts see :doc:`install_centos_netinstall`
#. Once the installation completes and the host reboots, login from the console using the root password you created during the previous step
#. You will be prompted to create a user and password that can be used to administer the host through the web interface. Follow the prompts to complete this step.
    .. image:: images/install_config_first_time-user5.png
#. Open *http://<hostname>* in a web browser where *<hostname>* is the name or address of your host
#. Click on **Edit** (A) in the host information section of the main page or **Configuration** (B) button in the right-upper corner and login as the web administrator user created in the previous step
    
    .. image:: images/install_quick_start-admininfo.png
#. On the page that loads, enter the requested information in the provided fields. Click **Save** when you are done.

    .. image:: images/install_quick_start-admininfo2.png
    .. seealso:: For more information on updating administrative information see :doc:`manage_admin_info`
#. You are now ready to add some regular tests. Click on **Configure tests** in main page.

    .. image:: images/install_quick_start-configtests1.png
#. On the page that loads click on the **+Test** button too choose and add the test type you would like.

	.. image:: images/install_quick_start-configtests2.png
#. A drop-down list shows to choose test type. Click on a selected test type you would like to add. 

	.. image:: images/install_quick_start-configtests3.png
#. You will now be prompted for test parameters (1). Enter a human-readable description of the tests and change any parameters you desire. In general the defaults will be fine for most cases.

	.. image:: images/install_quick_start-configtests4.png
#. You now need to select other test members to test against. Go to section *Test members* in the same page (2). 

    .. image:: images/install_quick_start-configtests5.png	
#. You may add test members explicitly adding a host (A) or selecting a *browse communities* and browsing the list (B). When you are done entering host details, hit **Add host** to add a test member to the list of hosts.

    .. image:: images/install_quick_start-configtests6.png	
#. Click **OK** to save test definition and close test configuration window. Then click the **Save** button at the bottom of the screen to apply your changes.
    .. seealso:: For more information on adding regular tests see :doc:`manage_regular_tests`
#. After some time you may view the results of your tests in section **Test Results** in the main page.

    .. image:: images/install_quick_start-graphs.png

    .. warning:: It will take time for data to be collected and display on the graphs. For throughput data this may be serveral hours depending on the test interval. For all other test types, you should see data within 30 minutes.
    .. seealso:: For more information on using the graphs :doc:`using_graphs`


