***************
Configuring NTP
***************

For perfSONAR tests to work correctly, it is critical that the Network Time Protocol (NTP) be configured properly. Almost all the measurements require an accurate system clock to calculate time-based metrics. Failure to have a synced clock can lead to unexpected results such as negative latency values. It is recommended to sync with **4-5 servers (not more)**, and that they all be fairly **close in proximity (less than 20ms RTT)**. The perfSONAR web interface provides a convenient way to configure NTP. It allows you to select time servers using the following methods:

#. By default the perfSONAR Toolkit will select the five closest known servers (perfSONAR ships with a known list of NTP servers). For details on refreshing this selection see :ref:`manage_ntp-closest`.
#. You may also manually select servers from the list of known NTP servers as detailed in :ref:`manage_ntp-known`.
#. Finally, you may manually define servers not in the default list as detailed in :ref:`manage_ntp-manual`.

If your network can not connect to enough close servers, you'll want to identify some additional close NTP servers. Talk to your network administrator to see what NTP servers are typically used at your site, or look here for a nearby server: 
 *  http://support.ntp.org/bin/view/Servers/StratumOneTimeServers
 *  https://support.ntp.org/bin/view/Servers/StratumTwoTimeServers

.. note:: `www.pool.ntp.org <http://www.pool.ntp.org>`_ servers are not typically accurate enough for perfSONAR's requirements, and should be avoided.

More details on NTP can be found at :doc:`ntp_overview`.

.. _manage_ntp-access:

Accessing the NTP Interface
===========================
#. Open **http://<hostname>** in your browser where **<hostname>** is the name of your toolkit host.
#. Click on **Edit** (A) in the host information section of the main page or **Configuration** (B) button in the right-upper corner and login as the web administrator user created during installation.

    .. image:: images/manage_ntp-configure-icon.png

    .. seealso:: See :doc:`manage_users` for more details on creating a web administrator account.
#. In the page that loads select **Host** tab to access NTP configuration. Section **NTP Servers** in the page that loads can be used to manage NTP. See the remainder of this document for details on using this interface.

        .. image:: images/manage_ntp-overview.png

.. _manage_ntp-closest:

Selecting the Closest Servers
=============================
#. In order to refresh and select the closest NTP servers, go to the **NTP Servers** section and click **Select the closest servers**

    .. image:: images/manage_ntp-select-closest-wait.png
#. After a loading screen you should see a possibly new list of selected servers. Note that by default perfSONAR selects the closest servers so it is possible this list will remain unchanged.

#. Click **Save** to apply your changes. Green message appears to confirm successful configuration change.

.. _manage_ntp-known:

Manually Selecting a Known Server
=================================
#. In order to manually select a known NTP server available in a list of known servers, go to the **NTP Servers** section and click on the list of servers area.

    .. image:: images/manage_ntp-select-known-area.png
#. A list of NTP servers opens. Select the servers you'd like to use (highlighted in blue). Other servers already selected in a list are highlighted in grey. Use *Ctrl* and *Shift* keys to select multiple servers at once. Selected servers will immediately be added to the list. Also, be sure to recall previously mentioned guidelines about good NTP server selection (4-5 servers less than 20ms RTT away).

    .. image:: images/manage_ntp-select-known-list.png
#. Instead of selecting from the list of know servers you may simply click on the list of servers area and start writing the NTP server hostname or its description (A). Matching servers will automatically appear as available selections in the list below (B).

    .. image:: images/manage_ntp-select-known-write.png
#. Click **Save** to apply your changes. Green message appears to confirm successful configuration change.

.. _manage_ntp-manual:

Manually Adding a Server
========================
#. In order to manually add an NTP server not yet available in a list of known servers, go to the **NTP Servers** section, click **Manage available NTP servers**

    .. image:: images/manage_ntp-manage-area.png
#. In the windows that opens enter the address and a human-readable description of the NTP server and click **Add server**. 

    .. image:: images/manage_ntp-add-new-server.png
#. The new server is added to the list of known NTP servers. You may add more servers if needed. When finished click **OK** to accept the current list of NTP servers.

    .. image:: images/manage_ntp-add-new-server-added.png
#. The new NTP server is also automatically added to the list of currently used servers. Click **OK** to confirm your changes and **Save** to apply all changes to the system. Green message appears to confirm successful configuration change.

.. _manage_ntp-remove:

Deselecting a Server
====================
If you wish to deselect a server so that it remains in the known servers list but is not actively used to sync the clock then perform the following steps:

#. In the **NTP Servers** section, click **x** symbol next to the server you want to deselect. As a result the list no longer contains your NTP server.

    .. image:: images/manage_ntp-deselect-server.png
#. Click **Save** to apply your changes. Green message appears to confirm successful configuration change.

.. _manage_ntp-delete_known:

Deleting a Known Server
=======================
You may wish to permanently remove a server from the list of known servers. This removes it from consideration for closest server entirely and prevents accidental selection of the server by removing it from the list entirely. This task may be executed with the following steps:

#. In the **NTP Servers** section, click **Manage available NTP servers**

    .. image:: images/manage_ntp-manage-area.png
#. A list of NTP servers loads. Click **Delete x** next to the server you wish to remove from the list. As a result the list no longer contains your NTP server.

    .. image:: images/manage_ntp-delete-known-server.png
#. Click **OK** to accept changes and then **Save** to apply your changes to the system. Green message appears to confirm successful configuration change.

