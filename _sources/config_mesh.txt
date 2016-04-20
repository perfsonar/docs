********************************
Mesh Configuration (.conf) file
********************************

Overview
========

The perfSONAR MeshConfig software allows an administrator to generate a central file that defines measurements for a set of hosts that read the published file. The file is defined by the administrator in Apache config format. This document covers this format and the complete listing of options available.

Each configuration file consists of the following elements:

* A list of **description** providing a human-readable string that names your mesh. See :ref:`config_mesh-description` for details on defining this element.
* A list of **administrators** responsible for the configuration file. See :ref:`config_mesh-administrator` for details on defining this element.
* A list of *organizations* including the **sites** and **hosts** that they contain. See :ref:`config_mesh-organization` for details on defining this element.
* A list of **test specification** that describe the parameters of the tests to be run. See :ref:`config_mesh-test_spec` for details on defining this element.
* A list of **groups** the describe the topology of tests and the hosts they contain. See :ref:`config_mesh-group` for details on defining this element.
* A list of **tests** that connect the previously defined *test specifications* and *groups*. See :ref:`config_mesh-test` for details on defining this element.
* An optional set of **host classes** that allow for dynamic joining of tests to groups. See :ref:`config_mesh-host_class` for details on defining this element.


Naming
======

.. _config_mesh-description:

description Directive
----------------------
:Description: A human-readable name for the parent directive
:Syntax: ``description TEXT GOES HERE``
:Contexts: top level, :ref:`organization <config_mesh-organization>`, :ref:`site <config_mesh-site>`, :ref:`host <config_mesh-host>`, :ref:`host <config_mesh-test>`
:Occurrences:  Exactly one per parent
:Compatibility: 3.3 and later

The description is a human-readable name applied for the parent element. It is primarily relevant to 
GUIs for display purposes. For example, MaDDash configurations uses this field as the title of the created dashboard in the top-level context. Likewise it uses this field as the name displayed for each host in the rows and columns of a grid in the :ref:`host <config_mesh-host>` context.  


Grouping
=========

.. _config_mesh-organization:

<organization> Directive
------------------------
:Description: An optional construct that groups together sites and hosts by the organization to which they belong
:Syntax: ``<organization>...</organization>``
:Contexts: top level
:Occurrences:  Zero or more
:Compatibility: 3.3 and later

The <organization> directive is strictly of purposes of grouping elements managed by the same entity together. In addition to keeping :ref:`sites <config_mesh-site>` and :ref:`hosts <config_mesh-host>` in a logical order, the description field can also be matched on when defining :ref:`host classes <config_mesh-host_class>`.


.. _config_mesh-site:

<site> Directive
----------------
:Description: An optional construct that groups an organization's hosts together, generally based on location
:Syntax: ``<site>...</site>``
:Contexts: :ref:`organization <config_mesh-organization>`
:Occurrences:  Zero or more
:Compatibility: 3.3 and later

A site can group hosts within an organization together. For example, if an organization has multiple campuses with two hosts deployed at each, then the site directive can be used to group the hosts at each campus. This example is illustrate below::

    <site>
        description Site 1
        <host>...</host>
        <host>...</host>
    </site>

    <site>
        description Site 2
        <host>...</host>
        <host>...</host>
    </site>

The <site> may have additional significance for tools that display data. For example, a MaDDash configuration can plot data on the same graph for hosts belonging to the same site. This is especially useful when different types of measurement data are spread across multiple hosts, such as throughput and one-way delay data. 


Hosts
=====

.. _config_mesh-host:

<host> Directive
----------------
:Description: Describes a host that will be used as an endpoint in measurements
:Syntax: ``<host>...</host>``
:Contexts: top level, :ref:`organization <config_mesh-organization>`, :ref:`site <config_mesh-site>`
:Occurrences:  Zero or more
:Compatibility: 3.3 and later

The host object is a critical part of your mesh configuration. You may define a host object at the top level of the file or within an organization or site. The latter two options simply provide more metadata about the host that can be used for documentation purposes or for :ref:`hos class <config_mesh-host_class>` matches. Inside the construct you will define all the addresses which may be used for performing network measurements to/from this host as well as some additional metadata.

.. _config_mesh-host-no_agent:

no_agent Directive
-------------------------------
:Description: A boolean indicating that his host does NOT read the mesh
:Syntax: ``no_agent 0|1``
:Default: 0
:Contexts: :ref:`host <config_mesh-host>`
:Occurrences:  Zero or One
:Compatibility: 3.3 and later

If set to 1, this value indicates that the host in question is not reading the mesh. This is significant because it means those that test to it are responsible for initiating tests in both directions and storing the results. The default is 0 meaning other testers can assume this host is reading the mesh and will initiate its portion of the tests accordingly. 

.. _config_mesh-host-toolkit_url:

toolkit_url Directive
-------------------------------
:Description: A URL to the host's perfSONAR Toolkit instance or other related web site
:Syntax: ``toolkit_url URL``
:Contexts: :ref:`host <config_mesh-host>`
:Occurrences:  Zero or One
:Compatibility: 3.3 and later

This option is for graphical displays that wish to provide a link to more information about the host. traditionally this is a link to the perfSONAR Toolkit, but may in practice be any valid URL.

.. _config_mesh-address:

<address> Directive
--------------------
:Description: An IPv4 address, IPv6 address, or hostname belonging to a host
:Syntax: ``address ADDRESS`` or ``<address>...</address>``
:Default: 0
:Contexts: :ref:`host <config_mesh-host>`
:Occurrences:  One or more
:Compatibility: 3.3 or later for simple form, 3.5 and later for complex form

An address is a required element of a host that defines an IPv4address , IPv6 address or hostname assigned to an interface on the host. You can and likely will define multiple of these for a single a host. If using a hostname it is not required to also define theIP addresses to which the hostname maps as the tools will do the look-ups automatically. 

