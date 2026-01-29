******************************************
Importing Dashboards into Existing Grafana
******************************************
You can import preconfigured perfSONAR dashboards into your own Grafana instance from perfSONAR repository. perfSONAR provides a few default dashboards with visualizations of your data:

* perfSONAR Endpoint Pair Explorer - enables browsing perfSONAR test results between selected source and destination measurement hosts. The metrics include: throughput, latency, packet loss, jiter, rtt, traceroute hop count and unique results. Test results are presented in both directions.
* perfSONAR Host Metrics - presents overview of selected measurement host status. This includes the history of perfSONAR services status, basic host hardware and software information and settings, CPU, RAM and disk utilization, pScheduler and pSConfig metrics.

.. note:: Importing perfSONAR dashboards into existing Grafana may require additional dashboard's confguration to tailor it to your local environment.

Download perfSONAR Dashboard
============================

#. Open the following perfSONAR repository in your web browser:

    https://github.com/perfsonar/grafana/tree/master/perfsonar-grafana/perfsonar-grafana/dashboards/toolkit

#. Within the browser, click the selected JSON file.

#. On the selected JSON file view page, right-click the **Raw** button in the upper right-hand corner and  click **Save Link as...** which should allow you to save the .json file on your local machine.

Import a Dashboard
==================

To import a dashboard, follow these steps:

#. Login as priviledged user to your Grafana instance.

#. Click **Dashboards** in the menu.

#. Click **New** and select **Import** in the drop-down menu.

#. Perform one of the following steps:

    * Upload a previously downloaded dashboard JSON file.
    * Paste dashboard JSON text directly into the JSON model text area.

#. Change UID, if required.

#. Click **Load**.