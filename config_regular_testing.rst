****************************************
Regular Testing Configuration File
****************************************

The :ref:`regular testing configuration file <config_files-regtesting-conf-main>` is used to define the schedule of measurements that your host will run and the location(s) where the results of those tests will be stored. In general you will not need to edit this file by hand. Most configurations use either the :doc:`central mesh configuration software <multi_overview>` (often referred to as MeshConfig) or the the :doc:`perfSONAR Toolkit web interface <manage_regular_tests>` to generate this file. Some cases where you may need to edit this file by hand are as follows (this is not an exhaustive list):

* You are running only a small number of non-Toolkit measurement hosts and have no central mesh defined.
* You would like to set parameters not supported by the GUI or MeshConfig.
* You need to change or set authentication tokens used to register to a measurement archive.
* You want to use an alternative or additional measurement archive as opposed to the one defined by your default toolkit installation and/or in your central mesh configuration file

The basic structure of this file is as follows:

* A set of top-level directives that set values of general user and/or global defaults
* The list of tests you want to run
* The list of measurement archives where data should be stored. 

With these items in mind the remainder of this section contains a full reference of the options available in the ref:`regular testing configuration file <config_files-regtesting-conf-main>`. 

.. _config_regular_testing-top_level:

General Settings
=================

.. _config_regular_testing-added_by_mesh:

added_by_mesh Directive
--------------------------------
:Description: If set to 1, indicates the parent element was added by the MeshConfig software. This means the MeshConfig software will change or remove the test as needed. If set to 0 (the default) then the MeshConfig will not change the parent element.
:Syntax: ``added_by_mesh 0|1``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`,: ref:`test <config_regular_testing-test>`, 
:Occurrences:  Zero or One
:Default: 0
:Compatibility: 3.4 and later

.. _config_regular_testing-default_parameters:

default_parameters Directive
------------------------------
:Description: A set of parameters to assign to any test of the specified :ref:`type <config_regular_testing-test-test_type>` where the provided parameters are not otherwise set. For valid parameters see the relevant type-specific test parameters section.
:Syntax: ``<default_parameters>...</default_parameters>``
:Contexts: top level
:Occurrences:  Zero or More
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-description:

description Directive
--------------------------------
:Description: A human-readable description of the parent directive. For display and identification purposes only. 
:Syntax: ``description DESCRIPTION``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`, :ref:`test <config_regular_testing-test>`, :ref:`target <config_regular_testing-target>`
:Occurrences:  Exactly One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-measurement_archive:

measurement_archive Directive
------------------------------
:Description: Describes a measurement archive where results can be stored. See :ref:`config_regular_testing-ma` for more details on the parameters that can be set in this block. 
:Syntax: ``<measurement_archive>...</measurement_archive>``
:Contexts: top level, :ref:`test <config_regular_testing-test>`
:Occurrences:  Zero or More
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-test_result_directory:

test_result_directory Directive
--------------------------------
:Description: The directory where results are temporarily queued before being sent to the measurement archive(s)
:Syntax: ``test_result_directory DIR``
:Contexts: top level
:Occurrences:  Zero or One
:Default: /var/lib/perfsonar/regulartesting
:Compatibility: 3.4 and later

.. _config_regular_testing-test:

test Directive
---------------
:Description: Describes a measurement to be performed. See :ref:`config_regular_testing-tests` for more details on defining this block.
:Syntax: ``<test>...</test>``
:Contexts: top level
:Occurrences:  Zero or More
:Default: N/A
:Compatibility: 3.4 and later


.. _config_regular_testing-ma:

Measurement Archives
=====================

.. _config_regular_testing-ca_certificate_file:

ca_certificate_file Directive
--------------------------------
:Description: The location of a certificate authority's (CA) certificate file that can be used to verify a server's SSL certificate when using HTTPS.
:Syntax: ``ca_certificate_file FILE``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`
:Occurrences:  Zero or One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-ca_certificate_path:

ca_certificate_path Directive
--------------------------------
:Description: The location of a directory containing one or more certificate authority (CA) certificate files that can be used to verify a server's SSL certificate when using HTTPS.
:Syntax: ``ca_certificate_path DIR``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`
:Occurrences:  Zero or One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-database:

database Directive
--------------------------------
:Description: The URL of the measurement archive where results will be stored.
:Syntax: ``database URL``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`
:Occurrences:  Exactly One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-disable_default_summaries:

disable_default_summaries Directive
------------------------------------
:Description: Disables a default set of summaries being used if no :ref:`summary <config_regular_testing-summary>` directives are provided.
:Syntax: ``disable_default_summaries 0|1``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`
:Occurrences:  Exactly One
:Default: 0
:Compatibility: 3.5 and later

.. _config_regular_testing-max_parallelism:

max_parallelism Directive
------------------------------------
:Description: The maximum number of processes to concurrently spawn dedicated to writing results to this measurement archive.
:Syntax: ``max_parallelism NUMBER``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`
:Occurrences:  Exactly One
:Default: 5
:Compatibility: 3.4 and later

.. _config_regular_testing-password:

password Directive
------------------------------------
:Description: The password or API key to use when authenticating to the measurement archive. If not set, then IP authentication or another means must be configured on the server.
:Syntax: ``password PASSWD``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`
:Occurrences:  Zero or One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-queue_directory:

queue_directory Directive
------------------------------------
:Description: The directory to keep results while they are in the queue to be written to the measurement archive. 
:Syntax: ``queue_directory DIR``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`
:Occurrences:  Zero or One
:Default: A subdirectory named with :ref:`type <config_regular_testing-ma-type>` and the host portion of :ref:`database <config_regular_testing-database>` under the directory defined by :ref:`test_results_directory <config_regular_testing-test_result_directory>`
:Compatibility: 3.4 and later

.. _config_regular_testing-summary:

summary Directive
-------------------------
:Description: Describes a summarization you would like the measurement archive to perform on the data. See :ref:`config_regular_testing-ma_summaries` for more information.
:Syntax: ``<summary>...<summary>``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`
:Occurrences:  Zero or More
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-timeout:

timeout Directive
-------------------------
:Description: The number of seconds to wait for the archive server to return a response when writing data.
:Syntax: ``timeout SECONDS``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`
:Occurrences:  Zero or More
:Default: 60
:Compatibility: 3.4 and later

.. _config_regular_testing-ma-type:

type Directive
-------------------------
:Description: The type of measurement archive.
:Syntax: ``type esmond/latency|esmond/throughput|esmond/traceroute|null``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`
:Occurrences:  Exactly One
:Default: N/A
:Compatibility: 3.4 and later

The currently supported options for this value are:

* **esmond/latency** - Stores OWAMP(powstream and bwping) and Ping results
* **esmond/throughput** - Stores BWCTL results that use throughput tools like iperf and iperf3
* **esmond/raceroute** - Stores traceroute (and similar tools such as tracepath and paris-traceroute) results as reported by bwtraceroute.
* **null** - For testing only. Does not store results anywhere. 

.. _config_regular_testing-username:

username Directive
-------------------------
:Description: The username to use when authenticating to a measurement archive. If not set, then it is assumed IP authentication or some other mechanism will be used to register data.
:Syntax: ``username USER``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`
:Occurrences:  Zero or One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-verify_hostname:

verify_hostname Directive
-------------------------
:Description: If using https, indicates whether the hostname should be matched against the common name in the server's X.509 certificate.
:Syntax: ``verify_hostname 0|1``
:Contexts: :ref:`measurement_archive <config_regular_testing-measurement_archive>`
:Occurrences:  Zero or One
:Default: 0
:Compatibility: 3.4 and later

.. _config_regular_testing-ma_summaries:

Measurement Archive Summaries
=============================

.. _config_regular_testing-event_type:

event_type Directive
-------------------------
:Description: The event type to summarize. See the official `event type list <http://software.es.net/esmond/perfsonar_client_rest.html#full-list-of-event-types>`_ for valid values.
:Syntax: ``event_type TYPE``
:Contexts: :ref:`summary <config_regular_testing-summary>`
:Occurrences:  Exactly One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-summary_type:

summary_type Directive
-------------------------
:Description: The type of summary. Valid values are *aggregation*, *average* and *statistics* though which of those is supported is dependent on the :ref:`event type <config_regular_testing-event_type>`. See the `API specification <https://docs.google.com/document/u/1/d/1DFl4bgFxIQtRqYIZPHAT8xW4TACppKq2UeYK13ZsUDk/pub>`_ for full details
:Syntax: ``summary_type TYPE``
:Contexts: :ref:`summary <config_regular_testing-summary>`
:Occurrences:  Exactly One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-summary_window:

summary_window Directive
-------------------------
:Description: The time in seconds over which the data should be summarized.
:Syntax: ``summary_window SECONDS``
:Contexts: :ref:`summary <config_regular_testing-summary>`
:Occurrences:  Exactly One
:Default: N/A
:Compatibility: 3.4 and later


.. _config_regular_testing-tests:

Tests
======

.. _config_regular_testing-disabled:

disabled Directive
-------------------------
:Description: If set to 1, then the enclosing :ref:`test <config_regular_testing-test>` is not run
:Syntax: ``disabled 0|1``
:Contexts: :ref:`test <config_regular_testing-test>`
:Occurrences:  Zero or One
:Default: 0
:Compatibility: 3.4 and later

.. _config_regular_testing-local_address:

local_address Directive
-------------------------
:Description: The IP address or hostname to use as the local address for tests. This must map to an address on the host where regular_testing is running. Takes precedence over :ref:`local_interface <config_regular_testing-local_interface>` if both specified. 
:Syntax: ``local_address ADDRESS``
:Contexts: :ref:`test <config_regular_testing-test>`
:Occurrences:  Zero or One
:Default: The address on :ref:`local_interface <config_regular_testing-local_interface>` if set or the address on the outgoing interface as chosen by the local routing tables
:Compatibility: 3.4 and later

.. _config_regular_testing-local_interface:

local_interface Directive
---------------------------
:Description: The name of the interface where tests should be run. This must map to an interface name on the host where regular_testing is running. This is ignored in favor of :ref:`local_address <config_regular_testing-local_address>` if both specified. 
:Syntax: ``local_interface IFNAME``
:Contexts: :ref:`test <config_regular_testing-test>`
:Occurrences:  Zero or One
:Default: The address set by :ref:`local_address <config_regular_testing-local_address>` if set or the address on the outgoing interface as chosen by the local routing tables
:Compatibility: 3.4 and later

.. _config_regular_testing-parameters:

parameters Directive
-------------------------
:Description: The parameters of the test. See :ref:`config_regular_testing-params-general` for details on common parameters and the type specific sections for tool-related values.
:Syntax: ``<parameters>...</parameters>``
:Contexts: :ref:`test <config_regular_testing-test>`
:Occurrences:  Exactly One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-schedule:

schedule Directive
-------------------------
:Description: The schedule indicating how often the tests will run. See :ref:`config_regular_testing-schedules` for more details on the options available.
:Syntax: ``<schedule>...</schedule>``
:Contexts: :ref:`test <config_regular_testing-test>`
:Occurrences:  Exactly One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-target:

target Directive
-------------------------
:Description: The remote location to and from which tests should be performed. The syntax for this directive can take a simple form where it is given just an address and a complex form where a block is provided that allows parameters to be overwritten to just the target address. See :ref:`config_regular_testing-targets` for more details on the complex form.
:Syntax (Simple): ``target ADDRESS``
:Syntax (Complex): ``<target>...</target>``
:Contexts: :ref:`test <config_regular_testing-test>`
:Occurrences:  Zero or More
:Default: N/A
:Compatibility: 3.4 and later


.. _config_regular_testing-targets:

Test Targets
==============

.. _config_regular_testing-target_address:

address Directive
-------------------------
:Description: The IP address or hostname of the target with which to perform a test. 
:Syntax: ``address ADDRESS``
:Contexts: :ref:`target <config_regular_testing-target>`
:Occurrences:  Exactly One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-override_parameters:

override_parameters Directive
------------------------------
:Description: A set of parameters to use only to this target. It will override any parameters of the same type already set. See :ref:`config_regular_testing-params-general` and the test-specific parameter sections for a list of valid options.
:Syntax: ``<override_parameters>...</override_parameters>``
:Contexts: :ref:`target <config_regular_testing-target>`
:Occurrences:  Zero or One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-schedules:

Test Schedules
==============

.. _config_regular_testing-sched_interval:

interval Directive
-------------------------
:Description: The number of seconds to wait in between tests to the same :ref:`target <config_regular_testing-target>`. 
:Syntax: ``interval SECONDS``
:Contexts: :ref:`schedule <config_regular_testing-schedule>` where :ref:`type <config_regular_testing-sched_type>` is *regular_intervals*
:Occurrences:  Exactly One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-random_start_percentage:

random_start_percentage Directive
----------------------------------
:Description: The percentage of variation between :ref:`intervals <config_regular_testing-sched_interval>` of a test. Specified as a number between 0 and 50 (inclusive).
:Syntax: ``random_start_percentage PERCENTAGE``
:Contexts: :ref:`schedule <config_regular_testing-schedule>` where :ref:`type <config_regular_testing-sched_type>` is *regular_intervals*
:Occurrences:  Zero or One
:Default: Tool default
:Compatibility: 3.4 and later

.. _config_regular_testing-time_slot:

time_slot Directive
----------------------------------
:Description: A list of specific times at which to run a test. Can be specified as ``HH:MM`` or ``*:MM`` where ``*`` indicates that the test should be run every hour. Only compatible with tools that support timed scheduling and actual runtime with respect to the time defined may vary depending on the tool. You can specify multiple times.
:Syntax: ``time_slot HH:MM|*:MM``
:Contexts: :ref:`schedule <config_regular_testing-schedule>` where :ref:`type <config_regular_testing-sched_type>` is *time_schedule*
:Occurrences:  One or More
:Default: Tool default
:Compatibility: 3.4 and later


.. _config_regular_testing-sched_type:

type Directive
-------------------------
:Description: The type of schedule. See below for valid options. Certain tests only support certain schedules. 
:Syntax: ``type TYPE``
:Contexts: :ref:`schedule <config_regular_testing-schedule>`
:Occurrences:  Exactly one
:Default: N/A
:Compatibility: 3.4 and later

Valid types include:

* *regular_intervals* - Runs a test a specified number of seconds apart (see :ref:`config_regular_testing-sched_interval`) with an optional variation (see :ref:`config_regular_testing-random_start_percentage`).
* *streaming* - Constantly runs test. 
* *time_schedule* - Runs a test at an explicitly set sequence of times (see :ref:`config_regular_testing-time_slot`)


.. _config_regular_testing-params-general:

General Test Parameters
========================

.. _config_regular_testing-test-control_address:

control_address Directive
-------------------------
:Description: The IP address of the interface out which you want BWCTL control messages sent. Use this if you want to send control messages over a separate interface than the data packets. You will most likely do this for firewall reasons. 
:Syntax: ``control_address ADDRESS``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is one of the *bwctl*, *bwping*, *bwping/owamp*, *bwtraceroute*
:Occurrences:  Zero or One
:Default: Uses local routing table
:Compatibility: 3.5.1 and later


.. _config_regular_testing-test-force_ipv4:

force_ipv4 Directive
---------------------
:Description: Forces the test to use IPv4. 
:Syntax: ``force_ipv4 0|1``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>`
:Occurrences:  Zero or One
:Default: 0
:Compatibility: 3.4 and later

.. _config_regular_testing-test-force_ipv6:

force_ipv6 Directive
---------------------
:Description: Forces the test to use IPv6. 
:Syntax: ``force_ipv6 0|1``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>`
:Occurrences:  Zero or One
:Default: 0
:Compatibility: 3.4 and later

