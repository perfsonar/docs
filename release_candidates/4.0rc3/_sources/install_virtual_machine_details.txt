******************************************************
Detailed Information on perfSONAR on Virtual Machines 
******************************************************

The paradigm of virtualized hosting environments is attractive in modern networks. However, virtualization can call into question the accuracy and stability of measurements, particularly those that are sensitive to environmental considerations on a host or operating system. perfSONAR was designed to "level the playing field" when it comes to network measurements, by removing host performance from the equation as much as possible.  The use of virtualized environments can introduce unforeseen complications into the act of measurement, which may call into question the accuracy of results. 

Note that any measurement tool (e.g. OWAMP, iperf3, etc.) would need to pass through an additional two layers of control (Hypervisor and Virtual Hardware) before touching the physical network in this example. These additional layers impart several challenges:

- **Time Keeping**: Some virtualization environments implement clock management as a function of the hypervisor and virtual machine communication channel, rather than using a stabilizing daemon such as NTP. This could mean time skips forward, or backward, and is generally unpredictable for measurement use

- **Data Path**: Network packets are timed from when they leave the application on one end, till their arrival in the application on the other end. The additional layers add additional latency, queuing, and potentially packet ordering and errors, to the end calculation

- **Resource Management**: Virtual machines share the physical hardware with other resources, and may be removed ("swapped") from physical hardware to allow other virtual machines to run as needed. This exercise of swapping virtual resources could impart additional error measurement values that may only be seen if a long term view of data is established and matched against virtualized environment performance. 

The perfSONAR Toolkit development team has analyzed several VM architectures (VM Ware, KVM, QEMU) and has found that the basic problems listed above exist to a certain degree in all implementations. It is possible that small improvements will be made in all implementations over time, and tuning of individual systems may produce gains for some use cases.  The development team has found several use cases that can work in a virtualized environment, provided that the user has applied certain configurations to mitigate the known risks:

- **Measurement Storage**: A virtual machine makes a good centrailized home for data collected from multiple bare metal beacon hosts.  Note that this VM should be provisioned with several cores and adaquate RAM and storage to function in this role. 

- **Throughput Measurement**: Ideally the virtual machine that is performing throughput tests have direct control over a network card.  Failure to do so will result in unpredictable results when compared against actual hardware tests. 

- **Passive Measurement**: Passive collection tools such as SNMP, NAGIOS, Netflow, and sFlow work well in virtualized environments. Considerations for hypervisor resource management should be explored, but are not as vital as in the active testing case.

- **Packet Loss/Jitter Measurement**: A tool that uses active methods to measure packet loss and jitter, such as OWAMP, can function in a virtualized environment, provided care is taken to ensure that the hypervisor provides dedicated resources for this host as well (e.g. binding to a specific CPU and Network Card). 

We have found that virtualized environments do not work well for other forms of measurement:

- **High Speed Throughput Measurement**: Virtualize environments can function well at 1Gbps network speeds, but may struggle to higher (e.g. 10Gbps) capacities. Please consult the operations guide to your specific virtualization environment before attempting this type of measurement.

To summarize, it is possible to use virtualized environments provided that care is taken to tune them to provide a stable footing for the measurement tools. Bare metal servers are still recommended for mission critical applications.

