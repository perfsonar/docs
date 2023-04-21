******************************
Test and Tool Reference
******************************

.. Notes for stuff we should make sure thus pages has
.. Page should contain at least the following:
..     * For each test type:
..     
..         * Description of test
..         * Type (background vs backgroundmulti vs normal vs exclusive). Define these in this doc as well.
..         * Command-line switches
..         * Common tools and preference order (with note we do not control every tool so could change if install third-party thing)
..         * Number of participants
..        * Any other special notes about test
..    * For each tool type:
..    
..         * Description of tool
..         * Supported/Unsupported options
..         * Any special notes

Introduction
=============
Everything in pScheduler begins with requesting a :term:`test` which in turn will be carried-out by a :term:`tool`. When you run the ``pscheduler task`` command the first required argument is the test type and all arguments that follow are dependent on the type of test. The document aims to give you a list of tests and their corresponding tools provided by a default pScheduler installation on perfSONAR. It also tries to give an idea of the options available in each and other important details. 

.. note:: This document highlights the list of test types and tools installed by default when installing pScheduler with perfSONAR. It is possible for others to write their own test and tool plug-ins so this list may not be exhaustive of all tests and tools available.

.. _pscheduler_ref_tests_tools-test_types:

Test Types
===========

clock
############
:Description: Measure the clock difference between hosts
:Tools: psclock

disk-to-disk
#################
:Description: Network testing of throughput and Read/Write speeds
:Tools: curl, globus

dns
############
:Description: Measure DNS transaction time
:Tools: dnspy

http
############
:Description: Measure HTTP response time
:Tools: psurl

latency
############
:Description: Measure one-way latency and associated statistics between hosts
:Tools: owping

latencybg
############
:Description: Continuously measure one-way latency and associated statistics between hosts and report back results periodically
:Tools: powstream

rtt
############
:Description: Measure the round trip time and related statistics between hosts 
:Tools: ping

simplestream
############
:Description: Used primarily for testing, sends a simple "HELLO" message between two hosts using TCP
:Tools: simplestreamer

throughput
############
:Description: A test to measure the observed speed of a data transfer and associated statistics between two endpoints
:Tools: iperf3, iperf2, nuttcp

s3throughput
############
:Description: A test to measure the throughput of S3 web service storage
:Tools: s3-benchmark

trace
############
:Description: Trace the path between IP hosts
:Tools: traceroute, tracepath, paris-traceroute

mtu
###########
:Description: Measure Maximum Transmission Unit (MTU)
:Tools: None

.. _pscheduler_ref_tests_tools-test_classifications:

Test Classifications
======================
Each test classified in one of four categories that determines what other tests can be run in parallel:

    #. **Exclusive** - An example is a *throughput* task. If you have very little whitespace in this category then you may have difficulty finding a timeslot for new tests. These test can run in parallel only with background tests.
    #. **Normal** - An example is a task with a test type of *latency*.
    #. **Background Single-Result** - Background tests that produce single result. Example test types include *rtt* and *trace* or *clock*. These tests can run in parallel with anything else.
    #. **Background Multi-Result** - Background tests that produce multiple (streaming) results. Example test type is *latencybg*. It is not uncommon to have this column look almost entirely solid if you have *latencybg* tasks since they run continuously. These tests can run in parallel with anything else.
    #. **Non-Starting** - These are runs that could not find a time-slot. A very important note, and common point of confusion, is that the time shown is the earliest possible time in the slot it was trying to schedule. This IS NOT the time when the scheduler tried to find a slot, failed and labelled it as a non-start. pScheduler uses a :term:`schedule horizon` so likely attempted to schedule the run 24 hours in advance. A large number of runs in this category may be the indication of a busy host where it is difficult for exclusive tasks to find a timeslot.
    #. **Preempted** - These runs were preempted by another with higher priority.
	
You may visualize different types of tests using ``pscheduler plot-schedule`` command. See also :ref:`pscheduler_client_schedule-plot_schedule`.

You can know which scheduling class a test belongs to by running the ``pscheduler plugins tests`` command.
    
throughput Tests
================

