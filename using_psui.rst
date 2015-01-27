**********************
perfsonarUI User Guide
**********************

Introduction
============
perfsonarUI is a web application for running and visualizing on-demand tests between perfSONAR measurement points (MPs) or visualizing historical measurement results obtained from perfSONAR measurement archives (MAs). It is designed to be intuitive and user friendly, thus allowing the network operator the troubleshoot network problems as efficiently as possible. The application functionality itself is realized through several plugins, one for each supported type of measurement. In the current version, perfsonarUI supports fetching stored interface utilization data, one-way delay data, jitter data, one-way packet loss data, hop count information data and achievable throughput data. This data is stored in perfSONAR MAs and represents results of regularly scheduled measurements which are performed automatically. The UI also offers the possibility of requesting an on-demand measurement of achievable throughput or one-way latency between two perfSONAR MPs. In the future other types of measurements will be added to the UI in the form of new plugin panels.
    .. image:: images/using_psui-1welcome.png
perfsonarUI also supports using historical data from multiple MAs to visualize path segment utilization for a given traceroute output.

The current release of perfsonarUI has been tested with the following perfSONAR components:

* perfSONAR Toolkit v 3.4.1
* BWCTL MP v 1.0
* RRD MA v 3.3.1-1
* SQL MA v 2.4
* HADES MA v 0.53
* OWAMP MP v 0.53
* simpleLookupService  

If a particular component version is not included in this document it may still be compatible with perfsonarUI but has not been tested. 

In addition perfsonarUI is also able to retrieve data from the old perfSONAR Toolkit, v3.3.1, SNMP MA and perfSONAR-BUOY MA. It is also able to make on-demand tests to *bwctl* endpoint such as perfSONAR Toolkit BWCTL and one-way latency measurement between a perfSONAR OWAMP MP and another *owamp* endpoint (such as perfSONAR Toolkit OWAMP endpoints).

Access To the Application
=========================
perfsonarUI is available through any modern web browser. We recommend using latest versions of Mozilla Firefox, Google Chrome, Safari and Opera. Accessing the application through Internet Explorer 9-11 is not tested, but should be operational. Accessing the application through Internet Explorer 8 is very limited – charts are not functional at all in IE8 and also there are several issues with style rendering such as element color, position, font type and size and more. For that reason accessing perfsonarUI through Internet Explorer versions 8, 7, 6 and lesser is not supported. To access your instance perform the following procedure:

1. Start your web browser
2. In the URL field of the browser, enter the IP address of the server running the instance of perfsonarUI. This will look similar to: *http://your_server_IP_address:8080/perfsonar-ui/*
3. Access to the application is secured. After the installation perfsonarUI is configured to use only embedded database for authentication. To login press **perfSONAR UI Login** button. When the login window displays enter default credentials. Default username is **admin** with the password **admin**.

Minimum recommended screen resolution is 1024x768 pixels.

.. note:: It is possible to change these credentials or add additional ones by modifying the */usr/share/perfsonar-ui-web/perfsonar-ui/WEB-INF/classes/usersdetails.xml* file. Each newly defined username should be in the role *ROLE_USER* since this is currently the only role supported by perfsonarUI. The *ROLE_USER* role allows full access to the application. A more sophisticated control over user roles and credentials will be implemented in future versions of the application. To produce MD5 hash of the desired password use an MD5 hash generator. You can do it easily on the Linux CLI with a command such as **echo -n "password" | md5sum**. After finishing changes in *usersdetails.xml* file you need to restart the Tomcat service.

Content Organization
====================
The application main window is organized in two main sections: time window selection with navigation on the left side of the screen and the plugin content panel on the right. Time window selection, located in the top left part of the screen, allows the user to select a common time window. This time window will be used when querying historical measurement data.

The start and the end of the time window can be selected manually by clicking on the corresponding input field and selecting date and time from a pop-up. It is also possible to select one of pre-defined time windows. These are (last) **hour**, (last) **6 hours**, (last) **day** and (last) **week**. Selection of these intervals is done by simply clicking the corresponding button in the bottom row. These intervals are relative to the current time, meaning that the end of the time window is set to current time and beginning is set according to the interval duration. Using the top row of buttons the user can shift the current time window backwards and forwards. Buttons **<<** and **>>** shift the time window backwards and forwards for its duration, while buttons **<** and **>** shift for half of time window duration.

.. image:: images/using_psui-2timeselection.png

The navigation panel is located below the time window selection and currently has three sections. The **Access** section is used for plugin selection, **Analyse** section is used for analysing traceroutes and cross-referencing them with perfSONAR measurements, while the **Settings** section is used to configure the UI itself.

.. image:: images/using_psui-3navipanel.png

perfSONAR Service Selection Panel 
=================================

Selecting Service 
-----------------

Verifying Service Reachability 
------------------------------

Working With Measurements
=========================

Accessing Historical Measurements 
---------------------------------

Accessing Link Utilization Data 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Accessing One-way Delay, Jitter, One-way Packet Loss And Traceroute Data 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Accessing Achievable Throughput data 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Making an On-demand Measurement 
-------------------------------

Make Available Throughput Measurement 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Make One-way Latency Measurement 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Perform a Traceroute Measurement 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Troubleshoot a Path 
-------------------

Configuration Of the UI 
=======================

Configuring Authentication With Identity Provider
=================================================
