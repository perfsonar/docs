*******************************************************
Detailed Information on perfSONAR Hardware Requirements 
*******************************************************

A core port of the perfSONAR philosophy is test isolation: only one test should run on the host at a time. This
ensures that test results are not impacted by other tests. Otherwise it is much more difficult to interpret test results, which may vary due to host effects rather then network effects. For this reason, the heart of perfSONAR is the tool 'pscheduler' (formerly bwctl), which is designed to carefully schedule one test at a time.

This means you should not run perfSONAR tools on a host running a web server, a data server, or on a virtual machine, because in all of these cases it is not possible to guarantee test isolation.

As long as you have two or more cores, it is now safe to run a database, a.k.a. the perfSONAR Measurement Archive (MA), on the perfSONAR host. Inserts and queries to the database appear to have no impact on test results. Its also OK to run latency/loss tests (owamp) on one NIC, and throughput tests (iperf3/nuttcp) on a second NIC, without noticeable impact on the results. For more information on configuring a perfSONAR host for two NICs, see: http://docs.perfsonar.net/manage_dual_xface.html

Note: Running both owamp and iperf at the same time on the same NIC is a problem, and should be avoided. 
iperf tests will often cause owamp to lose packets when running on the same NIC.