Throughput tests support the following arguments::

 pscheduler task throughput --help
 Usage: task [task-options] throughput [test-options]
  -h, --help            show this help message and exit
  -s SOURCE, --source=SOURCE
                        Sending host
  --source-node=SOURCE_NODE
                        pScheduler node on sending host, if different
  -d DESTINATION, --dest=DESTINATION, --destination=DESTINATION
                        Receiving host
  --dest-node=DEST_NODE
                        pScheduler node on receiving host, if different
  -t DURATION, --duration=DURATION
                        Total runtime of test
  -i INTERVAL, --interval=INTERVAL
                        How often to report results (internally, results still reported in aggregate at end)
  -P PARALLEL, --parallel=PARALLEL
                        How many parallel streams to run during the test
  -u, --udp             Use UDP instead of TCP testing
  -b BANDWIDTH, --bandwidth=BANDWIDTH
                        Bandwidth to rate limit the test to, supports SI
                        notation such as 1G
  -w WINDOW_SIZE, --window-size=WINDOW_SIZE
                        TCP window size to use for the test, supports SI notation such as 64M
  -m MSS, --mss=MSS     TCP maximum segment size
  -l BUFFER_LENGTH, --buffer-length=BUFFER_LENGTH
                        length of the buffer to read/write from
  --ip-tos=IP_TOS       IP type-of-service octet (integer)
  --ip-version=IP_VERSION
                        Specify which IP version to use, 4 or 6
  -B LOCAL_ADDRESS, --local-address=LOCAL_ADDRESS
                        Use this as a local address for control and tests
  -O OMIT, --omit=OMIT  Number of seconds to omit from the start of the test
  --no-delay            Set TCP no-delay flag, disables Nagle's algorithm
  --congestion=CONGESTION
                        Set TCP congestion control algorithm
  --zero-copy           Use a 'zero copy' method of sending data
  --flow-label=FLOW_LABEL
                        Set the IPv6 flow label, implies --ip-version 6
  --client-cpu-affinity=CLIENT_CPU_AFFINITY
                        Set's the sending side's CPU affinity
  --server-cpu-affinity=SERVER_CPU_AFFINITY
                        Set's the receiving's side's CPU affinity
  --reverse             Reverses the direction of the test.


The currently supported throughput tools are *iperf2*, *iperf3*, and *nuttcp*. *iperf3* is the default.
Note that not every tool supports every option. The following table summarizes tool specific option.
Other pScheduler options are supported by all tools.

+-------------+-----------+-----------+----------+
| option      | iperf2    | iperf3    | nuttcp   |
+=============+===========+===========+==========+ 
|--omit       |           |   X       |          |
+-------------+-----------+-----------+----------+ 
|--congestion |    X      |   X       |          |
+-------------+-----------+-----------+----------+ 
|--zero-copy  |           |   X       |          |
+-------------+-----------+-----------+----------+ 


latency Tests
==============

Latency tests support the following arguments::

 pscheduler task latency --help
 Usage: task [task-options] latency [test-options]
  -h, --help            show this help message and exit
  -s SOURCE, --source=SOURCE
                        The address of the entity sending packets in this test
  --source-node=SOURCE_NODE
                        The address of the source pScheduler node, if different
  -d DEST, --dest=DEST  The address of the entity receiving packets in this test
  --dest-node=DEST_NODE
                        The address of the destination pScheduler node, if different
  -c PACKET_COUNT, --packet-count=PACKET_COUNT
                        The number of packets to send
  -i PACKET_INTERVAL, --packet-interval=PACKET_INTERVAL
                        The number of seconds to delay between sending packets
  -L PACKET_TIMEOUT, --packet-timeout=PACKET_TIMEOUT
                        The number of seconds to wait before declaring a
                        packet lost
  -p PACKET_PADDING, --packet-padding=PACKET_PADDING
                        The size of padding to add to the packet in bytes
  -C CTRL_PORT, --ctrl-port=CTRL_PORT
                        The port to use for making a control connection to the
                        side acting as a server.
  -P DATA_PORTS, --data-ports=DATA_PORTS
                        The port range to use on the side of the test running
                        the client. At least two ports required.
  -T IP_TOS, --ip-tos=IP_TOS
                        The port range to use on the side of the test running
                        the client. At least two ports required.
  --ip-version=IP_VERSION
                        Force an IP version when performing the test. Useful
                        when specifying hostnames as source or dest that may
                        map to both IPv4 and IPv6 addresses.
  -b BUCKET_WIDTH, --bucket-width=BUCKET_WIDTH
                        The bin size to use for histogram calculations. This
                        value is divided into the result as reported in
                        seconds and truncated to the nearest 2 decimal places.
  -f, --flip            In multi-participant mode, have the dest start the
                        client and request a reverse test. Useful in some
                        firewall and NAT environments.
  -R, --output-raw      Output individual packet statistics. This will
                        substantially increase the size of a successful
                        result.

The currently supported latency tools are *owping* (used by default) and *twping*.  When using *twping* the destination (``-d``) can be any network device acting as a TWAMP Server and Session-Reflector, see `RFC-5357 <https://tools.ietf.org/html/rfc5357>`_ for more details (TWAMP Light is currently not supported by perfSONAR).

rtt Tests
=====================

RTT tests support the following arguments::

 pscheduler task rtt --help
 Usage: task [task-options] rtt [test-options]
 -h, --help            show this help message and exit
  -c COUNT, --count=COUNT
                        Test count
  -d DEST, --dest=DEST  Destination host
  --flow-label=FLOW_LABEL
                        Flow label
  --fragment            Allow packet fragmentation
  --no-fragment         Don't allow packet fragmentation
  --hostnames           Look up hostnames from IPs
  --no-hostnames        Don't look up hostnames from IPs
  -i INTERVAL, --interval=INTERVAL
                        Time to wait between packets sent
  --ip-version=IP_VERSION
                        IP version to use
  -s SOURCE, --source=SOURCE
                        Source address or interface
  --source-node=SOURCE_NODE
                        Source pScheduler node, if different
  --suppress-loopback   Suppress multicast loopback
  --no-suppress-loopback
                        Don't suppress multicast loopback
  --ip-tos=IP_TOS       IP type-of-service octet (integer)
  --length=LENGTH       Packet length
  --ttl=TTL             Time to live
  --deadline=DEADLINE   Deadline for all measurements to complete
  --timeout=TIMEOUT     Timeout for each round trip
  --protocol=PROTOCOL   Protocol used to measure round trip time


The currently 2 supported protocols for RTT measurements are ``icmp`` and ``twamp``.  When using `twamp` you need to make sure that the destination (``-d``) is a TWAMP Server and Session-Reflector, see `RFC-5357 <https://tools.ietf.org/html/rfc5357>`_ for more details (TWAMP Light is currently not supported by perfSONAR).

trace Tests
===========

Trace tests support the following arguments::

  pscheduler task trace --help
  Usage: task [task-options] trace [test-options]

  -h, --help                  show this help message and exit
  --algorithm=ALGORITHM       Trace algorithm
  --as                        Find AS for each hop
  --no-as                     Don't find AS for each hop
  -d DEST, --dest=DEST        Destination host
  --ip-version=IPVERSION      IP Version
  --length=LENGTH             Packet length
  --probe-type=PROBETYPE      Probe type
  --fragment                  Allow fragmentation
  --no-fragment               Don't allow fragmentation
  --first-ttl=FIRSTTTL        First TTL value
  -s SOURCE, --source=SOURCE  Source address
  --source-node=SOURCE_NODE   Source address
  --hops=HOPS                 Maximum number of hops
  --queries=QUERIES           Queries sent per hop
  --hostnames                 Resolve IPs to host names
  --no-hostnames              Don't resolve IPs to host names
  --dest-port=DESTPORT        Destination port
  --wait=WAIT                 Wait time
  --sendwait=SENDWAIT         Wait time between probes
  --ip-tos=IP_TOS             IP type-of-service octet (integer)

The currently supported trace tools are *traceroute*, *tracepath*, *paris-traceroute*. *traceroute* is the default.

.. note:: Please note that if you have a server that has more then one network interface the *tracepath* tool does not provide an option to select the outgoing source interface.

http Tests
==========

HTTP tests support the following arguments::

  pscheduler task http --help
  Usage: task [task-options] http [test-options]
  
  -h, --help             show this help message and exit
  --url=URL              URL to query
  --parse=PARSE          String to parse for
  --host=HOST            Host to run the test
  --host-node=HOST_NODE  Host to run the test
  --timeout=TIMEOUT      Timeout for each query attempt
  
dns Tests
==========

DNS tests support the following arguments::

  pscheduler task dns --help
  Usage: task [task-options] dns [test-options]
  
  -h, --help               show this help message and exit
  --host=HOST              Host to run the test
  --host-node=HOST_NODE    Host to run the test
  --nameserver=NAMESERVER  Nameserver to query
  --record=RECORD          Record type to query  (One of a, aaaa, ns, cname, soa, ptr, mx and txt)
  --query=QUERY            String to query
  --timeout=TIMEOUT        Timeout for each query attempt

mtu Tests
==========

MTU tests support the following arguments::

  pscheduler task mtu --help
  Usage: task [task-options] mtu [test-options]

  -h, --help            show this help message and exit
  --source=SOURCE       Sending host  --source-node=SOURCE_NODE
                        pScheduler node on sending host, if different
  --dest=DEST           Receiving host
  --port=PORT           Receiving port. Defaults to 1060.

You may have to add a firewall rule for port 1060 for this test to function properly::

  firewall-cmd --zone=public --add-port=1060/tcp --permanent
