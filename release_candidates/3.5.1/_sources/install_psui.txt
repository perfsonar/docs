******************************
perfsonarUI Installation Guide
******************************

Introduction
============

The perfsonarUI web application enables users to visualize measurement results from perfSONAR services. It can provide insight into historical measurement stored in a 
perfSONAR Measurement Archive (MA), or request an on-demand measurement to be performed by a perfSONAR Measurement Point (MP). It provides the following functionalities:

* Access to link utilization data stored in a RRD Measurement Archive
* Access to one-way delay, jitter, one-way packet loss and traceroute data stored in a HADES Measurement Archive
* Access to historical achievable throughput data stored in a  SQL Measurement Archive
* Request an on-demand measurement to measure achievable throughput from a BWCTL Measurement Point

  .. image:: images/install_psui-01_overview.png

In order to visualize a measurement the client sends a request through the web browser. The UI web server creates a NMWG (Network Measurement Working Group) request and sends it to the MA or MP. When the MA or MP respond, measurement values are extracted from the response and sent to the web browser where they are presented to the client in numerical and graphical form.
perfsonarUI allows the user to browse several types of MA for available measurements. These are RRD MA, HADES MA and SQL MA. It also allows the user to request a measurement between two BWCTL MPs to be performed. In addition perfsonarUI is also able to retrieve data from the Internet2’s perfSONAR-PS SNMP MA and make on-demand tests to BWCTL endpoint such as Internet2’s perfSONAR-PS BWCTL.

Installation process
====================

Supported platform
------------------

The perfsonarUI packages are built for Red Hat Enterprise Linux 6 and Debian 7. No issues are expected for future minor versions.

Prerequisite software
---------------------

For the perfsonarUI to be able to work properly, you need to provide the following software:

#. Java version 7 - Oracle's Java and OpenJDK are tested and supported. Other flavors of Java are not tested but should work;
#. Apache Tomcat version 6 (for RedHat based systems) or version 7 (for Debian based systems). 

Debian and RHEL package systems are able to automatically satisfy perfsonarUI's dependency to Tomcat or Tomcat could be installed beforehand through default repositories.


Installing on Linux using repositotry
=====================================

Recommended way of installation of perfsonarUI is by adding the perfSONAR repositories and installing the package using native packaging system.

.. note:: It is recommended that you rely solely on the package dependencies to install the other required software.  Installing packages manually can result in incompatibility issues.

Adding the perfSONAR Repository
-------------------------------

PerfsonarUI packages are hosted in the regular perfSONAR repositories.

Adding the perfSONAR repository on a Debian system
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It is necessary to place a definition file in the ``/etc/apt/sources.list.d`` directory. You must have root access to this directory. To copy the repository source, run the following command:

	.. code-block:: console 

		# wget http://downloads.perfsonar.net/debian/perfsonar-wheezy-release.list

Use the following commands to add the repository’s PGP key:

	.. code-block:: console 

                # wget -qO - http://downloads.perfsonar.net/debian/perfsonar-wheezy-release.gpg.key | apt-key add -

Then clean and update the package list on your system using:

	.. code-block:: console 

	  	# apt-get clean
		# apt-get update

To check if the repository is correctly added run the following command:

	.. code-block:: console 

  		# apt-cache search perfsonar-ui-web

You should see the perfsonarUI web package listed.

Adding the perfSONAR repository on a Red Hat Enterprise Linux system
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It is necessary to add the Internet2-repo RPM with the following command (as root):

        .. code-block:: console 

                # rpm -hUv http://software.internet2.edu/rpms/el6/x86_64/main/RPMS/Internet2-repo-0.6-1.noarch.rpm

To check if the repository is correctly added run the following command

	.. code-block:: console 

  		# yum search perfsonar-ui-web

Now you should see the perfsonarUI web package.


Installation of packages
---------------------------

Installing perfsonarUI on RPM distributions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To install perfsonarUI in Red Hat and similar distributions perform the following procedure:

#. Log on as root to the machine on which you want to host the perfsonarUI.
#.	Install perfsonarUI using the package management system with the following command:
	
	.. code-block:: console 

  		yum install perfsonar-ui-web

Installing perfsonarUI on Debian distributions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To install perfsonarUI in Debian and similar distributions perform the following procedure:

#.	Log on as root to the machine on which you want to host the perfsonarUI.
#.	Install perfsonarUI using the package management system with the following command:
	
	.. code-block:: console 

  		apt-get install perfsonar-ui-web

Installing on Linux manually by downloading binary packages
===========================================================

Installation of perfsonarUI can be done by downloading binary package and installing it.

.. include:: psui_artifacts.rst

When you download the package you can install perfsonarUI using standard commands:
   
   * for RHEL-based systems type:

    .. code-block:: console 

    	# rpm -ihv perfsonar-ui-web-x.y.z.rpm 

   * for Debian based systems type:

    .. code-block:: console 

    	# dpkg -i perfsonar-ui-web_x.y.z_all.deb

.. note:: All prerequisite software must be installed before attempting manual installation!


Testing the installation
========================

To test if you have correctly installed the perfsonarUI open your browser and point your browser to following address:

    ::

        http://perfSONAR_UI_server_IP:8080/perfsonar-ui/

If the installation is correct you are asked to provide login credentials. 

.. seealso:: For more information about accessing the application see :ref:`psui_usage_access` chapter of Usage Guide.


Optional configuration
======================

.. _psui_installation_internal:

Configuring included list of services (global configuration)
------------------------------------------------------------

