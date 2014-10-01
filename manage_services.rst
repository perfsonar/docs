*****************
Managing Services
*****************


The perfSONAR Toolkit runs a number of *services*, applications constantly listening for requests to perform measurements, retrieve data and execute other tasks. This page details how you may enable and disable services through the web interface.

Before enabling services, it is important to understand what services might impact other services. For example, if you run throughput tests 
(e.g.: bwctl + iperf3) and 
latency/loss tests (e.g.: owamp ) on the same NIC, the throughput tests will possibly cause the host to drop packets, greatly reducing perfSONARs 
ability to detect network problems. Also, NDT and NPAD should not be run on a Toolkit host doing regular testing, as those 
tests will also impact other results as well.  Therefore we recommend only one of the following be enabled at a time:

  * bwctl
  * owamp
  * NDT/NPAD

If you want to run all three, it's best to have three separate hosts.

However there are some excecptions to this. First, if you only use bwctl for running traceroute, tracepath, ping, owping, then you can run that at the same time as owamp. Second, if you have a :doc:`host with multiple interfaces <manage_dual_xface>`, and run owamp on one NIC, and bwctl on the other NIC, then its OK to enable both at the same time.

By default, the following services are enabled:

  * bwctl
  * owamp

If you wish to run NDT on your perfSONAR host, you must enable it, as described below.

Enabling/Disabling Services
===========================

#. Click on **Enabled Services** in the left-hand menu

    .. image:: images/manage_services-enable1.png
#. Login using the web administrator username and password.

    .. seealso:: See :doc:`manage_users` for more details on creating a web administrator account
#. A list of services and a description of each is provided on the screen that loads. Check the services you wish to enable and uncheck the services you wish to disable. Alternatively, you may use the *Only Enable Bandwith Services* and *Only Enable Latency Services* to enable only tests related to throughput and one-way delay testing, respectively. 

    .. image:: images/manage_services-enable2.png
#. Click **Save** to apply your changes
#. After a loading screen you should see a message indicating the services have been successfully restarted and the new configuration has been applied.

    .. image:: images/manage_services-enable3.png



