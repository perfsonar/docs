***************
Configuring NTP
***************

For perfSONAR tests to work correctly, it is critical that the Network Time Protocol (NTP) be configured properly. Almost all the measurements require an accurate system clock to calculate time-based metrics. Failure to have a synced clock can lead to unexpected results such as negative latency values. It is recommended to sync with **4-5 servers (not more)**, and that they all be fairly **close in proximity (less than 20ms RTT)**. The perfSONAR web interface provides a convenient way to configure NTP. It allows you to select time servers using the following methods:

#. By default the perfSONAR Toolkit will select the five closest known servers (perfSONAR ships with a known list of NTP servers). For details on refreshing this selection see :ref:`manage_ntp-closest`
#. You may also manually select servers from the list of known NTP servers as detailed in :ref:`manage_ntp-known`
#. Finally, you may manually define servers not in the default list as detailed in :ref:`manage_ntp-manual`

If your network can not connect to enough close servers, you'll want to identify some additional close NTP servers. Talk to your network administrator to see what NTP servers are typically used at your site, or look here for a nearby server: 
 *  http://support.ntp.org/bin/view/Servers/StratumOneTimeServers
 *  https://support.ntp.org/bin/view/Servers/StratumTwoTimeServers

.. note:: `www.pool.ntp.org <http://www.pool.ntp.org>`_ servers are not typically accurate enough for perfSONAR's requirements, and should be avoided.

.. _manage_ntp-access:

Accessing the NTP Interface
===========================
#. Open **http://<hostname>** in your browser where **<hostname>** is the name of your toolkit host
#. Click on *NTP* in the left-hand menu

    .. image:: images/manage_ntp-access.png
#. Login using the web administrator username and password.
    .. seealso:: See :doc:`manage_users` for more details on creating a web administrator account
#. The page that loads can be used to manage NTP. See the remainder of this document for details on using this interface.

        .. image:: images/manage_ntp-access2.png


.. _manage_ntp-closest:

Selecting the Closest Servers
=============================

#. On the main page of the NTP web interface, click **Select Closest Servers**

    .. image:: images/manage_ntp-closest1.png
#. After a loading screen you should see a green success message with the list of selected servers below it. Note that by default perfSONAR selects the closest servers so it is possible this list will remain unchanged.

    .. image:: images/manage_ntp-closest2.png
#. Click **Save** to apply your changes

.. _manage_ntp-known:

Manually Selecting a Known Server
=================================
#. On the main page of the NTP web interface, click **Manually Select Servers**

    .. image:: images/manage_ntp-known1.png
#. A rather long list of NTP servers loads. Select the servers you'd like to use with the checkbox next to the name.  Also, be sure to recall previously mentioned guidelines about good NTP server selection (4-5 servers less than 20ms RTT away).

    .. image:: images/manage_ntp-known2.png
#. Click **Save** to apply your changes

.. _manage_ntp-manual:

Manually Adding a Server
========================
#. On the main page of the NTP web interface, click **Add NTP server**

    .. image:: images/manage_ntp-add1.png
#. At the prompt enter the address and a human-readable description of the NTP server and click **OK**

    .. image:: images/manage_ntp-add2.png
#. You should see a success message and your NTP server in the list

    .. image:: images/manage_ntp-add3.png
#. Click **Save** to apply your changes

.. _manage_ntp-remove:

Deselecting a Server
====================
If you wish to deselect a server so that it remains in the known servers list but is not actively used to sync the clock then perform the following steps:

#. On the main page of the NTP web interface, click **Remove** next to the server you want to deselect

    .. image:: images/manage_ntp-deselect1.png
#. On the page that loads you should see a success message and that the list no longer contains your NTP server
#. Click **Save** to apply your changes

.. _manage_ntp-delete_known:

Deleting a Known Server
=======================
You may wish to permanently remove a server from the list of known servers. This removes it from consideration for closest server entirely and prevents accidental selection of the server by removing it from the list entirely. This task may be executed with the following steps:

#. On the main page of the NTP web interface, click **Manually Select Servers**

    .. image:: images/manage_ntp-known1.png
#. A rather long list of NTP servers loads. Click **Delete** next to the server you wish to remove from the list

    .. image:: images/manage_ntp-delete_known1.png
#. A success message should display indicating the server was deleted and it should no longer be in the list
#. Click **Save** to apply your changes

