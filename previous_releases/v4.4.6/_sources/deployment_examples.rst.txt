*****************************
perfSONAR Deployment Examples
*****************************

ESnet perfSONAR Deployment
==========================

ESnet maintains throughput and latency test hosts at ESnet points of presence (PoPs) as well as test hosts connected to the ESnet routers at many Department of Energy facilities. The primary perfSONAR services ESnet provides are throughput testing (via iperf3) and delay/loss testing (via OWAMP). Additional information can be found here: http://fasterdata.es.net/performance-testing/perfsonar/esnet-perfsonar-services/

Machine Connectivity and Configuration
--------------------------------------

ESnet utilizes a "combined" host that runs loss, latency, and traceroute tests on a 1G NIC, and throughput tests on the 10G NIC.
These hosts have the following configuration:

* Super X10SL7-F Motherboard
* 1 Intel Xeon E3-1275 v3 3.5GHz (Turbo 3.9GHz) Quad Cores
* 32GB DDRIII 1600 ECC Only Certified Memory
* Intel X520-SR2 10GB Dual SFP+ with Dual Optics
* Seagate 1TB SAS 6GB/s, 7200RPM ST1000NM002

Delay and loss testing with OWAMP
---------------------------------

ESnet OWAMP testers at the ESnet PoPs and sites provide the ability to measure one-way delay and packet loss on the ESnet network, and between other OWAMP test hosts and ESnet test hosts. ESnet maintains a set of logically-grouped OWAMP test results on the `ESnet perfSONAR dashboard <http://ps-dashboard.es.net/>`_.

The list of current ESnet OWAMP test hosts can be found in one of two ways:

* We maintain a static list of `ESnet OWAMP hosts <http://fasterdata.es.net/performance-testing/perfsonar/esnet-perfsonar-services/esnet-owamp-hosts/>`_
* The list of OWAMP servers in the `perfSONAR Lookup Service <http://stats.es.net/ServicesDirectory/>`_ is updated dynamically

Throughput testing with iperf3
--------------------------------


ESnet throughput testers at the ESnet PoPs and sites provide the ability to measure throughput between locations on the ESnet network, and between other throughput test hosts and ESnet test hosts. ESnet maintains a set of logically-grouped throughput test results on the `ESnet perfSONAR dashboard <http://ps-dashboard.es.net/>`_.

The list of current ESnet throughput test hosts can be found in one of two ways:

* We maintain a static list of `ESnet test hosts <http://fasterdata.es.net/performance-testing/perfsonar/esnet-perfsonar-services/esnet-iperf-hosts/>`_
* The list of pScheduler servers in the `perfSONAR Lookup Service <http://stats.es.net/ServicesDirectory/>`_ is updated dynamically

ESnet's pScheduler limits configuration
----------------------------------------

ESnet permits tests to ESnet throughput testers from any ESnet site, and from any scientific or research institution that is connected to the global research and education network infrastructure. This includes US laboratories and universities, as well as research laboratories and universities in Africa, Asia, Australia, Europe, and Latin America. 
This is accomplished by including the global R&E routing table (the set of IP prefixes accessible via peerings with R&E networks) 
via the :doc:`manage_limits` mechanism.
Other logical groups of addresses such as Amazon Cloud services are added to the file from time to time as the needs of the scientific community evolve. 
`This page <http://fasterdata.es.net/performance-testing/perfsonar/esnet-perfsonar-services/esnet-limits-file/>`_ has more details.

Managing local packet filters
-----------------------------

If your site uses router ACLs, the ESnet subnet listing can be found here:  http://fasterdata.es.net/performance-testing/perfsonar/esnet-perfsonar-services/esnet-subnet-filters/


Internet2 AL2S and AL3S Monitoring
==================================

Internet2 maintains a set of performance test nodes for performance assurance on the AL2S and AL3S networks. 

Host Configuration
------------------

The following is the hardware configuration for Internet2 perfSONAR nodes:

* Dell R720 Chassis, DC enabled PDU
* 8 GB of RAM
* 2 x Intel E5-2609 CPU @ 2.4 Ghz clock speed; 4 cores per CPU; HyperThreading disabled.
* Dell motherboard, Intel C600 Chipset
* 146GB RAID-1 disk
* Dual port 10GBASE-SR Broadcom NetXtreme II BCM57800 (x8 PCIe 2.0) NIC directly connected to the AL2S networking components

