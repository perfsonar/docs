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

Content Organization
====================

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
