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
Each perfsonarUI plugin requires a perfSONAR service (Measurement Point or Measurement Archive) or endpoint (like *bwctl* or *owamp*) to be selected from the list of preconfigured services specific to that particular plugin (refer to section `Configuration Of the UI`_ -  for more information about configuring service list). Selecting desired service for querying is done via service selection dialog.

Selecting Service 
-----------------
In order to select a particular service, perform the following steps:

1. In the navigation panel, click **Access** section.
2. Select the type of measurements you want to access. The appropriate plugin window is displayed in the right part of the application window.
3. Click **Pick service** to select a Measurement Archive or click **Pick source/Pick destination** to select Measurement Point.
4. In the service selection dialog, configured services for that measurement type are shown sorted by name. The **Name** column also presents all Communities (in bold) associated with that particular host. If you wish to search for a certain service or group of services you can use filtering.

.. seealso:: See section `Filtering services`_ for more information on filtering.
5. Select one service by marking it and clicking the **Select** button, or by double-clicking on the item in the list.
  - Measurement Archive selection window
  
    .. image:: images/using_psui-4selecting_service1.png
  - Measurement Point selection window
  
    .. image:: images/using_psui-5selecting_service2.png
   
Filtering services
------------------
It is possible to filter the services list. For selection windows for **Pick service** or **Pick source/Pick destination** options there is a **Filter** input field above the list, which is used for quickly searching through all services. When the filter is used, it looks through all service attributes (Name, Group/Community, Type and Hostname), as you type, and shows only services that match the filter.

.. image:: images/using_psui-6filtering.png

Verifying Service Reachability
------------------------------
It is also possible to check if the service is reachable to the perfsonarUI and available for queries. In order to verify a particular service’s reachability perform the following steps:

1. In the service selection window click **Check all** button to verify all services from the list or verify just a single service by clicking the text **Unknown, click to test** displayed in the Status column for the desired service.
2. In both cases, if the service is reachable the status message will be *Available* with green dots to its right. If the service is not reachable, the dots will be red with the message *Unavailable*.
3. If a perfSONAR service is available, that information is cached for 60 minutes. When the service selection dialog is shown, this cached information is displayed when available.

.. note:: For some service types it is not possible to determine their availability. In that case the status message will be *Unable to test*.

Working With Measurements
=========================

Accessing Historical Measurements
---------------------------------
perfsonarUI currently supports the visualization of three types of historical measurements. These are link utilization data, one way delay, jitter, one-way packet loss and traceroute for a path and measured achievable throughput for a path. For each measurement type, there is a dedicated plugin within the **Access** section of the navigation panel. Each of the plugins will be described in more detail below.

Accessing Link Utilization Data 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. On the **Access** section of the navigation panle of the perfsonarUI you will see **Access utilization data** link. Click this item to bring up the link utilization plugin in the content panel on the right side of the application screen. This plugin is used to visualize data from the perfSONAR RRD MA and is also able to retrieve data from perfSONAR BUOY MA and the old perfSONAR Toolkit SNMP MA. Initially the page has content with no data:

  .. image:: images/using_psui-7historical_link_util1.png
  
  The plugin panel is divided into several segments. On the very top are controls for the selection of a measurement archive service to be queried (1) and for the type of values to be displayed in the results (utilization can be shown in bps or % of capacity). Next is a list of interfaces for which data is available in the measurement archive (2). Below that is a panel showing details of selected interfaces (3) and finally, the bottom part of the panel is reserved for the graph showing inbound and outbound link utilization for the selected time window (4).

2. Then it is necessary to select a measurement archive to query. This is achieved by clicking on the **Pick service** button in the top left corner, which brings up the service selection dialog.

  .. seealso:: See section `Selecting Service`_ for information on the service selection dialog.
3. When the service is selected, a request is sent to the measurement archive to fetch a list of all the interfaces for which available measurements exist within that archive. The archive’s response is converted into a list of available interfaces. This list can be filtered by name or description. To do this, the user simply clicks on the **Name** or **Description** labels in the list header and the labels turn into input fields.
4. Once a desired interface is located and selected by clicking in the list, a request is sent to the measurement archive to provide measurement values for that interface. When the archive responds, the data is presented to the user in the details panel and on the graph below it. The resulting screen may look similarly to:

  .. image:: images/using_psui-8historical_link_util2.png

  In the details panel interface name, description, address, domain and capacity are shown, alongside the status, maximum and average utilizations for each direction. The graph shows how the utilization changed over time in the selected time window. There are two elements on the graph. The green, filled area represents the inbound utilization while the blue line represents the outbound utilization. The graph provides the following functionalities:

  * Graph zooming: The graph can be zoomed in by clicking a mouse and dragging it to mark a selection area.
  * Comparison of link utilization in graph: It is possible to compare the utilization of two interfaces within the same time window. This is done by simply clicking on another interface from the list while there is already an active selection.

Accessing One-way Delay, Jitter, One-way Packet Loss And Traceroute Data 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This type of measurement data is stored within a perfSONAR HADES MA service. In order to retrieve it:

1. Click the **Access one way delay, jitter, loss and traceroute data** in the left navigation panel. Initially the page loads with no data:

  .. image:: images/using_psui-9historical_delay_initial.png
There is a service selection control located on top of the plugin panel (1). Once the desired MA service is selected, a request is sent to it to get all the available measurements from it. When the service responds with the available measurements, they are presented to the users in the measurement selection panel (2). When a soruce and destination points are selected, the measurement archive is queried for that particular measurement. The results from such a query are presented on a graph in the bottom part of the plugin panel (3). 
2. A click on the **Pick service** button opens a dialogue for service selection. Select the appropriate service.

  .. seealso:: See section `Selecting Service`_ for information on the service selection dialog.
3. The measurements provided by the HADES MA are measurements of parameters between two endpoints. When the service responds with the available measurements, then choose the required source point in the **From:** section (theis represents the endpoints where the measurements are originated from). Once a source point is selected, all the available destination endpoints become visible on the right side in the **To:** section of the panel. Click on the required destination endpoint.

  .. image:: images/using_psui-10historical_delay_selection.png
4. When a destination point is selected, the measurement archive is queried for that particular measurement. The results from such a query are presented on a graph in the bottom part of the plugin panel. 

  .. image:: images/using_psui-11historical_delay_results.png

The resulting graph has 3 segments. The first one shows *IPDV* (jitter). The second one shows *Delay*. Both of these segments show three sets of values, minimum, median and maximum. The third segment shows packet *Loss/duplicates* (values shown on the left side of the graph) as well as *Hopcount* for the route used (values shown on the right side of the graph). This graph can be zoomed to a particular segment.

The data set showing the hop count on the third graph segment (in green colour) is interactive. By clicking on it at a certain point in time, a route comparator panel becomes visible. On the left side of this panel, the route that was active at a point in time where the user clicked is shown. Individual hops are shown with their IP address and hostname. On the right side of the panel, a list of all the different routes that were active during the entire time window is shown. A user can compare one of these routes to the primary one (on the left) by clicking on it. The two routes are put side by side so that possible differences can be easily spotted. By clicking on the **<<** the user can go back to the list of all available routes and choose a different one for further comparison. A click on the **>>** closes the route comparator panel altogether.

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
