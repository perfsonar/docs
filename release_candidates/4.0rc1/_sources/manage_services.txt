*****************
Managing Services
*****************


The perfSONAR Toolkit runs a number of *services*: applications constantly listening for requests to perform measurements, retrieve data and execute other tasks. This page details how and when to enable/disable services through the web interface.

List of Services
================
The following services may be managed through the web interface:

=================== =================== ==================================================================
Name                Default Enabled     Description
=================== =================== ==================================================================
Automatic Updates   Yes                 Controls *yum-cron* service that updates packages on the host nightly. See :doc:`manage_update` for more details.
BWCTL               Yes                 Controls *bwctl-server* service that allows clients at other sites to run throughput, traceroute and ping tests to your host. Also required if you plan to run regular tests of the aforementioned types on your host.
OWAMP               Yes                 Controls *owamp-server* service that allows clients at other sites to run one-way latency tests to this host. Also required to run regular one-way delay tests on your host.
NDT                 No                  Controls *ndt* service that allows clients to run on-demand diagnostic tests through a Java applet or command-line tool
NPAD                No                  Controls *npad* service that allows clients run diagnostic tests through a Java applet
=================== =================== ==================================================================

.. note:: Starting in 3.4, SSH was removed as a service from this listing.  To enable/disable SSHD, use *chkconfig*

.. note:: Starting in 3.5, NPAD support was removed. It is only listed if NPAD is installed.

Choosing Services to Enable
===========================
It is important to understand what services might impact other services. For example, if you run throughput tests (e.g. BWCTL + iperf3) and latency/loss tests (e.g. OWAMP ) on the same network interface, the throughput tests will possibly cause the host to drop packets. This may lead to a misleading interpretation of data if these events are not properly correlated. In general it is recommended you use the following guidelines when deciding which services to enable:

* BWCTL throughput and OWAMP tests **should** be run on separate hosts or interfaces (see :doc:`manage_dual_xface`) for best results that minimise risk of interference
* If the above is not possible, you **may** run them on the same host and interface, but be conscious that you will need to work diligently to rule out network performance issues caused by overlapping tests
* NDT and NPAD **should not** be run on hosts also running regular tests of any type. Their tests may interfere with regular tests and the administrator has less control over when they occur since they are run on-demand by an end-user.

.. seealso:: For a discussion on when to run Automatic Updates see :ref:`manage_update-auto`

Enabling/Disabling Services
===========================

#. Click on **Enable/disable services** in the main page *Services* section header. You may also click **Configure** in the the right-upper corner of the main page and then go to *Services* tab.

    .. image:: images/manage_services-enable1.png
#. Login using the web administrator username and password.

    .. seealso:: See :doc:`manage_users` for more details on creating a web administrator account
#. A list of services and a description of each is provided on the screen that loads. 

    .. image:: images/manage_services-enable2.png
#. Check the services you wish to enable and uncheck the services you wish to disable. Alternatively, you may use the *Select only bandwidth services* and *Select only latency services* to enable only tests related to throughput and one-way delay testing, respectively. Click **Save** to apply your changes

    .. image:: images/manage_services-enable3.png
#. After that you should see a green message indicating the services have been successfully restarted and the new configuration has been applied.

    .. image:: images/manage_services-enable4.png

.. note:: Starting in 3.4, you may also enable/disable any of the underlying services with the *chkconfig* command and the changes will be reflected in the GUI and maintained on reboot.