You can define address in one of two forms. In the simple form you simply provide the address. Example::

    address 10.0.1.1
    
In the complex form you make it a block and can optionally add the *tags* field to label the address. Tags are used when defining a :ref:`host class <config_mesh-host_class>`. Example::

    <address>
        address 10.0.1.1
        tag latency
    </address>

address Directive
-------------------------------
:Description: In the complex form of <address>, a simple string representation of the IPv4, IPv6 address or hostname
:Syntax: ``address ADDRESS``
:Contexts: :ref:`address <config_mesh-address>`
:Occurrences:  Zero or One
:Compatibility: 3.3 and later

Storing Results
===============

.. _config_mesh-ma:

<measurement_archive> Directive
--------------------------------
:Description: Defines where measurement results are stored
:Syntax: ``<measurement_archive>...</measurement_archive>``
:Contexts: top level, :ref:`organization <config_mesh-organization>`, :ref:`site <config_mesh-site>`, :ref:`host <config_mesh-host>`
:Occurrences:  One per <measurement_archive> type
:Compatibility: 3.3 or later

The <measurement_archive> defines where measurements of a certain type are stored. Depending on where it is placed in the document it can have the following semantics:

* If placed in the <host> directive, then all measurements initiated by that host(and matching the measurement archive type) will be stored in the provided MA
* If placed in the <site> directive, all measurements initiated by hosts defined in the site will use the provided measurement archive UNLESS a <measurement_archive> is defined in the <host> directive.
* If placed in the <organization> directive, all measurements initiated by hosts defined in the organization will use the provided measurement archive UNLESS a <measurement_archive> is defined in the <site> directive OR the <host> directive (with <host> given preference).
* If placed in the top level, then all hosts will use the defined <measurement_archive> UNLESS there is <measurement_archive> defined in the <host>, <site>, or <organization> (with preference given in that order). 

type Directive
--------------
:Description: The type of measurement archive
:Syntax: ``type perfsonarbuoy/bwctl|perfsonarbuoy/owamp|pinger|traceroute``
:Contexts: :ref:`measurement archive <config_mesh-ma>`
:Occurrences:  Exactly one
:Compatibility: 3.3 and later

This specifies the type of data to be stored. The supported values refer to an older version of the perfSONAR software where different data types were stored in different archives. Even if the data ultimately ends up in the same archive you need to define multiple <measurement_archive> directives for each type of data you plan to store. The types have the following meanings:

* **perfsonarbuoy/bwctl** - Throughput tests such as those initated by BWCTL running iperf or iperf3
* **perfsonarbuoy/owamp** - OWAMP tests initiated by the powstream tool
* **pinger** - Ping tests initiated by bwping or OWAMP tests initiated by bwping running OWAMP
* **traceroute** - Any type of test initiated by bwtraceroute

read_url Directive
------------------
:Description: The URL where tools should query for results
:Syntax: ``read_url URL``
:Contexts: :ref:`measurement archive <config_mesh-ma>`
:Occurrences:  Exactly one
:Compatibility: 3.3 and later

This is the URL where tools, such as a MaDDash dashboard, will query for test results. In general, this value will be the same as the write_url if running the perfSONAR Toolkit 3.4 or newer. You may want it to be a different value if your server uses a different public address than it uses to store data, such as in a NAT environment.  


write_url Directive
--------------------
:Description: The URL where tools should send results to store
:Syntax: ``write_url URL``
:Contexts: :ref:`measurement archive <config_mesh-ma>`
:Occurrences:  Exactly one
:Compatibility: 3.3, ignored in 3.4, supported again in 3.5 or later

This is the URL where tools, such as regular-testing on the perfSONAR Toolkit, should send results. This value is only useful if your measurement archive is using IP authentication. if using API key authentication, you will need to define the measurement archive in your local regulartesting.conf file. This is because it is not safe for the MeshConfig to share login credentials in it's current form and would be difficult to manage in a large mesh. 

Defining Test Parameters
========================

.. _config_mesh-test_spec:

<test_spec> Directive
---------------------
:Description: The parameters to use when running a test that uses this specification. The NAME tag is used to reference the test_spec elsewhere in the configuration.
:Syntax: ``<test_spec NAME>...</test_spec>``
:Contexts: top level
:Occurrences:  Zero or more
:Compatibility: 3.3 or later

The <test_spec> defines the parameters used when running a test. Every test_spec has a *type* directive that indicates what kind of test is to be run. A set of directives are available for each type that are then used to further refine the parameters of the tests that use this specification.

type Directive
--------------
:Description: The type of test to be run for tests using this specification
:Syntax: ``type perfsonarbuoy/bwctl|perfsonarbuoy/owamp|pinger|traceroute``
:Contexts: :ref:`test_spec <config_mesh-test_spec>`
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

The types have the following meanings:

* **perfsonarbuoy/bwctl** - Throughput tests such as those initated by BWCTL running iperf or iperf3. See :ref:`config_mesh-test_spec-throughput` for directives specific to this type of test.
* **perfsonarbuoy/owamp** - OWAMP tests initiated by the powstream tool. See :ref:`config_mesh-test_spec-owamp` for directives specific to this type of test.
* **pinger** - Ping tests initiated by bwping or OWAMP tests initiated by bwping running OWAMP. See :ref:`config_mesh-test_spec-ping` for directives specific to this type of test.
* **traceroute** - Any type of test initiated by bwtraceroute. See :ref:`config_mesh-test_spec-traceroute` for directives specific to this type of test.

.. _config_mesh-test_spec-throughput:

Defining Throughput Test Parameters
===================================

tool Directive
--------------
:Description: The tool to use in performing the throughput test
:Syntax: ``tool iperf|iperf3``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl*
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

duration Directive
-------------------
:Description: The length to run each throughput test in seconds
:Syntax: ``duration SECONDS``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl*
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