.. _config_regular_testing-test-latest_time:

latest_time Directive
---------------------
:Description: The number of seconds in the future a test may be scheduled before being considered failed. Corresponds to the various bwctl or bwctl2 tools *-L* option. 
:Syntax: ``latest_time SECONDS``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is one of the *bwctl*, *bwctl2*, *bwping*, *bwping2*, *bwping/owamp*, *bwping2/owamp*, *bwtraceroute*,  *bwtraceroute2*
:Occurrences:  Zero or One
:Default: Tool default
:Compatibility: 3.4 and later

.. _config_regular_testing-test-local_firewall:

local_firewall Directive
--------------------------
:Description: Indicates the local host is behind a NAT or firewall so the connection initiator should always be the local host to prevent incoming connections that will get blocked. Corresponds to the bwctl or bwctl2 tools *-o* option. 
:Syntax: ``local_firewall 0|1``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is one of the *bwctl*, *bwctl2*, *bwping*, *bwping2*, *bwping/owamp*, *bwping2/owamp*, *bwtraceroute*,  *bwtraceroute2*
:Occurrences:  Zero or One
:Default: Tool default
:Compatibility: 3.4 and later

.. _config_regular_testing-test-packet_tos_bits:

packet_tos_bits Directive
--------------------------
:Description: The TOS bits to set in the IP header as an integer. Corresponds to BWCTL *-S* option.
:Syntax: ``packet_tos_bits TOS``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwctl*, *bwctl2*, *bwping*, *bwping2*, *bwtraceroute*, *bwtraceroute2*
:Occurrences:  Zero or One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-test-receive_only:

receive_only Directive
--------------------------
:Description: Indicates that tests should only be run in the direction where the local host is the receiver and the target host is the sender. 
:Syntax: ``receive_only 0|1``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>`
:Occurrences:  Zero or One
:Default: 0
:Compatibility: 3.4 and later

.. _config_regular_testing-test-send_only:

send_only Directive
--------------------------
:Description: Indicates that tests should only be run in the direction where the local host is the sender and the target host is the receiver. 
:Syntax: ``send_only 0|1``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>`
:Occurrences:  Zero or One
:Default: 0
:Compatibility: 3.4 and later


.. _config_regular_testing-test-test_ipv4_ipv6:

test_ipv4_ipv6 Directive
-------------------------------
:Description: Indicates both an IPv4 and IPv6 test should be performed.  
:Syntax: ``test_ipv4_ipv6 0|1``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>`
:Occurrences:  Zero or One
:Default: 0
:Compatibility: 3.4 and later

.. _config_regular_testing-test-test_type:

type Directive
---------------
:Description: The type of test to run. Determines the set of supported directives in the rest of this block. See below for more details.
:Syntax: ``type TYPE``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>`
:Occurrences:  Exactly one
:Default: N/A
:Compatibility: 3.4 and later

Valid types include:

* *bwctl* - Runs a BWCTL throughput test. See for :ref:`config_regular_testing-params-bwctl` for supported parameters specific to this type.
* *bwctl2* - *WARNING: BETA ONLY.*  Runs a BWCTL2 throughput test. See :ref:`config_regular_testing-params-bwctl` for supported parameters specific to this type.
* *bwping* - Runs a scheduled ping test using bwping. See :ref:`config_regular_testing-params-bwping` for supported parameters specific to this type.
* *bwping2* - *WARNING: BETA ONLY.* Runs a scheduled ping test using bwping2. See :ref:`config_regular_testing-params-bwping` for supported parameters specific to this type.
* *bwping/owamp* - Runs a scheduled OWAMP test using bwping. See :ref:`config_regular_testing-params-bwping` for supported parameters specific to this type.
* *bwping2/owamp* - *WARNING: BETA ONLY.* Runs a scheduled OWAMP test using bwping2. See :ref:`config_regular_testing-params-bwping` for supported parameters specific to this type.
* *bwtraceroute* - Runs a scheduled traceroute test using bwtraceroute. See :ref:`config_regular_testing-params-bwtraceroute` for supported parameters specific to this type.
* *bwtraceroute2* - *WARNING: BETA ONLY.* Runs a scheduled traceroute test using bwtraceroute2. See :ref:`config_regular_testing-params-bwtraceroute` for supported parameters specific to this type.
* *powstream* - Runs a streaming OWAMP test using the powstream tool. See :ref:`config_regular_testing-params-powstream` for supported parameters specific to this type.