Global configuration, or global services list, of perfsonarUI is an included list of services (MA and MP) which are queried for historical or on-demand measurements. A default list is distributed with the perfsonarUI package and its content can be viewed through the UI (Settings > Configure Service List > Internal). This list can be edited or replaced with another by the user depending on his environment.
To modify the global list perform the following procedure:

#. Open ``/usr/share/perfsonar-ui-web/perfsonar-ui/WEB-INF/classes/endpoints.list`` with your favourite editor;
#. Remove, add or edit the lines. Each line in the file represents a single instance of perfSONAR service. The format of the line is:

		.. code-block :: none
			
			service_name#service_group#service_URL#service_type

	    .. glossary::

	        service_name
	            chosen name for the service instance

	        service_group
	            service community

	        service_URL
	            URL for this service instance

	        service_type
	            the type of the perfSONAR component
		
	**service_type** value should be one of the following (corresponding to the type of service):

		.. glossary::

			RRD_MA
				perfSONAR MDM RRD Measurement Archive or Internet2's perfSONAR-PS SNMP Measurement Archive
	        	
			HADES_MA
				perfSONAR MDM HADES Measurement Archive

			BWCTL_MA
				perfSONAR MDM SQL Measurement Archive

			BWCTL_MP
				perfSONAR MDM BWCTL Measurement Point

			OWAMP_MP
				perfSONAR MDM OWAMP Measurement Point

			BWCTL_PS
				Internet2's pSBuoy Measurement Archive with historical bandwidth data

			OWAMP_PS
				Internet2's pSBuoy Measurement Archive with historical latency data

			OWAMP
				non-perfSONAR MDM owamp endpoint

			BWCTL
				non-perfSONAR MDM bwctl endpoint

			TRACERT
				perfSONAR MDM trace route Measurement Point


	For example, a valid entry in the list representing a BWCTL MP called GEANT_Frankfurt would be:

	.. code-block :: none

		GEANT_Frankfurt#http://mp1.fra.de.geant2.net:8090/services/MP/BWCTL#BWCTL_MP

#. Restart Tomcat.

Customising the perfsonarUI logos
---------------------------------

There are 3 logos on the main page of perfsonarUI and can be replaced by your own logos. Left side navigation panel holds two logos: at the top and bottom of the panel. There is also a bigger main logo on the welcome screen. The location of the logos and corresponding names are depicted:

	.. image:: images/install_psui-02_logos.png

To upload own logos perform the following procedure:

	#. Prepare your own graphics and make sure they have the following properties:

	    * **logo_top**: 250x100 px, filename: ``logo_top.png``

	    * **logo_bottom**: 90x40 px, filename: ``logo_bottom.png``

	    * **logo_main**: 556x102 px, filename: ``logo_main.png``

	#. Navigate to ``/usr/share/perfsonar-ui-web/perfsonar-ui/images`` folder which contains the logo graphics;

	#. Remove the existing image file(s) for the logo to change;

	#. Upload the new image file(s);

	#. Restart Tomcat.

.. _psui_installation_plugins:

Enabling and disabling plugins
------------------------------

The perfsonarUI enables administrators to manage which plugins the application loads. To modify the visibility of plugins perform the following procedure:

#. Navigate to ``/usr/share/perfsonar-ui-web/perfsonar-ui/WEB-INF/classes`` folder which contains the file plugins.list.
#. Each line is the plugin property in the form of

	::

		plugin_key={ENABLE | DISABLE}.

#. **plugin_key** is the name of the plugin to configure corresponding to perfSONAR functionalities and data and can be one of the following: **analyse, rrd_ma, hades_ma, bwctl_ma, bwctl_mp, owamp_mp, owamp_ma, traceroute**. For example **bwctl_mp** is the property for the plugin that makes on demand throughput tests with the use of **BWCTL MP** component. **ENABLE** or **DISABLE** specify whether to enable or disable the plugin named in the configuration file.

	.. note:: By default all the possible plugin properties are provided, and only the **OWAMP MA** and **Traceroute** are disabled (these features are not completed yet). 
#. If, for any reason, the configuration file is missing, or the values inside it are not valid for the perfsonarUI to parse all the plugins will be visible.
#. Restart Tomcat.

Logging and usage statistics
============================

Log files
---------

After perfsonarUI installation, all user actions are logged inside the ``/var/log/perfsonar-ui/ui_usage.log`` file.  And errors are logged to ``/var/log/perfsonar-ui/ui_error.log``.

A log line in **ui_usage.log** has the following format:

::
	
	01/Sep/2013:00:09:14 session_id user_ip "user_action" "action_parameters" result_status request_time

Usage statistics
----------------

The perfsonarUI installation provides you with a script that analyses the ``ui_usage.log`` file and output interesting statistics about the perfsonarUI usage.  The script is ``/usr/bin/psui-usage-report.pl`` and it output statistics in two different formats: human readable text and **CSV** file for further processing in a spreadsheet.

The statistics produced include:

	* counts of the types of actions performed by the users
	* counts of the services types queried by the users
	* the list of clients using the perfsonarUI
	* some useful totals about usage

More information is provided as part of the script if you run it with the **-help** or **-man** options.

Prerequisite
------------

The analysis script has a prerequisite to its installation - it needs to have access to the Net::Whois:RIPE perl library in version 2 or above. There is no package available for this library on Debian nor on RHEL. The easiest way to install it is to use cpan with the following command (to be run with root privileges):

	.. code-block:: console 

		# cpan -i Net::Whois::RIPE