interval Directive
-------------------
:Description: The time in between throughput tests in seconds
:Syntax: ``interval SECONDS``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl*
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

buffer_length Directive
-----------------------
:Description: Length of read and write buffers
:Syntax: ``buffer_length NUMBER``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl*
:Occurrences:  Zero or one
:Default: system default
:Compatibility: 3.3 or later

force_bidirectional Directive
-----------------------------
:Description: Forces each endpoint to initiate the test in both directions. This will lead to redundant tests being run on each side. 
:Syntax: ``force_bidirectional 0|1``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl*
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 or later

ipv4_only Directive
-------------------
:Description: Forces each side to use IPv4. Test will fail if no IPv4 address can be determined for either endpoint
:Syntax: ``ipv4_only 0|1``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl*
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 or later

ipv6_only Directive
-------------------
:Description: Forces each side to use IPv6. Test will fail if no IPv6 address can be determined for either endpoint
:Syntax: ``ipv6_only 0|1``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl*
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 or later

latest_time Directive
---------------------
:Description: The delay in seconds after the test is requested that it is allowed to start. This may be useful on busy hosts where a test cannot be scheduled until further in the future than the default allows.
:Syntax: ``latest_time seconds``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl*
:Occurrences:  Zero or one
:Default: 50% of the interval OR the difference between the interval and duration (whichever is smaller)
:Compatibility: 3.3 or later

omit_interval Directive
-------------------------
:Description: The time to ignore results at the beginning of a test in seconds. Useful for excluding TCP ramp-up time. Note that this is added to the duration (e.g. omit_interval of 5 and duration 30 leads to a 35 second test).
:Syntax: ``omit_interval SECONDS``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl* and protcol is *tcp* and tool is *iperf3*
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 or later

protocol Directive
------------------
:Description: The transport protocol to use for the test. May be tcp or udp.
:Syntax: ``protocol tcp|udp``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl*
:Occurrences:  Zero or one
:Default: tcp
:Compatibility: 3.3 or later

random_start_percentage Directive
---------------------------------
:Description: The percentage to randomize the start time of requests. Valid values are between 0 and 50 (inclusive). Example: interval of 7200 (2 hours) and random_start_percentage 50 means that a test can start anywhere between 1 hour and 3 hours after the previous test completes.
:Syntax: ``random_start_percentage PERCENTAGE``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl*
:Occurrences:  Zero or one
:Default: 10
:Compatibility: 3.3 or later

report_interval Directive
-------------------------
:Description: The sub-interval at which to report results in seconds.
:Syntax: ``report_interval SECONDS``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl*
:Occurrences:  Zero or one
:Default: 1
:Compatibility: 3.3 or later

streams Directive
-----------------
:Description: The number of parallel streams to use in the test
:Syntax: ``streams NUMBER``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl*
:Occurrences:  Zero or one
:Default: 1
:Compatibility: 3.3 or later

tos_bits Directive
------------------
:Description: The type of service to set in the IP header of outgoing packets
:Syntax: ``tos_bits NUMBER``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl*
:Occurrences:  Zero or one
:Default: not set
:Compatibility: 3.3 or later

udp_bandwidth Directive
-------------------------
:Description: The rate at which the tool will attempt to send UDP packets in bits per second.  
:Syntax: ``udp_bandwidth NUMBER``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl* and protcol is *udp*
:Occurrences:  Zero or one
:Default: 1Mbps if a udp protocol set, n/a otherwise
:Compatibility: 3.3 or later

window_size Directive
-------------------------
:Description: TCP window size (bytes) 0 indicates system defaults
:Syntax: ``window_size NUMBYTES``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/bwctl* and protcol is *tcp*
:Occurrences:  Zero or one
:Default: 0 (i.e. use endpoint host default)
:Compatibility: 3.3 or later

.. _config_mesh-test_spec-owamp:

Defining Streaming One-way Delay Test Parameters
================================================

bucket_width Directive
-------------------------
:Description: The bin size for histogram calculations in terms of seconds. For example a value such as .001 means all histogram bins will be in milliseconds.
:Syntax: ``bucket_width VALUE``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/owamp*
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

packet_interval Directive
-------------------------
:Description: The mean average time between packets in seconds. For example, .1 means send 10 packets per second. 
:Syntax: ``packet_interval SECONDS``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/owamp*
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

sample_count Directive
-------------------------
:Description: The number of packets contained in each summary. This combined with packet_interval determines how often data is stored. For example, a packet_interval of .1 (10 packets per second) and sample_count of 600 stores a result every 60 seconds.
:Syntax: ``sample_count NUMBER``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/owamp*
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

force_bidirectional Directive
-----------------------------
:Description: Forces each endpoint to initiate the test in both directions. This will lead to redundant tests being run on each side. 
:Syntax: ``force_bidirectional 0|1``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/owamp*
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 or later

ipv4_only Directive
-------------------
:Description: Forces each side to use IPv4. Test will fail if no IPv4 address can be determined for either endpoint
:Syntax: ``ipv4_only 0|1``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/owamp*
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 or later

ipv6_only Directive
-------------------
:Description: Forces each side to use IPv6. Test will fail if no IPv6 address can be determined for either endpoint
:Syntax: ``ipv6_only 0|1``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/owamp*
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 or later

packet_padding Directive
-------------------------
:Description: The size of the padding added to each packet in bytes
:Syntax: ``packet_padding BYTES``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/owamp*
:Occurrences:  Zero or more
:Default: 0
:Compatibility: 3.3 or later

loss_threshold Directive
------------------------
:Description: **DEPRECATED IN 3.4** This option will not cause an error but will be ignored in MeshConfig software later than 3.4.
:Syntax: ``loss_threshold SECONDS``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/owamp*
:Occurrences:  Exactly one
:Compatibility: Deprecated in 3.4.