.. _config_regular_testing-params-bwctl:

bwctl Test Parameters
================================

.. _config_regular_testing-test-buffer_length:

buffer_length Directive
---------------------------
:Description: The length of read/write buffers in bytes. Corresponds to the BWCTL *-l* option.
:Syntax: ``buffer_length BYTES``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwctl* or *bwctl2*
:Occurrences:  Zero or One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-test-bwctl_cmd:

bwctl_cmd Directive
------------------------
:Description: The path to the bwctl command to run
:Syntax: ``bwctl_cmd CMD``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwctl* or *bwctl2*
:Occurrences:  Zero or One
:Default: /usr/bin/bwctl for *bwctl* and /usr/bin/bwctl2 for *bwctl2*
:Compatibility: 3.4 and later

.. _config_regular_testing-test-duration:

duration Directive
--------------------
:Description: The time in seconds to run the test. Corresponds to the BWCTL *-t* option.
:Syntax: ``duration SECONDS``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwctl* or *bwctl2*
:Occurrences:  Zero or One
:Default: 10
:Compatibility: 3.4 and later


.. _config_regular_testing-test-omit_interval:

omit_interval Directive
--------------------------
:Description: The number of seconds at the beginning of the test to ignore results. Useful for high-latency TCP transfers where throughput needs time to ramp-up. Note that this extends the time of the test the number of seconds specified. Corresponds to BWCTL *-O* option.
:Syntax: ``omit_interval SECONDS``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwctl* or *bwctl2* and :ref:`tool <config_regular_testing-test-bwctl_tool>` is *iperf3*
:Occurrences:  Zero or One
:Default: 0
:Compatibility: 3.4 and later

.. _config_regular_testing-test-streams:

streams Directive
--------------------------
:Description: The number of parallel streams to run. Corresponds to BWCTL *-P* option.
:Syntax: ``streams COUNT``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwctl* or *bwctl2*
:Occurrences:  Zero or One
:Default: 1
:Compatibility: 3.4 and later

.. _config_regular_testing-test-bwctl_tool:

tool Directive
--------------------------
:Description: The tool to use when running the BWCTL test. Valid values are *iperf* and *iperf3*. Separating the tools by commas tells BWCTL to try the first tool in the list and fallback in sequence to the remaining tools in the list until it finds one both endpoints have in common. Corresponds to the BWCTL -T option. 
:Syntax: ``tool TOOL``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwctl* or *bwctl2*
:Occurrences:  Zero or One
:Default: iperf
:Compatibility: 3.4 and later

.. _config_regular_testing-test-udp_bandwidth:

udp_bandwidth Directive
--------------------------
:Description: For UDP tests, the rate at which to send packets in bits per second (bps). Corresponds to BWCTL *-b* option. 
:Syntax: ``udp_bandwidth BITSPERSECOND``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwctl* or *bwctl2* AND :ref:`use_udp <config_regular_testing-test-use_udp>` is 1
:Occurrences:  Zero or One
:Default: Tool default
:Compatibility: 3.4 and later

.. _config_regular_testing-test-use_udp:

use_udp Directive
--------------------------
:Description: Indicates whether this is a UDP test. Corresponds to BWCTL *-u* option. 
:Syntax: ``use_udp 0|1``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwctl* or *bwctl2*
:Occurrences:  Zero or One
:Default: 0
:Compatibility: 3.4 and later

.. _config_regular_testing-test-window_size:

window_size Directive
--------------------------
:Description: The TCP window size. Corresponds to BWCTL *-w* option. 
:Syntax: ``window_size BYTES``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwctl* or *bwctl2*
:Occurrences:  Zero or One
:Default: N/A
:Compatibility: 3.4 and later


.. _config_regular_testing-params-bwping:

bwping Test Parameters
=======================

.. _config_regular_testing-test-bwping_cmd:

bwping_cmd Directive
--------------------------
:Description: The location of the bwping command
:Syntax: ``bwping_cmd CMD``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwping*, *bwping2*, *bwping/owamp* or *bwping2/owamp*
:Occurrences:  Zero or One
:Default: /usr/bin/bwping for *bwping* and *bwping/owamp*. /usr/bin/bwping2 for *bwping2* and *bwping2/owamp*
:Compatibility: 3.4 and later

.. _config_regular_testing-test-inter_packet_time:

inter_packet_time Directive
-------------------------------
:Description: The time in seconds to wait in between packets. Corresponds to the bwping *-i* option. 
:Syntax: ``inter_packet_time SECONDS``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwping*, *bwping2*, *bwping/owamp* or *bwping2/owamp*
:Occurrences:  Zero or One
:Default: 1.0
:Compatibility: 3.4 and later

.. _config_regular_testing-test-packet_count:

packet_count Directive
-------------------------------
:Description: The number of packets to send. Corresponds to the bwping *-N* option. 
:Syntax: ``packet_count COUNT``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwping*, *bwping2*, *bwping/owamp* or *bwping2/owamp*
:Occurrences:  Zero or One
:Default: 10
:Compatibility: 3.4 and later

.. _config_regular_testing-test-packet_length:

packet_length Directive
-------------------------------
:Description: The size in bytes of packets to send. Corresponds to the bwping *-l* option. 
:Syntax: ``packet_length BYTES``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwping*, *bwping2*, *bwping/owamp* or *bwping2/owamp*
:Occurrences:  Zero or One
:Default: 1000
:Compatibility: 3.4 and later

.. _config_regular_testing-test-packet_ttl:

packet_ttl Directive
-------------------------------
:Description: The maximum number of hops a packet may traverse before being dropped. Corresponds to the bwping *-t* option. 
:Syntax: ``packet_ttl TTL``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwping*, *bwping2*, *bwping/owamp* or *bwping2/owamp*
:Occurrences:  Zero or One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-params-bwtraceroute:

bwtraceroute Test Parameters
==============================================

.. _config_regular_testing-test-bwtraceroute_cmd:

bwtraceroute_cmd Directive
--------------------------
:Description: The location of the bwtraceroute command
:Syntax: ``bwtraceroute_cmd CMD``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwtraceroute* or *bwtraceroute2*
:Occurrences:  Zero or One
:Default: /usr/bin/bwtraceroute for *bwping* and /usr/bin/bwtraceroute2 for *bwtraceroute2*
:Compatibility: 3.4 and later

.. _config_regular_testing-test-packet_first_ttl:

packet_first_ttl Directive
--------------------------
:Description: Only compatible when :ref:`tool <config_regular_testing-test-bwtraceroute_tool>` is *traceroute*. The first hop to display (starting at 1) of the traceroute. Corresponds to the bwtraceroute *-F* option. 
:Syntax: ``tool TOOL``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwtraceroute* or *bwtraceroute2* and :ref:`tool <config_regular_testing-test-bwtraceroute_tool>` is *traceroute*
:Occurrences:  Zero or One
:Default: Tool default
:Compatibility: 3.4 and later

.. _config_regular_testing-test-bwtraceroute-packet_length:

packet_length Directive
--------------------------
:Description: The size of the packets to send in bytes. Corresponds to the bwtraceroute *-l* option. 
:Syntax: ``tool BYTES``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwtraceroute* or *bwtraceroute2*
:Occurrences:  Zero or One
:Default: Tool default
:Compatibility: 3.4 and later

.. _config_regular_testing-test-packet_max_ttl:

packet_max_ttl Directive
--------------------------
:Description: Only compatible when :ref:`tool <config_regular_testing-test-bwtraceroute_tool>` is *traceroute*. The maximum number of hops traceroute will try before reaching the destination. Corresponds to the bwtraceroute *-M* option. 
:Syntax: ``tool TOOL``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwtraceroute* or *bwtraceroute2* and :ref:`tool <config_regular_testing-test-bwtraceroute_tool>` is *traceroute*
:Occurrences:  Zero or One
:Default: Tool default
:Compatibility: 3.4 and later

.. _config_regular_testing-test-bwtraceroute_tool:

tool Directive
--------------------------
:Description: The tool to use when running the bwtraceroute test. Valid values are *traceroute*, *tracepath* and *paris-traceroute*. Separating the tools by commas tells BWCTL to try the first tool in the list and fallback in sequence to the remaining tools in the list until it finds one both endpoints have in common. Corresponds to the bwtraceroute *-T* option. 
:Syntax: ``tool TOOL``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *bwtraceroute* or *bwtraceroute2*
:Occurrences:  Zero or One
:Default: tracepath,traceroute
:Compatibility: 3.4 and later

.. _config_regular_testing-params-powstream:

powstream Test Parameters
==========================

.. _config_regular_testing-test-powstream-inter_packet_time:

inter_packet_time Directive
-----------------------------
:Description: The number of seconds in between sending packets. Note that this may be a floating-point number less than 1 to send multiple packets per second.  Corresponds to powstream *-i* option.
:Syntax: ``inter_packet_time SECONDS``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *powstream*
:Occurrences:  Zero or One
:Default: .1
:Compatibility: 3.4 and later

.. _config_regular_testing-test-log_level:

log_level Directive
-----------------------------
:Description: Controls the number and detail of messages sent to syslog. Keeping this reasonable is especially important when using a central syslog server as not to flood the server with requests. Corresponds to powstream *-g* option.
:Syntax: ``log_level FATAL|WARN|INFO|DEBUG|ALL|NONE``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *powstream*
:Occurrences:  Zero or One
:Default: Tool default
:Compatibility: 3.4 and later

.. _config_regular_testing-test-owstats_cmd:

owstats_cmd Directive
--------------------------
:Description: The location of the owstats command
:Syntax: ``owstats_cmd CMD``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *powstream*
:Occurrences:  Zero or One
:Default: /usr/bin/owstats
:Compatibility: 3.4 and later

packet_length Directive
--------------------------
:Description: The size in bytes to add to the packet payload.  Corresponds to powstream *-s* option.
:Syntax: ``packet_length BYTES``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *powstream*
:Occurrences:  Zero or One
:Default: 0
:Compatibility: 3.4 and later

.. _config_regular_testing-test-powstream_cmd:

powstream_cmd Directive
--------------------------
:Description: The location of the powstream command
:Syntax: ``powstream_cmd CMD``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *powstream*
:Occurrences:  Zero or One
:Default: /usr/bin/powstream
:Compatibility: 3.4 and later

.. _config_regular_testing-test-receive_port_range:

receive_port_range Directive
------------------------------
:Description: The range of ports to use for receiving UDP data packets used to perform OWAMP measurements.  Note that powstream does not talk to the local OWAMPD instance, so this needs to be set separately from the corresponding value in OWAMP server configuration. Corresponds to powstream *-P* option.
:Syntax: ``receive_port_range RANGE``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *powstream*
:Occurrences:  Zero or One
:Default: N/A
:Compatibility: 3.4 and later

.. _config_regular_testing-test-resolution:

resolution Directive
------------------------------
:Description: The number of seconds to run a test before reporting results.
:Syntax: ``resolution SECONDS``
:Contexts: :ref:`parameters <config_regular_testing-parameters>`, :ref:`override_parameters <config_regular_testing-override_parameters>`, :ref:`default_parameters <config_regular_testing-default_parameters>` where :ref:`type <config_regular_testing-test-test_type>` is *powstream*
:Occurrences:  Zero or One
:Default: 60
:Compatibility: 3.4 and later