The following describes the operating software of the Internet2 perfSONAR nodes:

* RedHat Enterprise Linux version 6, 64-bit Architecture
* GlobalNOC custom configuration management framework
* ESNet's fasterdata linux tuning recommendations: http://fasterdata.es.net/host-tuning/linux/

Measurement configurations to build and maintain the testing mesh are created by querying the OESS service, re-generating necessary files, and pushing them to resources via the management framework. 

Network Configuration
---------------------

End hosts are configured to pass traffic on existing AL2S VLANs as managed by OESS, and do not change dynamically.  There is no QoS policy on these links, meaning bandwidth is not managed or shaped. 

The network expectations are that the test hosts will also achieve at least 9Gbps of UDP traffic for the 100Gbps capacity links.  Alarms are configured to alert when this drops below a threshold of 8Gbps, indicating a network problem such as gradual performance degradation or congestion.

UDP bandwidth measurements are used in an effort to decouple end host effects from network performance – the goal of the PAS is to ensure the network is delivering desired performance levels.  Hosts were specifically tuned and tested to ensure maximum UDP performance could be achieved.  Future directions of the PAS may include end-host focused testing, including TCP throughput.

More Information
----------------

The Internet2 dashboard can be found at the following location: https://pas.net.internet2.edu

Additional documentation on Internet2’s Performance Assurance Service can be found here http://www.internet2.edu/products-services/performance-analytics/performance-assurance-service/


Network Startup Resource Center (NSRC) Servers
==============================================

The NSRC group routinely deploys perfSONAR hardware in emerging networks around the world and has tested two configurations.  The first retails for ~$700 USD and was assembled at ServersDirect.  This setup is for a 1G host, but can support a 10G daughter card:

* Supermicro SNK­P0046P 1U Passive­Heatsink for LGA1156 CPU­­FN4063
* Intel Pentium G3420 3.2Ghz Dual Core ­ CM8064601482522
* Micron M600 128GB SATA 2.5" SSD MLC MTFDDAK128MBF­1AN12ABYY
* SUPERMICRO X10SLL­F Soc1150 C222 2xGbE PCIe3.0 32GB DDR3
* Supermicro RSC­RR1U­E16 1U PCI­e Riser Card with PCI­E x16 output
* Supermicro CSE­510­203B 1U rack 2x 2.5" Hot­swap 1x FH 200W ­­CS8634
* Crucial CT102472BA160B Memory 8GB DDR3 1600 ECC 1.5v Dual Rank
* Supermicro MCP­220­00044­0N Dual 2.5" fixed HDD bracket

The second retails for ~$1100 and comes with a 10G card:

* Supermicro CSE­510­203B 1U rack 2x 2.5" Hot­swap 1x FH 200W ­­CS8634
* Intel CM8064601482522 Pentium G3420 Tray Processor LGA1150 3.2GHz 3MB Cache Dual Core DDR3 Up to 1600MHz
* Supermicro SNK­P0046P 1U Passive­Heatsink for LGA1156 CPU­­FN4063
* Micron MTFDDAK128MBF­1AN12ABYY SSD M600 128GB SATA MLC 2.5" 7mm 6Gb/s AES­ 256 Encryption
* Supermicro MCP­220­00044­0N Dual 2.5" fixed HDD bracket
* Crucial CT102472BA160B Memory 8GB DDR3 1600 ECC 1.5v Dual Rank
* Supermicro X10SLL­F Motherboard Single E3­1200 v3 LGA1150 C222 4xDIMM 32GB DDR3 1600MHz 3xPCI­E 6xSATA 2xGbE
* Supermicro RSC­RR1U­E16 1U PCI­e Riser Card with PCI­E x16 output
* Intel E10G42BTDA Network Adapter X520­DA2 Dual Port 10Gb/s SFP+

Network Startup Resource Center (NSRC) Low Cost Nodes
=====================================================