session_count Directive
-----------------------
:Description: **DEPRECATED IN 3.4** This option will not cause an error but will be ignored in MeshConfig software later than 3.4.
:Syntax: ``session_count NUMBER``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *perfsonarbuoy/owamp*
:Occurrences:  Exactly one
:Compatibility: Deprecated in 3.4.


.. _config_mesh-test_spec-ping:

Defining Ping Test Parameters
==============================================

test_interval Directive
------------------------
:Description: The time in between ping tests in seconds
:Syntax: ``test_interval SECONDS``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *pinger*
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

force_bidirectional Directive
-----------------------------
:Description: Forces each endpoint to initiate the test in both directions. This will lead to redundant tests being run on each side. 
:Syntax: ``force_bidirectional 0|1``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *pinger*
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 or later

ipv4_only Directive
-------------------
:Description: Forces each side to use IPv4. Test will fail if no IPv4 address can be determined for either endpoint
:Syntax: ``ipv4_only 0|1``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *pinger*
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 or later

ipv6_only Directive
-------------------
:Description: Forces each side to use IPv6. Test will fail if no IPv6 address can be determined for either endpoint
:Syntax: ``ipv6_only 0|1``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *pinger*
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 or later

packet_count Directive
----------------------
:Description: The number of packets to send per test. This multiplied by packet_interval is the duration of the test.
:Syntax: ``packet_count NUMBER``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *pinger*
:Occurrences:  Zero or One
:Default: 10
:Compatibility: 3.3 or later

packet_interval Directive
-------------------------
:Description: The average time between packets. A decimal value less than one means to send multiple packets per second (e.g. .1 means 10 packets per second). This multiplied by packet_count is the duration of the test.
:Syntax: ``packet_interval SECONDS``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *pinger*
:Occurrences:  Zero or One
:Default: 10
:Compatibility: 3.3 or later

packet_size Directive
----------------------
:Description: The size of packets in bytes.
:Syntax: ``packet_size BYTES``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *pinger*
:Occurrences:  Zero or One
:Default: Tool default
:Compatibility: 3.3 or later

packet_ttl Directive
----------------------
:Description: The TTL to set in the IP header of outgoing packets
:Syntax: ``packet_ttl TTL``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *pinger*
:Occurrences:  Zero or One
:Default: System default
:Compatibility: 3.3 or later

random_start_percentage Directive
---------------------------------
:Description: The percentage to randomize the start time of test. Valid values are between 0 and 50 (inclusive). Example: interval of 7200 (2 hours) and random_start_percentage 50 means that a test can start anywhere between 1 hour and 3 hours after the previous test completes.
:Syntax: ``random_start_percentage PERCENTAGE``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *pinger*
:Occurrences:  Zero or one
:Default: 10
:Compatibility: 3.3 or later

.. _config_mesh-test_spec-traceroute:

Defining Traceroute Parameters
==============================

test_interval Directive
------------------------
:Description: The time in between traceroute tests in seconds
:Syntax: ``test_interval SECONDS``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *traceroute*
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

first_ttl Directive
-------------------
:Description: The first hop to look at starting at 1. This can be used to hide local routers. **Not supported by tracepath or paris-traceroute**
:Syntax: ``first_ttl TTL``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *traceroute* and tool is *traceroute*
:Occurrences:  Zero or more
:Default: 1
:Compatibility: 3.3 or later

force_bidirectional Directive
-----------------------------
:Description: Forces each endpoint to initiate the test in both directions. This will lead to redundant tests being run on each side. 
:Syntax: ``force_bidirectional 0|1``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *traceroute*
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 or later

ipv4_only Directive
-------------------
:Description: Forces each side to use IPv4. Test will fail if no IPv4 address can be determined for either endpoint
:Syntax: ``ipv4_only 0|1``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *traceroute*
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 or later

ipv6_only Directive
-------------------
:Description: Forces each side to use IPv6. Test will fail if no IPv6 address can be determined for either endpoint
:Syntax: ``ipv6_only 0|1``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *traceroute*
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 or later

packet_size Directive
------------------------
:Description: The size of packets to send in bytes when performing the traceroute. **Not supported by tracepath or paris-traceroute**
:Syntax: ``packet_size BYTES``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *traceroute* and tool is *tarceroute*
:Occurrences:  Zero or one
:Default: Tool default
:Compatibility: 3.3 or later

timeout Directive
-----------------
:Description: The maximum amount of time to wait in seconds for the traceroute to complete
:Syntax: ``timeout SECONDS``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *traceroute*
:Occurrences:  Zero or one
:Default: 10
:Compatibility: 3.3 or later

tool Directive
--------------
:Description: The tool to use to perform the traceroute.
:Syntax: ``tool traceroute|tracepath|paris-traceroute``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *traceroute*
:Occurrences:  Zero or more
:Default: traceroute
:Compatibility: 3.3 or later

You can specify on of the following tools for a traceroute test:

* **traceroute** - This is the default and generally the more reliable of the tools. It also includes more options in terms of setting the TTL and properly binding to interfaces.
* **tracepath** - The main advantage of this tool is it reports MTU by default. It has  fewer options than standard traceroute for setting TTLs and binding to local interfaces. It also is UDP-only and may be blocked by firewalls. It's also been reported to have a harder time with MTU mismatches on the destination host. 
* **paris-traceroute** - This is another approach to running traceroute that tries to identify load balanced routes and similar. It requires the client to grant the paris-traceroute command the CAP_NET_RAW privilege on the system in order to run as a non-root user. 


max_ttl Directive
-----------------
:Description: The maximum number of hops before a traceroute fails. **Not supported by tracepath or paris-traceroute**
:Syntax: ``max_ttl TTL``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *traceroute* and tool is *traceroute*
:Occurrences:  Zero or more
:Default: traceroute default (usually 30)
:Compatibility: 3.3 or later

