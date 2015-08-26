*****************************
Central Logging Configuration
*****************************

Introduction
====================
Central logging is a useful tool for managing multiple systems. With central logging, one system acts as a server, and all other systems send their logs over the network to the central server for storage and analysis.

System Requirements
====================

**Operating System:**

  * Any linux system running either a 32-bit or 64-bit **CentOS 6** operating system should be able to follow the process outlined in this document. Other operating systems should work with similar configuration, but are untested at this time.

**Software:**
  * These examples use the rsyslog software included in CentOS 6 (version 5.8.10)

Configuration
=============

Example configuration files are available from the `perfSONAR Central Management project on Github`_

.. _perfSONAR Central Management project on Github: https://github.com/perfsonar/central-management/tree/master/syslog/rsyslog

The main rsyslog configuration file goes in ``/etc/rsyslog.conf``.  Additional files go in ``/etc/rsyslog.d/``.

Server
---------
Before you can configure the client, you must configure the server to receive logs from other systems over the network. `This example config file`_ is available.  
This should work without any changes, but you may wish to customize it. In this example, the server is configured to store its local logs locally and centrally along with those submitted by remote servers. If you wish to disable this, comment out or remove this line::

*.* @@127.0.0.1:514

.. _this example config file: https://raw.githubusercontent.com/perfsonar/central-management/master/syslog/rsyslog/server/rsyslog.conf



You also need to include one or two files in ``/etc/rsyslog.d``

* ``rsyslog-server.conf`` [`Download rsyslog-server.conf`_]

  * **Required.** Enables the server functionality

*  ``owamp_bwctl-syslog.conf`` [`Download owamp_bwctl-syslog.conf`_]

  * **Optional.** Normally installed when you install owamp or bwctl, so you may already have it.

.. _Download rsyslog-server.conf: https://raw.githubusercontent.com/perfsonar/central-management/master/syslog/rsyslog/server/rsyslog.d/rsyslog-server.conf
.. _Download owamp_bwctl-syslog.conf: https://raw.githubusercontent.com/perfsonar/central-management/master/syslog/rsyslog/server/rsyslog.d/owamp_bwctl-syslog.conf

Configure your server by editing ``/etc/rsyslog.d/rsyslog-server.conf``::

    # Provides TCP syslog reception
    $ModLoad imtcp.so  
    $InputTCPServerRun 514

    # Provides UDP syslog reception
    #$ModLoad imudp
    #$UDPServerRun 514

    # Log file name - hostname/programname
    $template FILENAME,"/var/log/central/%HOSTNAME%/%PROGRAMNAME%.log"

    # send all logs to FILENAME according to the above template
    *.* ?FILENAME

In the example configuration file, the server is set to listen on TCP port 514. Comment out or remove the TCP section if you don't want TCP enabled. Similarly, you may uncomment the UDP section to enable listening over UDP. TCP is more reliable, and is recommended. 

If you change the protocol/port the host is listening on, revise the host specifier line in ``/etc/rsyslog.conf`` to reflect this change. The number after the colon (:) is the port. For TCP, use @@ when specifying the host::

*.* @@127.0.0.1:514

For UDP, use @ when specifying the host::

*.* @127.0.0.1:514

In this example, the server will store all logs under ``/var/log/central/``. Change the filename template as desired.::

    # Log file name - hostname/programname
    $template FILENAME,"/var/log/central/%HOSTNAME%/%PROGRAMNAME%.log"

For more information read the `rsyslog documentation`_.

.. _rsyslog documentation: http://www.rsyslog.com/doc/v5-stable/configuration/templates.html

When you have finished configuring the server, run::
    sudo service rsyslog restart

If you are running a firewall, don't forget to open the appropriate port(s) accordingly.

Client
---------

Once the server is working, the clients need to be configured to send their syslogs to the central server. As with the server, we need an ``/etc/rsyslog.conf`` file. However, it should be slightly different as it needs to specify the hostname of the server where it should send its logs. An `example client rsyslog.conf file`_  is available here.

.. _example client rsyslog.conf file: https://raw.githubusercontent.com/perfsonar/central-management/master/syslog/rsyslog/client/rsyslog.conf

The only required modification is changing the rmote host specification::

    # FILL THIS IN:
    # remote host is: name/ip:port, e.g. 192.168.0.1:514, port optional
    *.* @@remote-host:514

Change ``remote-host`` to the hostname or IP address of your central syslog server. Use '@@' for a TCP connection, or '@' for a UDP connection. Specify the port after the colon.

The clients also need an ``/etc/rsyslog.d/owamp_bwctl-syslog.conf`` file. This is optional, but will improve bwctl/owamp logging. This is normally installed when you install owamp, but if you need it, an `example owamp_bwctl-syslog.conf file`_ is available.

.. _example owamp_bwctl-syslog.conf file: https://raw.githubusercontent.com/perfsonar/central-management/master/syslog/rsyslog/client/rsyslog.d/owamp_bwctl-syslog.conf

When you have finished configuring the client, run::
    sudo service rsyslog restart

Double check that the logs are being stored properly on the central server, if configured as in this example, the logs should be under ``/var/log/central/``.
