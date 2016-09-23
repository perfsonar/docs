******************************************
Configuring the Toolkit for the First Time
******************************************

After installing the perfSONAR Toolkit, there are a few additional steps to be taken before you can begin using your new measurement host. Follow the sections on this page in order to complete the initial configuration and being performing network measurements with your perfSONAR Toolkit.

Your First Login
================
The first time you login to your Toolkit you will be prompted to create a user that can perform administrative actions via the web interface. 

.. note:: Versions prior to version 3.4 would allow the root user to login to the web interface. This was changed in version 3.4 for security purposes hence the *required* prompt.

Follow the prompts to complete the process as shown below:

#. Login with username *root* and the password you created during the installation process. You will get a prompt to create a new user:

    .. image:: images/install_config_first_time-user1.png
#. At the prompt enter the username you'd like to create.

    .. note:: The names *psadmin* and *perfsonar* are not allowed as they conflict with existing users and/or groups on the system.
    
    .. image:: images/install_config_first_time-user2.png
#. You will be prompted if you would like to user to be able to login via SSH. If this user will only be used to access the web interface, you may answer *no*. The default is to answer *no*.

    .. image:: images/install_config_first_time-user3.png
#. You will be prompted to give the user a password and then to confirm it. Remember this password as it will be used to log-in to the web interface to perform administrative functions. Normal precautions should be taken to protect the root password as it can be used to make changes to the system. For example, safe password practices would recommend a password that contains a mixture of letters of different case, numbers, symbols, and a length greater than 8.  It is also not recommend to re-use passwords on multiple machines, in the event of a system breach.

    .. image:: images/install_config_first_time-user4.png
#. After entering your password the account is created. You will be prompted if you would like to create a privileged user and disable SSH access for root account. Note that for security reasons it is recommended to disable SSH root login.  The default is to answer *yes*.

    .. image:: images/install_config_first_time-user5.png
#. You will get a prompt to create a new user. Enter the username you'd like to create.

    .. image:: images/install_config_first_time-user7.png

#. You will be prompted to give the user a password and then to confirm it. Remember this password as it will be used to log-in to via SSH to perform remote administrative functions.

    .. image:: images/install_config_first_time-user8.png

#. After entering your password the account is created. You may now use this account to login via SSH and administer the host with sudo.

    .. image:: images/install_config_first_time-user9.png

.. seealso:: For more information on adding and managing users see :doc:`manage_users`

Accessing the Web Interface
===========================
You may access the web interface by typing `http://<hostname>` in your web browser.

.. note:: For best results it is recommended a browser other than Internet Explorer is used due to some javascript incompatibilities. All other major browsers have been shown to display the web interface without error.  

You will be presented with a page like the following:

.. image:: images/install_config_first_time-web1.png


Updating Your Administrative Information
========================================
Administrative information needs to be populated first. You will be prompted for basic location and contact information. This information is needed so other perfSONAR users can more accurately find your node. To populate the information do the following:

#. Open *http://<hostname>* in a web browser where *<hostname>* is the name or address of your host
#. Click on **Edit** (A) in the host information section of the main page or **Configuration** (B) button in the right-upper corner and login as the web administrator user created in the previous step
    
    .. image:: images/install_quick_start-admininfo.png
#. On the page that loads, enter the requested information in the provided fields. Click **Save** when you are done.

    .. image:: images/install_quick_start-admininfo2.png
    .. seealso:: For more information on updating administrative information see :doc:`manage_admin_info`

After completing this step, you should be able to access the **Global Services** page and see your host listed within 24 hours of making the change.

Managing Toolkit Security
=========================
perfSONAR hosts are just like any other host and need to be actively managed to avoid being compromised. perfSONAR hosts run a number of common services, listen on numerous ports and may be outside your site's normal firewall. No set of steps will make your host invincible, but below are some steps that can be taken to contribute toward protecting your host:
 
  * An important aspect of security is to stay informed. Multiple system administrators from your site should be subscribed to the perfsonar security `announcement list <https://lists.internet2.edu/sympa/subscribe/perfsonar-announce>`_. This mailing list keeps users up-to-date on actions that need to be taken when critical security updates for both perfSONAR and third-party packages are released. 
  * Always follow best common security practices when it comes to creating user accounts and choosing passwords. Normal precautions should be taken to protect the root password as it can be used to make changes to the system. For example, safe password practices would recommend a password that contains a mixture of letters of different case, numbers, symbols, and a length greater than 8.  It is also not recommend to re-use passwords on multiple machines, in the event of a system breach.
  * If you have enabled SSH on the system, consider restricting access to specific subnets to the SSH port via IPTables, or implement a *jump host* that allows only logins from one location.  
  * Consider configuring rsyslog to send logs to other locations for aggregation and analysis
  * If email has been enabled on the host, forward email from root to a central location
  * If applicable, use a management network on a spare networking interface to further restrict the access profile for users and system data.  
  * If your site uses any form of automated management (CFEngine, Puppet, Forman, etc.), integrate the perfSONAR node into this procedure.  See `this resource <http://www.perfsonar.net/deploy/automated-management/>`_ for more information.  
  * If you run `Nagios <http://www.nagios.org>`_, add your perfSONAR host to your monitoring infrastructure. Consider running some of the nagios `security plugins <http://exchange.nagios.org/directory/Plugins/Security#/>`_ such as `check_yum <http://exchange.nagios.org/directory/Plugins/Operating-Systems/Linux/check_yum/details>`_
  * Automatic updates are enabled by default on all perfSONAR Toolkit hosts. In order to understand how to update your Toolkit and if automatic updates are right for your system, see :doc:`manage_update`
  
    .. note:: Automatic updates were enabled starting in perfSONAR Toolkit version 3.4. If you are running an older version then automatic updates are not enabled.
  * The perfSONAR Toolkit ships with a default iptables rule-set and intrusion detection system (IDS) software. In order to learn more about these components and how to do things like add custom firewall rules see :doc:`manage_security`

Those are just a few steps and there is always more than can be done. If you have access to system administrators leverage that resource and any other available. A little extra effort can prevent serious headaches later if your host falls victim to an attack.

Scheduling Regular Measurements
===============================
You will now want to schedule some tests that run on regular time intervals. There are two commonly used ways to add these tests and you may take one or both of these approaches depending on your needs:
 #. *Configure your tests via the web interface* - This approach can be used if you have a small number of perfSONAR nodes running a small number of tests. You will use the web interface to find and define tests. See :doc:`manage_regular_tests`.
 #. *Participate in a centrally managed mesh*  - This approach is best if you manage a large number of hosts or are participating in a large community of organizations running measurements. This requires updating a configuration file to point at a centrally managed file. See :doc:`multi_mesh_agent_config` for more details. 
 
What next?
==========
You should now have a fully configured host regularly collecting data. A few things you may consider exploring:

* Join the `user <https://lists.internet2.edu/sympa/subscribe/perfsonar-user>`_ or `announce <https://lists.internet2.edu/sympa/subscribe/perfsonar-announce>`_ mailing lists.  
* perfSONAR contains tools such as the Network Diagnostic Tester that are disabled by default. For information on enabling/disabling various tools see the section :doc:`manage_services`.
* Your regular tests record data that can be presented on graphs. To view the results on the toolkit provided graphs see the section :doc:`using_graphs`
* The perfSONAR Toolkit provides a number of on-demand testing tools you may be interested in exploring. More information can be found on the following pages:
    * :doc:`using_ndt`
    * :doc:`using_npad`
    * :doc:`using_ext_tools`