protocol Directive
------------------
:Description: Indicates whether to use ICMP or UDP for the traceroute. **Not supported by tracepath or paris-traceroute**
:Syntax: ``protocol icmp|udp``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *traceroute* and tool is *traceroute*
:Occurrences:  Zero or more
:Default: icmp
:Compatibility: 3.3 or later

random_start_percentage Directive
---------------------------------
:Description: The percentage to randomize the start time of test. Valid values are between 0 and 50 (inclusive). Example: interval of 7200 (2 hours) and random_start_percentage 50 means that a test can start anywhere between 1 hour and 3 hours after the previous test completes.
:Syntax: ``random_start_percentage PERCENTAGE``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *traceroute*
:Occurrences:  Zero or one
:Default: 10
:Compatibility: 3.3 or later

pause Directive
---------------------------------
:Description: **DEPRECATED IN 3.4** This option will not cause an error but will be ignored in MeshConfig software later than 3.4
:Syntax: ``pause SECONDS``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *traceroute*
:Occurrences:  Zero or one
:Default: Underlying tool default
:Compatibility: Deprecated in 3.4.

waittime Directive
---------------------------------
:Description: **DEPRECATED IN 3.4** This option will not cause an error but will be ignored in MeshConfig software later than 3.4
:Syntax: ``waittime SECONDS``
:Contexts: :ref:`test_spec <config_mesh-test_spec>` where type is *traceroute*
:Occurrences:  Zero or one
:Default: Underlying tool default
:Compatibility: Deprecated in 3.4.

Defining Test Topology
======================

.. _config_mesh-group:

<group> Directive
-----------------
:Description: Describes which tests should be run between a given set of addresses. The NAME tag is used to identify the group elsewhere in the configuration. 
:Syntax: ``<group NAME>...</group>``
:Contexts: top level
:Occurrences:  One or more
:Compatibility: 3.3 or later

The group directive is one of the primary elements used for defining your configuration. Each group has a at a minimum a type and a list of members. The combination of these elements defines which tests are run. Each member of a group must reference either an :ref:`address <config_mesh-address>` defined in a :ref:`host <config_mesh-host>` block or a :ref:`host_class <config_mesh-host_class>`. For example, the following defines a group named example_group where each host tests to every other host in the list (i.e. type is mesh). The first two addresses in the list are explicitly defined (10.0.1.1 and 10.0.1.2) and the third is a host class (host_class::ten_gige)::

    <group example_group>
        type mesh
    
        member 10.0.1.1
        member 10.0.1.2
        member host_class::ten_gige
    </group>

For more on the different types of groups, see the :ref:`group <config_mesh-group-type>` type section. 

.. _config_mesh-group-type:

type Directive
-----------------
:Description: The type of group, which further determines which options should be used in the rest of the group directive. 
:Syntax: ``type disjoint|mesh|ordered_mesh|star``
:Contexts: :ref:`group <config_mesh-group>`
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

The type can be one of the following values:

* **disjoint** - This type of test defines that tests are performed between a set of addresses in group A and a second set of addresses in group B. It is possible for an address to be in both groups. See :ref:`config_mesh-group-a_member`, :ref:`config_mesh-group-b_member` and :ref:`config_mesh-group-no_agent` for more information on defining members. Example::

    <group example_disjoint_group>
        type disjoint
    
        a_member 10.0.1.1
        a_member 10.0.1.2
        
        b_member 10.0.2.1
        b_member 10.0.2.2
    </group>
* **mesh** - This type of test defines that tests are performed between all addresses in the given list.  See :ref:`config_mesh-group-member` and :ref:`config_mesh-group-no_agent` for more information on defining members. Example::

    <group example_mesh_group>
        type mesh
    
        member 10.0.1.1
        member 10.0.1.2
        member host_class::ten_gige
    </group>
* **ordered_mesh** - A special type of group were the order an address is listed matters. The first address is responsible for testing to all the hosts listed below it, the second host is responsible for testing to all the hosts below that, etc until the last address is reached, which does not initiate any tests. This ultimately leads to a full mesh, with hosts toward the top of the list taking on a larger burden for initiating and storing tests. This may be desirable if you have a set of more powerful hosts (in terms of hardware) you can put toward the top of this list with less powerful hosts toward the bottom.   See :ref:`config_mesh-group-member` for more information on defining members.  Example::

    <group example_ordered_group>
        type ordered_mesh
    
        member 10.0.1.1
        member 10.0.1.2
        member 10.0.2.1
        member 10.0.2.2
    </group>
* **star** - A mesh where a single center address tests to all other members of the group.  See :ref:`config_mesh-group-center_address` and :ref:`config_mesh-group-member` for more information on defining members. Example::
    
     <group example_star_group>
        type star
        
        center_address 10.0.0.1
        
        member 10.0.1.1
        member 10.0.1.2
        member 10.0.2.1
        member 10.0.2.2
    </group>
    
.. note:: The functional equivalent of a **star** group can alternatively be defined as a **disjoint** group where the :ref:`a_member <config_mesh-group-a_member>` OR :ref:`b_member <config_mesh-group-b_member>` is the center_address.

.. _config_mesh-group-a_member:

a_member Directive
------------------
:Description: For disjoint type groups, defines an :ref:`address <config_mesh-address>` belonging to group A. This address will only test to addresses defined in group B using the :ref:`b_member <config_mesh-group-b_member>` directive and will NOT test to other addresses in group A (unless they are also in group B). Note that the address MUST map to an :ref:`address <config_mesh-address>` defined in one (and only one) :ref:`host <config_mesh-host>` directive.
:Syntax: ``a_member ADDRESS``
:Contexts: :ref:`group <config_mesh-group>` where :ref:`type <config_mesh-group-type>` is *disjoint*
:Occurrences:  One or more
:Compatibility: 3.3 or later

.. _config_mesh-group-b_member:

b_member Directive
------------------
:Description: For disjoint type groups, defines an :ref:`address <config_mesh-address>` belonging to group B. This address will only test to addresses defined in group A using the :ref:`a_member <config_mesh-group-a_member>` directive and will NOT test to other addresses in group B (unless they are also in group A). Note that the address MUST map to an :ref:`address <config_mesh-address>` defined in one (and only one) :ref:`host <config_mesh-host>` directive.
:Syntax: ``b_member ADDRESS``
:Contexts: :ref:`group <config_mesh-group>` where :ref:`type <config_mesh-group-type>` is *disjoint*
:Occurrences:  One or more
:Compatibility: 3.3 or later


.. _config_mesh-group-center_address:

center_address Directive
------------------------
:Description: For star type groups, defines the :ref:`address <config_mesh-address>` that will test to all other addresses defined by the :ref:`member <config_mesh-group-member>` directive. Note that the address MUST map to an :ref:`address <config_mesh-address>` defined in one (and only one) :ref:`host <config_mesh-host>` directive.
:Syntax: ``center_address ADDRESS``
:Contexts: :ref:`group <config_mesh-group>` where :ref:`type <config_mesh-group-type>` is *star*
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

.. _config_mesh-group-member:

member Directive
-----------------
:Description: Defines an :ref:`address <config_mesh-address>` to be used in a group of various types (see Context row later in this table). Note that the address MUST map to an :ref:`address <config_mesh-address>` defined in one (and only one) :ref:`host <config_mesh-host>` directive.
:Syntax: ``member ADDRESS``
:Contexts: :ref:`group <config_mesh-group>` where :ref:`type <config_mesh-group-type>` is *mesh*, *ordered_mesh* or *star*
:Occurrences:  One or more
:Compatibility: 3.3 or later

.. _config_mesh-group-no_agent:

no_agent Directive
-------------------
:Description: Defines an :ref:`address <config_mesh-address>` that will not initiate tests when used in this group. This will override the :ref:`no_agent <config_mesh-host-no_agent>` field specified in the :ref:`host <config_mesh-host>` directive if defined. It is recommended you use the host directive to define this if a address cannot initiate tests for any group. Only use this form if you want a host to initiate tests when used in some groups but not others. 
:Syntax: ``no_agent ADDRESS``
:Contexts: :ref:`group <config_mesh-group>`
:Occurrences:  Zero or more
:Compatibility: 3.3 or later


Defining Tests
==============

.. _config_mesh-test:

<test> Directive
-----------------
:Description: Maps a :ref:`test_spec <config_mesh-test_spec>` to :ref:`group <config_mesh-group>`.
:Syntax: ``<test>...</test>``
:Contexts: top level
:Occurrences:  One or more
:Compatibility: 3.3 or later

A <test> directive is essentially the final step in defining the set of measurements to be run on participating hosts. By mapping a :ref:`test_spec <config_mesh-test_spec>` to a 
:ref:`group <config_mesh-group>`, you are declaring you want a test run with the parameters defined in :ref:`test_spec <config_mesh-test_spec>` for each point-to-point pair defined in :ref:`group <config_mesh-group>`. You also provided a :ref:`description <config_mesh-description>` to name the test. The :ref:`description <config_mesh-description>` has little significance to the tests themselves, but may be used for display purposes in a user interface, such as naming a grid in a dashboard. An example is below::

    <test>
        description Example BWCTL Tests
        test_spec example_bwctl_spec
        group example_mesh_group
    <test>

.. _config_mesh-test-test_spec:

group Directive
-----------------
:Description: The name of the group to use. The name must be exactly the NAME used when defining the :ref:`group <config_mesh-group>`.
:Syntax: ``group NAME``
:Contexts: :ref:`test <config_mesh-test>`
:Occurrences:   Exactly one
:Compatibility: 3.3 or later

test_spec Directive
--------------------
:Description: The name of the test_spec to use. The name must be exactly the NAME used when defining the :ref:`test_spec <config_mesh-test_spec>`
:Syntax: ``test_spec NAME``
:Contexts: :ref:`test <config_mesh-test>`
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

.. _config_mesh-dynamic_gen:

Dynamic Mesh Generation
=======================

.. _config_mesh-dynamic_gen-tag:

tag Directive
--------------
:Description: A custom string used to label an organization, site, host or address
:Syntax: ``tag TAG``
:Contexts: :ref:`organization <config_mesh-organization>`, :ref:`site <config_mesh-site>`, :ref:`host <config_mesh-host>`, :ref:`address <config_mesh-address>`
:Occurrences:  Zero or more
:Compatibility: 3.5 or later

The tag directive labels the parent object in a custom way. This label can then be used in a :ref:`config_mesh-host_class` definition to match items sharing the same tag. A good example is if you want to tag some <address> directives as "latency" and others as "throughput" on a dual-homed host. You can then define a host tag that selects only the "throughput" interfaces for throughput tests and "latency" interfaces for latency tests.

.. _config_mesh-host_class:

<host_class> Directive
-----------------------
:Description: Defines a set of criteria that if a host meets, then will be included in this class. the class can then be referenced by name in test definitions to include groups of hosts. 
:Syntax: ``<host_class>...<host_class>``
:Contexts: top level
:Occurrences:  Zero or more
:Compatibility: 3.5 or later

