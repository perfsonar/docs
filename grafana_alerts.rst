****************************
Creating Alerts with Grafana
****************************

    .. _grafana_alerts_main:

Introduction
============
Grafana Alerting allows you to eliminate the need for manual monitoring and provides an automatic way to be alerted on data. This short introcution will walk through general process of setting up the first alert on an example perfSONAR data. For detailed information refer to Grafana documentation available at https://grafana.com/docs/grafana/latest/.

Getting the Information About Current pSConfig Thresholds
=========================================================
tbd

Creating and Receiving Alerts
=============================
The simplest scenario includes two steps:

- Creating a contact point
- Setting up an alert rule

Creating a contact point
------------------------
In this step, we set up a new e-mail contact point to make sure notifications are sent to recipients. Follow these steps:

#. Login as priviledged user to your Grafana instance
#. Under **Alerting** section in the main menu click **Contact points**
#. Click **+ Create contact point**
#. Under **Name** enter a descriptive name for this contact point
#. Select **Email** from **Integration**
#. Use **Addresses** field to enter one or more e-mail addresses to send alert notifications to
#. Save configuration with **Save contact point** button

Setting Up an Alert Rule
------------------------
Now, we establish an alert rule to notify the user whenever alert rules are triggered. 
For more information about available fields see :ref:`grafana_alerts_os_fields`.

    .. _grafana_alerts_os_fields:

Example perfSONAR OpenSearch Fields
===================================
This section highlights some of the fields of perfSONAR data stored in OpenSearch. These fields can be used to define the query for alert configuration.