The following information was researched in November of 2015 and relates to the Intel NUC DN2820FYKH.  Note that changing hardware specifications may make this information obsolete, it is provided as a potential deployment scenario only.  Cost was approximately $150 USD at the time of specification for a bare machine.  The purchase of a 2.5" hard drive and DDR3L SO-DIMM RAM (suggested 4GB - 8GB) will also be required for full functionality, and will cost extra.    These boxes have a dual-core processor at 2.17GHz (spec says DN2820, but /proc/cpuinfo says DN2830), and they claim to support VT-x virtualization.  Similarly, the Gigabyte Brix GB-BXBT-280 is comparable: Celeron N2807, 1.58GHz.

Procedures
----------

* upgraded the BIOS to the latest currently available (0052)
* In the BIOS settings set "Dynamic Power Technology" to "Off" to minimize jitter, and "After Power Failure" to "Power On"
* perform perfSONAR Toolkit installation via burning the netinstall image to a USB key

Performance
-----------

Performance-wise, these have been shown to reach near gigabit speeds: using a direct connection between two NUCs, iperf3 gave 942Mbps (which is the theoretical maximum, once you take into account IP and ethernet headers). At the sending side, top shows about 38% CPU used by iperf3, and 76% idle. At the receiving side, this falls to 26% for iperf3 and 90% idle.

Pros
~~~~
* standard Intel hardware and perfsonar install
* very compact
* easy to open
* takes standard 2.5" drive
* plugs supplied for UK, US, Europe and Australia
* wifi included, should you wish to test network performance over wifi

Cons
~~~~
* not rackmount; separate wall wart; does not plug into IEC power strip
* if the HDMI cable is disconnected, the screen remains blank when you plug it back in (rebooting solves this problem - but it could be a physical security hazard)
* they have been around for a couple of years, and could be withdrawn at any time

GÉANT Low Cost Nodes
====================

GÉANT enabled users to have first-hand experience on running a perfSONAR node on a small PC and introduced perfSONAR on low cost hardware to build such perfSONAR network measurement platform in Europe. It was completed by distributing pre-configured perfSONAR nodes, running on small devices and making them a part of a GÉANT maintained measurement mesh. The platform was BRIX BACE-3150 devices with 1Gb Eth interface, 120 GB SSD drives and 8 GB RAM costing about 200 Euros each. These boxes have Intel Celeron 1.6GHz with 4 cores.

Configuration
-------------
* A master node was created with predefined configuration of CentOS 6 with perfSONAR 3.5.1 Toolkit (netinstall)
    * Administrative accounts created
    * root login disabled
    * Initial networking with DHCP
    * SNMP deamon running with configured community
    * auto-updates enabled
    * perfSONAR communities preconfigured
* A master node was cloned with Clonezilla to all other mini-PCs which were distributed among users
* This setup was centrally managed with a central server provided by the project
* Measurements were scheduled from the small nodes to a set of 4 GÉANT MPs (for latency and throughput, for IPv4 and IPv6)
* Users were able to configure their own tests
* The central server was running a MaDDash instance
* MRTG monitoring of the central server was configured to follow on resources usage


Observations
------------
* Used standard Intel hardware and perfSONAR install
* Very compact platform able to run without display and keyboard attached
* The process of preparing pre-configured image which is then cloned to small nodes found very effective and largely contributed to the fast preparation of the whole infrastructure and the easy deployment of ready-to-work nodes
* Tests shown it successfully supported active tests with maximum throughput equal to theoretical maximum of 1Gb Ethernet interface
* When placed in a controlled environment (e.g. telecommunication room) small nodes were also performing well in keeping NTP stable


100G Configuration
==================

The following information was researched and tested in October of 2016 to test 100G perfSONAR. Testing revealed that CentOS 7 with fair queing performed the best:

* SMCi X10DRi Motherboard
* 2 x Intel Xeon Haswell E5-2643V3 3.4GHz 6 Cores (Total 12 Threads each)
* On Board Dual 10/100/1000 NIC
* 8 x 16GB DDR4-2133MHz RAM ECC/REG (128GB total)
* 2 x 480GB SSD Data Center M510DC Drives
* 846BA-R1K28B 4U chassis with Dual 1280W P/S (24 x 3.5" Bays SAS/SATA)
* Mellanox MCX455A-ECAT 100Gbps NIC