The <host_class> structure is one of the more complex in the MeshConfig. It is the foundational element in generating dynamic lists of hosts. A host_class has a *name* used to identify it, one or more *data sources* that contain an initial list of hosts, and a set of *filters* used to select hosts from the data sources that meet certain criteria. Optionally it may also have *host properties* used to set attributes on matching hosts such as measurement archives for storing test results. This host class can then be referenced in a :ref:`config_mesh-group` as a member using the notation *host_class::NAME* where NAME is the name of the hos class. For example, below we define a host_class that matches all hosts in our current mesh file (that's our data source in this case) belonging to organization Acme::

    <host_class>
        name      acme_org

        <data_source>
            type     current_mesh
        </data_source>

        <match>
           <filter>
               type   organization
               description   Acme
           </filter>
        </match>
    </host_class>
    
We could then letter reference this host_class in a group as follows::

    <group example_group>
        type mesh

        member 10.0.1.1
        member 10.0.1.2
        member host_class::acme_org
    </group>

An hosts we add to our mesh in the future with organization "Acme" will automatically get added to the test definitions using this group. 

.. _config_mesh-dynamic_gen-name:

name Directive
--------------
:Description: Names a host_class. This is used to reference the host class in :ref:`group <config_mesh-group>` definitions later.
:Syntax: ``name CLASSNAME``
:Contexts: :ref:`config_mesh-host_class`
:Occurrences:  Exactly one
:Compatibility: 3.5 or later

.. _config_mesh-dynamic_gen-data_source:

data_source Directive
---------------------
:Description: The data source from which to build an initial list of hosts before applying filters. See <config_mesh-dynamic_sources> for information in different types of data sources and their options.
:Syntax: ``<data_source>...</data_source>``
:Contexts: :ref:`config_mesh-host_class`
:Occurrences:  One or more
:Compatibility: 3.5 or later

.. _config_mesh-dynamic_gen-match:

match Directive
---------------
:Description: Contains a list of :ref:`filters <config_mesh-dynamic_gen-filter>` that must be matched. An empty match filter matches everything. The :ref:`exclude <config_mesh-dynamic_gen-exclude>` directive takes precedence if they both match the same host. Within a match directive, :ref:`filters <config_mesh-dynamic_gen-filter>` of the same type have an implied OR condition and filter of a different type have an implied AND condition. 
:Syntax: ``<match>...</match>``
:Contexts: :ref:`config_mesh-host_class`
:Occurrences:  Zero or one
:Compatibility: 3.5 or later

.. _config_mesh-dynamic_gen-exclude:

exclude Directive
-----------------
:Description: Contains a list of :ref:`filters <config_mesh-dynamic_gen-filter>` that if matched, exclude the host from the class. An empty exclude filter matches excludes nothing. This directive takes precedence over the :ref:`match <config_mesh-dynamic_gen-match>` directive if they both match the same host. Within an exclude directive, :ref:`filters <config_mesh-dynamic_gen-filter>` of the same type have an implied OR condition and filter of a different type have an implied AND condition. 
:Syntax: ``<exclude>...</exclude>``
:Contexts: :ref:`config_mesh-host_class`
:Occurrences:  Zero or one
:Compatibility: 3.5 or later

.. _config_mesh-dynamic_gen-filter:

filter Directive
-----------------
:Description: Used in :ref:`match <config_mesh-dynamic_gen-match>`, :ref:`exclude <config_mesh-dynamic_gen-exclude>` and certain other ref:`filter <config_mesh-dynamic_gen-filter>` directives to select a host. See :ref:`config_mesh-dynamic_filters` for a list of filter types and their options. 
:Syntax: ``<filter>...</filter>``
:Contexts: :ref:`config_mesh-dynamic_gen-match`, :ref:`config_mesh-dynamic_gen-exclude`, :ref:`config_mesh-dynamic_gen-filter` where type is *and*, *or* or *not*.  
:Occurrences:  Zero or one
:Compatibility: 3.5 or later

.. _config_mesh-dynamic_gen-host_properties:

<host_properties> Directive
---------------------------
:Description: Defines properties to assign  hosts that match the specified class. Primarily used to set the measurement archives where test results will be stored. This is a :ref:`host <config_mesh-host>` directive, so any sub-directives supported by :ref:`host <config_mesh-host>` are also supported by host_properties. You do not need to set the address. In general, this will only contain :ref:`measurement archive <config_mesh-ma>` directives. If the properties set in the block conflict with any already set in an explicit :ref:`host <config_mesh-host>` directive, then the configurations will be merged. For measurement archives this means that both sets of archives will be used. 
:Syntax: ``<host_properties>...<host_properties>``
:Contexts: :ref:`config_mesh-host_class`
:Occurrences:  Zero or one
:Compatibility: 3.5 or later

.. _config_mesh-dynamic_sources:

Dynamic Mesh Data Sources
=========================

.. _config_mesh-dynamic_sources-type:

type Directive
---------------
:Description: Defines the type of data source to be used to build the initial list of hosts
:Syntax: ``type current_mesh|requesting_agent``
:Contexts: :ref:`config_mesh-dynamic_gen-data_source`
:Occurrences:  Exactly one
:Compatibility: 3.5 or later

The type of data source defines where a :ref:`config_mesh-host_class` get the initial list of hosts where filters will be applied. The following are valid values for the type:

* **current_mesh** - Looks at all :ref:`host <config_mesh-host>` definitions in the current mesh file
* **requesting_agent** - Looks at the client reading the mesh file as a host

.. _config_mesh-dynamic_filters:

Dynamic Mesh Filters
====================

.. _config_mesh-dynamic_filters-type:

type Directive
---------------
:Description: Defines the type of filter.
:Syntax: ``type address_type|and|class|netmask|not|or|organization|site|tag``
:Contexts: :ref:`config_mesh-dynamic_gen-filter`
:Occurrences:  Exactly one
:Compatibility: 3.5 or later

The type of filter indicates what property of the address or its parent elements to match against. There are also some special filters that define boolean operations across multiple filters. The valid types and their meanings are:

* **address_type** - Matches addresses on hosts of the specified type (e.g. ipv4 or ipv6)
* **and** - A special operand that takes a set of filters and will return true if ALL filters match
* **class** - This takes the name of another class and only returns true if the host also belong to the specified class. This allows a simple form of inheritance between classes.
* **netmask** - Matches a address if it is in the specified IP netmask 
* **not** -  A special operand that returns true only if the underlying filters return false and vice versa
* **or** -  A special operand that takes a set of filters and will return true if ANY filters match
* **organization** - Matches the organization ref:`description <config_mesh-description>` of a host
* **site** - Matches the site ref:`description <config_mesh-description>` of a host
* **tag** - Matches a :ref:`tag <config_mesh-dynamic_gen-tag>` on an :ref:`address <config_mesh-address>` or its parent :ref:`organization <config_mesh-organization>`, :ref:`site <config_mesh-site>`, or :ref:`host <config_mesh-host>`

.. _config_mesh-dynamic_filters-address_type:

address_type Directive
----------------------
:Description: Defines the type of address to match against for filters with type *address_type*
:Syntax: ``address_type ipv4|ipv6``
:Contexts: :ref:`config_mesh-dynamic_gen-filter` where type is *address_type*
:Occurrences:  Exactly one
:Compatibility: 3.5 or later

.. _config_mesh-dynamic_filters-class:

class Directive
----------------------
:Description: Defines the name of the :ref:`host_class <config_mesh-host_class>` to match against for filters with type *class*
:Syntax: ``class CLASSNAME``
:Contexts: :ref:`config_mesh-dynamic_gen-filter` where type is *class*
:Occurrences:  Exactly one
:Compatibility: 3.5 or later

.. _config_mesh-dynamic_filters-description:

description Directive
---------------------
:Description: Defines the description of the parent :ref:`organization <config_mesh-organization>` or :ref:`site <config_mesh-site>` to match for hosts belonging to this class
:Syntax: ``description DESCRIPTION``
:Contexts: :ref:`config_mesh-dynamic_gen-filter` where type is *organization* or *site*
:Occurrences:  Exactly one
:Compatibility: 3.5 or later

.. _config_mesh-dynamic_filters-exact:

exact Directive
---------------
:Description: Indicates the given match should be case-sensitive if enabled. Disabled (i.e. case-insensitive matches) by default if not specified. 
:Syntax: ``exact 0|1``
:Contexts: :ref:`config_mesh-dynamic_gen-filter` where type is *tag*, *organization* or *site*
:Occurrences:  Exactly one

.. _config_mesh-dynamic_filters-netmask:

netmask Directive
-----------------
:Description: The IP netmask used to match addresses when filter type is *netmask*
:Syntax: ``netmask NETMASK``
:Contexts: :ref:`config_mesh-dynamic_gen-filter` where type is *netmask*
:Occurrences:  Exactly one

.. _config_mesh-dynamic_filters-tag:

tag Directive
---------------
:Description: The tag to match for an address or its parent elements in order for it to be included in the mesh
:Syntax: ``tag TAG``
:Contexts: :ref:`config_mesh-dynamic_gen-filter` where type is *tag*
:Occurrences:  Exactly one

Optional Descriptive Fields
===========================

.. _config_mesh-administrator:

<administrator> Directive
--------------------------
:Description: Defines contact information for administrator of parent element
:Syntax: ``<administrator>...</administrator>``
:Contexts: top level, :ref:`organization <config_mesh-organization>`, :ref:`site <config_mesh-site>`, :ref:`host <config_mesh-host>`
:Occurrences:  Zero or more
:Compatibility: 3.3 and later

This element is primarily used for informational purposes. If defined at the top-level, it is assumed it is the contact information of the person managing this mesh. It is not strictly required in any of it's parent elements but may be useful in keeping track of the various administrators of meshes, organization, hosts and/or sites. 

name Directive
--------------
:Description: The full name of the administrator. 
:Syntax: ``name ADMINISTRATOR NAME``
:Contexts: :ref:`administrator <config_mesh-administrator>`
:Occurrences:  Exactly one per parent
:Compatibility: 3.3 and later


email Directive
---------------
:Description: The full name of the administrator. 
:Syntax: ``email ADMIN@MYDOMAIN``
:Contexts: :ref:`administrator <config_mesh-administrator>`
:Occurrences:  Exactly one per parent
:Compatibility: 3.3 and later

.. _config_mesh-location:

<location> Directive
--------------------
:Description: A directive to describe the location of the parent
:Syntax: ``<location>...</location>``
:Contexts: :ref:`organization <config_mesh-organization>`, :ref:`site <config_mesh-site>`, :ref:`host <config_mesh-host>`
:Occurrences:  Zero or One
:Compatibility: 3.3 or later

This element's intent is primarily for uses for displays that are capable of showing location information. At this point it is largely unused and may be skipped if so desired.


street_address Directive
------------------------
:Description: The street address (e.g. 1 Cyclotron Road) of the parent location
:Syntax: ``street_address ADDRESS``
:Contexts: :ref:`location <config_mesh-location>`
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

city Directive
--------------
:Description: The city (e.g. Berkeley) of the parent location
:Syntax: ``city CITY``
:Contexts: :ref:`location <config_mesh-location>`
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

state Directive
-------------------
:Description: The state, province or other country-specific region (e.g. CA) of the parent location
:Syntax: ``state STATE``
:Contexts: :ref:`location <config_mesh-location>`
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

country Directive
-------------------
:Description: The 2-letter ISO country code (e.g. US) of the parent location
:Syntax: ``country COUNTRY``
:Contexts: :ref:`location <config_mesh-location>`
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

postal_code Directive
----------------------
:Description: The postal code (e.g. 94720) of the parent location
:Syntax: ``postal_code POSTAL_CODE``
:Contexts: :ref:`location <config_mesh-location>`
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

latitude Directive
-------------------
:Description: The latitude (e.g. 37.8717) of the parent location
:Syntax: ``latitude LATITUDE``
:Contexts: :ref:`location <config_mesh-location>`
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

longitude Directive
-------------------
:Description: The longitude (e.g. -122.2728) of the parent location
:Syntax: ``longitude LONGITUDE``
:Contexts: :ref:`location <config_mesh-location>`
:Occurrences:  Exactly one
:Compatibility: 3.3 or later

.. _config_mesh-tag:


