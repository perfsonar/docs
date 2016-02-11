*******************************************
Configuring a Host with Multiple Interfaces
*******************************************

You may run the perfSONAR Toolkit on a host with multiple interfaces. The most common reason to do this is to run throughput and latency tests on separate physical interfaces to prevent interference between the test types. Additional configuration is required to ensure this type of testing works properly. You will need to do the following:

    #. Decide what IP addresses you are going to assign each interface. See :ref:`MultiXface_Addressing` for a discussion on choosing subnets and other relevant decision points.
    #. Setup routing rules that ensure when a source IP address is selected for a test, that  the operating system honors that IP address by sending it out the desired interface. A script is provided for this purpose and is detailed in the section :ref:`MultiXface_Route`
    #. When defining your tests either through the :doc:`configuration GUI <manage_regular_tests>` or :doc:`mesh configuration file <multi_mesh_server_config>`, you need to select the desired interface. See the individual pages for a description on how to make this selection.


.. _MultiXface_Addressing:

IP Addressing Strategy
======================
The first decision to be made is how you are going to address the interfaces on your hosts. It is **recommended** that you assign each interface to a different subnet. For example, you may give each interface a /30 with the other end being the gateway. This is not strictly required but considerably simplifies the networking involved and can make debugging easier. You should consult with your local network operators when making this determination.

If you do decide to put both interfaces on the same subnet, special *sysctl* settings are required to prevent ARP conflicts. These are set by default on the perfSONAR Toolkit but are documented below as reference::

    net.ipv4.conf.all.arp_ignore=1
    net.ipv4.conf.all.arp_announce=2
    net.ipv4.conf.default.arp_filter=1
    net.ipv4.conf.all.arp_filter=1


.. _MultiXface_Route:

Host Routing Table Configuration
================================

Adding Routes
-------------
When a regular test is run (or you run a measurement at the command-line using an option to specify the source address), the operating system may or may not use the provided source IP address when deciding which interface on the local host to use for forwarding. Most default routing tables only look at the destination address when making forwarding decisions which can lead to unexpected behavior with your measurements.

In order to avoid this situation, you need to run a special script to aid in route table setup that will look at the source address of your outgoing measurement traffic. The script can be found at */usr/lib/perfsonar/scripts/mod_interface_route*. For **each interface on the host** you will run the script and provide it with the interface name, IPv4 gateway address (if you plan to use IPv4) and the IPv6 gateway address (if you plan to use IPv6). Assume we have a host with two interfaces each having the following characteristics:
    
    * Interface 1
        :Interface Name: eth0
        :IPv4 Address:  10.0.0.2
        :IPv4 Gateway:  10.0.0.1
        :IPv6 Address:  fde1:40ff:e1a3:d50e::2
        :IPv6 Gateway:  fde1:40ff:e1a3:d50e::1
    
    *  Interface 2
        :Interface Name: eth1
        :IPv4 Address: 10.1.1.2
        :IPv4 Gateway: 10.1.1.1
        :IPv6 Address: fd7d:3189:ed46:2736::2
        :IPv6 Gateway: fd7d:3189:ed46:2736::1
    
    
Below is an example of the commands we would run to install the rules required to correctly use both interfaces for measurement traffic::

    /usr/lib/perfsonar/scripts/mod_interface_route --command add --device eth0 --ipv4_gateway 10.0.0.1 --ipv6_gateway fde1:40ff:e1a3:d50e::1
    /usr/lib/perfsonar/scripts/mod_interface_route --command add --device eth1 --ipv4_gateway 10.1.1.1 --ipv6_gateway fd7d:3189:ed46:2736::1

Replace the options above with those relevant to each interface on your host to create the necessary rules. 

After performing the task above, your routes should now be setup. There are two ways to enable the newly installed rules to persist between system reboots. One is to set the **mod_interface_route** command to run whenever the machine boots, and the other is to configure the **mod_interface_route** command to run whenever the interface is brought up or torn down.

The easiest approach is to have the routes setup when the machine boots. To do this, it is recommended that you add the *mod_interface_route* commands to **/etc/rc.local**. Copy them exactly as you ran them at the command-line and they should get executed each time your host starts. 

To have the routes setup whenever the interface is brought up, you will need to create two shell scripts: **/sbin/ifup-local** and **/sbin/ifdown-local**. The **/sbin/ifup-local** script gets executed whenever an interface is brought up, and will be used setup the route. The **/sbin/ifdown-local** script gets executed whenever an interface is brought down, and will be used to remove the route. Both scripts get executed with the interface name as the first parameter. The scripts then take the appropriate steps based on which interface is being taken up or torn down.

An example **/sbin/ifup-local** script based on the example interfaces above::

    #/bin/sh
    INTERFACE=$1

    if [ "$INTERFACE" == "eth0" ]; then
        /usr/lib/perfsonar/scripts/mod_interface_route --command add --device eth0 --ipv4_gateway 10.0.0.1 --ipv6_gateway fde1:40ff:e1a3:d50e::1
    elif [ "$INTERFACE" == "eth1" ]; then
        /usr/lib/perfsonar/scripts/mod_interface_route --command add --device eth1 --ipv4_gateway 10.1.1.1 --ipv6_gateway fd7d:3189:ed46:2736::1
    fi

An example **/sbin/ifdown-local** script based on the example interfaces above::

    #!/bin/sh

    INTERFACE=$1

    if [ "$INTERFACE" == "eth0" -o "$INTERFACE" == "eth1" ]; then
        /usr/lib/perfsonar/scripts/mod_interface_route  --command delete --device  $1
    fi

After you have created those scripts, make sure that they are executable by running **chmod ugo+x /sbin/ifup-local /sbin/ifdown-local**.

Viewing Routes
--------------
You may see the IPv4 changes by running the command ``ip rule list``::

    # ip rule list
    0:	from all lookup local 
    200:	from 10.0.0.2 lookup eth0_source_route 
    200:	from 10.1.1.2 lookup eth1_source_route 
    32766:	from all lookup main 
    32767:	from all lookup default 

You may see the IPv6 changes by running the command ``ip -6 rule list``::

    # ip -6 rule list
    0:	from all lookup local 
    200:	from fde1:40ff:e1a3:d50e::2 lookup eth0_source_route 
    200:	from fd7d:3189:ed46:2736::2 lookup eth1_source_route 
    32766:	from all lookup main 


Deleting Routes
---------------
If you would like to remove previously added rules and routes, simply give the *mod_interface_route* script the *delete* command and the device for which you want the rules removed. For example to remove both the rules from our previous example, run::
    
    /usr/lib/perfsonar/scripts/mod_interface_route --command delete --device eth0
    /usr/lib/perfsonar/scripts/scripts/mod_interface_route --command delete --device eth1


