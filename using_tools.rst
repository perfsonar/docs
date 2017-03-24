*****************************************
Overview of perfSONAR Network Test Tools
*****************************************

perfSONAR includes a number of network test and measurement tools.

These include:

- owamp_
- iperf3_
- iperf2_
- nuttcp_
- traceroute_
- tracepath_
- paris-traceroute_
- ping_
- bwctl_  (Note: bwctl will be deprecated in the next release)

.. _owamp: http://software.internet2.edu/owamp
.. _iperf3: http://software.es.net/iperf
.. _iperf2: https://sourceforge.net/projects/iperf2/
.. _nuttcp: https://fasterdata.es.net/performance-testing/network-troubleshooting-tools/nuttcp/
.. _traceroute: https://linux.die.net/man/8/traceroute
.. _tracepath: https://linux.die.net/man/8/tracepath
.. _paris-traceroute: http://manpages.ubuntu.com/manpages/trusty/man8/paris-traceroute.8.html
.. _ping: https://linux.die.net/man/8/ping
.. _bwctl: http://software.internet2.edu/bwctl/bwctl.man.html


These tools can all be run using *pscheduler*, as described in the :doc:`using_pscheduler`.

Note that *owamp* and *pscheduler* require your host clock to be synchronized via NTP. 
Traditionally this has been done using ntpd, and can easily 
be configured using the perfsonar-toolkit-ntp package, as described at :doc:`install_centos`.

Another NTP option is to use 
`chrony <https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/sect-Using_chrony.html>`_,
which should work fine as well.

crony is now installed by default on CentOS7/RHEL7, and is also available for Debian.

Note that you can not run both ntpd and chrony at the same time, so be sure to disable chrony on any RHEL7-based host if
you want to run the perfsonar-toolkit-ntp package.


