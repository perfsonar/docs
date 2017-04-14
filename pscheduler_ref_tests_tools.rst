******************************
Test and Tool Reference
******************************

Page should contain at least the following:

    * For each tool type:
    
        * Description of tool
        * Supported/Unsupported options
        * Any special notes

Throughput Tools
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
|--fq-rate    |           |   X       |          |
|(coming soon)|           |           |          |
+-------------+-----------+-----------+----------+ 


Latency Tools
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

Round Trip Time Tools
=====================

RTT tests support the following arguments::

 pscheduler task rtt --help
 Usage: task [task-options] rtt [test-options]
  -h, --help            show this help message and exit
  --count=COUNT         Test count
  --dest=DEST           Destination host
  --flow-label=FLOW_LABEL
                        Flow label
  --hostnames           Look up hostnames from IPs
  --no-hostnames        Don't look up hostnames from IPs
  --interval=INTERVAL   Time to wait between packets sent
  --ip-version=IP_VERSION
                        IP version to use
  --source=SOURCE       Source address or interface
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

