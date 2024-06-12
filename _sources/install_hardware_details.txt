:orphan:

*******************************************************
Detailed Information on perfSONAR Hardware Requirements 
*******************************************************

A core port of the perfSONAR philosophy is test isolation: only one test should run on the host at a time. This
ensures that test results are not impacted by other tests. Otherwise it is much more difficult to interpret test results, which may vary due to host effects rather then network effects. For this reason, the heart of perfSONAR is the tool *pScheduler*, which is designed to carefully schedule one test at a time.

perfSONAR measurement tools are much more accurate running on dedicated hardware. While it may be useful to run them on other hosts such as Data Transfer Nodes as well, the development team recommends a specific measurement machine (or machines).  This will ensure the local operations staff, users, and the community at large, can rely on and use the measurement resource to the fullest extent. 

This means you should not run perfSONAR tools on a host running a web server, a data server, or on a virtual machine, because in all of these cases it is not possible to guarantee test isolation.

As long as you have two or more cores, it is now safe to run a database, a.k.a. the perfSONAR Measurement Archive (MA), on the perfSONAR host. Inserts and queries to the database appear to have no impact on test results. Its also OK to run latency/loss tests (owamp) on one NIC, and throughput tests (iperf3/nuttcp) on a second NIC, without noticeable impact on the results. For more information on configuring a perfSONAR host for two NICs, see: http://docs.perfsonar.net/manage_dual_xface.html

Note: Running both owamp and iperf at the same time on the same NIC is a problem, and should be avoided. 
iperf tests will often cause owamp to lose packets when running on the same NIC.


Processor
---------
The perfSONAR Toolkit is designed and tested for both the x86 and x86_64 architectures.  Use on other architectures (e.g. ARM) is not currently supported by the development team.  Efforts are underway by community members to explore creating a low-cost test infrastructure. 

A system containing a single CPU with multiple cores is sufficient for perfSONAR Toolkit operation. Multi-CPU setups will still function, but may introduce variability into the measurement process unless proper care is taken to bind applications to a given CPU/Core. There are three intense operations that occur on a perfSONAR Toolkit:

- **Measurement**: The act of performing any measurement (particularly something intense like a throughput test) will require almost complete access to a processor or core

- **Storage**: The perfSONAR Toolkit Measurement Archive (a combination of a NoSQL and SQL database) stores the result of each regular test, and also responds to queries from local and remote services for data retrieval

- **Graphical Front End**: Powering the web server, and fetching data for remote rendering of data, is the responsibility of the server

User's that choose to forgo some of these functions (e.g. a Bundle that does not feature a web interface, or measurement archive) will not need as much hardware support. 
 
Clock speed is a factor if the system will be used for throughput testing, as the operation is resource intensive.  Clock speeds of at least 2.7 Ghz are required to support TCP tests at speeds of 10Gbps, and more (3Ghz or greater) for UDP.  Note that for single stream operation, only a single CPU/Core is used, but multiple streams can consume more resources.  

If the target use case for the system is lower speed throughput (e.g. 1Gbps or less), or latency testing, the Intel Atom processor has been shown to work. 
 
Motherboard
-----------
Choice of motherboard matters greatly if the machine will be used for 10Gbps (or greater) throughput testing, and is heavily dependent on the choice of network interface card.  For these use cases, it is recommended an Intel Ivy Bridge or Sandy Bridge be used, as these are known to support version 3 of the PCI specification.  It is also recommended that the number of required PCI lanes for the target NIC be verified, to be sure that there will be enough bandwidth available between the motherboard and the daughter card. 

For less resource intensive applications such as latency testing, choose a motherboard that is known to work with the processor family you are employing, and features enough peripheral slots to support the use case. 

RAM
---

The development team recommends a minimum of 4GB of volatile memory on all systems running the full installation of the perfSONAR Toolkit.  There are three intense operations that occur on a perfSONAR Toolkit that require the support of memory:

User's that choose to forgo some of these functions (e.g. a Bundle that does not feature a web interface, or measurement archive) will not need as much memory support. The recommended amount of memory for the toolkit (4GB) will ensure proper concurrent operation of all measurement tools, web services, and supporting products such as databases. 

Nodes that only run the *testpoint* bundle may work with as little as 2GB of memory, although the project recommends at least 4GB to ensure proper operation. 
 
Nodes that will be used as a central repository for the measurements from a number of beacons are recommended to have as much memory as possible (e.g. greater than 16GB is recommended). 

Local Storage
-------------

Local storage choices are a function of the machine's use case.  If the machine will not be storing any data (e.g. if it is not running a Measurement Archive), it can function without local storage (e.g. netbooting, or booting off of a CD or USB device).  If the machine will be storing measurement data, it is recommended that a minimum of 100GB of space be made available.  As a default behavior, the perfSONAR toolkit will not clean out stored measurements, and these will build up until the user makes the choice to clean databases.

Network Interface Card
----------------------

The choice of network interface card is highly dependent on the use case.  Latency machines do not require high amounts of bandwidth, and work well using 1Gbps capable hardware.  Throughput testing works best when a higher speed (10Gbps or greater) is available, but will function well at lower speeds. 

The perfSONAR Toolkit will operate with a given NIC provided there are drivers available from the CentOS project or the vendor.  It is suggested that before buying a NIC that operators consult with CentOS or Vendor documentation to judge the level of support, or ask the  list to see if there is any community experience.

If you are trying to do 10G data transfers on your network, it's best to have 10G perfSONAR hosts. However, be careful when testing from a 10G network to a 1G network, to ensure your test traffic does not impact the slower network. The use of lower capacity NICs can introduce unintended behavior into the operation of the measurement tools.  

**Onboard NIC**

The onboard NIC functions best as a "management" port instead of a measurement port.  This being said, there are use cases that can be supported by onboard NIC technology. 

Typical motherboards have available 1000BaseT ports as a standard option.  These ports are reasonable for both latency and bandwidth (1Gbps max) testing.  Known issues include the introduction of Jitter into latency measurements due to the sharing of system resources (e.g. common communication bus for traffic coming off of the Disk, NIC, or other peripherals). 

10GBase ports are less standard, but available on certain types of motherboards.  In testing it has been shown that a similar problem of system resource contention (e.g. sharing a system communications network with peripherals) can cause measurement abnormalities.  10GBase works best as a daughter board, where it can utilize the higher PCI communications system to support high speed throughput testing. 

**PCI-slot NIC**

The primary concern when purchasing daughter board NICs is to evaluate that the slot on the motherboard will support the NIC specification.  Many 10GBase NIC cards require several "lanes" (e.g. a rating such as x4, or x8) of a PCI slot.  Consult the motherboard documentation to be sure the slot you are targeting can support this amount of bandwidth.  Using a slot that does not have enough lanes wired will result in lower than expected throughput.  

40G/100G cards require a higher number of lanes (e.g. x16 in some cases) as well as support for the PCI 3.0 specification.  This is often only available in newer motherboards (Intel Sandy/Ivy Bridge).  Lack of support for these items may result in poor performance


