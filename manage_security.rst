*******************************
Firewalls and Security Software
*******************************

The perfSONAR Toolkit utilizes a number of tools the help protect against attacks on the system. Some of these tools include:
 
    * A default set of iptables and ip6tables (or firewalld for CentOS7) rules that only allow connections to ports required by perfSONAR tools.
    * Inclusion of the `fail2ban`_ intrusion detection system (IDS) to log suspicious activity such as brute-force SSH attacks

None of these solutions will protect your host from all kinds of attacks so best common practices and good sense should be used when administering your host. In addition to tools like above it's important :doc:`update your host <manage_update>` with the latest packages and to watch the `mailing lists <http://www.perfsonar.net/about/getting-help/>`_ for important security announcements. 


.. _manage_security-firewall:

Default Firewall Rules and perfSONAR port requirements
======================================================
The perfSONAR Toolkit uses *iptables* and *ip6tables* to implement IPv4 and IPv6 firewall rules respectively. The default configurations for each in */etc/sysconfig/iptables* and */etc/sysconfig/ip6tables*. Also see /usr/lib/firewalld/services and /etc/perfsonar/toolkit/perfsonar_firewalld_settings.conf for rules on CentOS7. 

perfSONAR uses the following ports:

+------------------------------------------+
| perfSONAR Tools Ports                    | 
+------------+----------------+------------+
| Tool       | TCP ports      | UDP Ports  |
+============+================+============+
| owamp      | 861            | 8760-9960  |
+------------+----------------+------------+
| twamp      | 862            | 18760-19960|
+------------+----------------+------------+
| pscheduler | 443            |            |
+------------+----------------+------------+
| iperf3     | 5201           |            |
+------------+----------------+------------+
| iperf2     | 5001           |            |
+------------+----------------+------------+
| nuttcp     | 5000, 5101     |            |
+------------+----------------+------------+
| traceroute |                | 33434-33634|
+------------+----------------+------------+
|simplestream| 5890-5900      |            |
+------------+----------------+------------+
| ntp*       |                | 123        |
+------------+----------------+------------+
| bwctl*     |4823, 5001-5900,| 5001-5900, | 
|            | 6001-6200      | 6001-6200  | 
+------------+----------------+------------+

**Notes**: 

* The NTP and BWCTL tools are deprecated but their ports are left open for those wishing to run them.
* ICMP also needs to be open
* The NTP and BWCTL tools are deprecated but their ports are left open for those wishing to run them.
* simplestream is used for pscheduler testing and troubleshooting

+--------------------------------------+
| perfSONAR Toolkit Ports              | 
+-----------------------+--------------+
| Tool                  | TCP ports    |
+=======================+==============+
| management interface  | 80, 443      +   
+-----------------------+--------------+
| esmond                | 80, 443      +   
+-----------------------+--------------+
| Lookup Service        | 8090         +   
+-----------------------+--------------+

.. _manage_security-custom:

Adding Your Own Firewall Rules
==============================
For operating systems using iptables, the rules added by the perfSONAR Toolkit are contained within a special perfSONAR chain of iptables (and ip6tables). You may add rules to the other chains, such as the INPUT chain, just as you would any other firewall rule. It is NOT recommended you change the perfSONAR chain as any changes you make could be overwritten by a software update. 

For operating systems using firewalld (e.g. CentOS 7) it organizes the rules into "zones" and makes it more difficult to distinguish perfSONAR rules from custom rules. If you add a standard service to the zone it will get overwritten next time *perfsonar-toolkit-security* upgrades. We recommend looking at firewalld `rich rules <https://fedoraproject.org/wiki/Features/FirewalldRichLanguage>`_ for adding custom rules.

For more information see:

- https://wiki.centos.org/HowTos/Network/IPTables
- http://www.firewalld.org/documentation/


.. _manage_security-fail2ban:

Fail2ban Intrusion Detection System
====================================
By default the perfSONAR Toolkit installs and configures the `fail2ban`_ Intrusion Detection System (IDS). This software will log suspicious activity such as a rapid succession of failed SSH login attempts in */var/log/secure*. By default it will not act to mitigate any attempts, only log them (though the default IP table rules do SSH throttling). If you would like to change this default behavior to send email or block unwanted intrusions, see the configuration file */etc/fail2ban/jail.conf* and the `fail2ban manual`_ for details.

.. _fail2ban: http://www.fail2ban.org
.. _fail2ban manual: http://www.fail2ban.org/wiki/index.php/MANUAL_0_8

.. _manage_security-ren:

Limiting tests to Research and Education Networks Only
======================================================

ESnet provides a file containing all R&E subnets, which is updated nightly. Instructions on how to download this file and configure pScheduler to use it are described on the page :doc:`manage_limits`.

Managing Login Access
======================
perfSONAR nodes are meant to be used, both by local users and the public at large, to perform a variety of network tests.  The open access policy is at odds with ways to mitigate the risk of exposing functionality to those that would cause harm.  The following is a possible approach for managing access to the host:

- SSHD can be turned off completely if remote access to the machine via the terminal is not need (e.g. in cases where console access is available either directly, or indirectly)

- If SSHD is turned on, consider using a jump host setup wherein access to the perfSONAR node can only be accomplished through a single (or set) of trusted hosts.  This type of restriction can be implemented in IPTables. 


NTAC Performance Working Group Statement
========================================
The NTAC Performance Working Group has published a document related to deploying perfSONAR while still justifying cybersecurity policy.  This document can be found here:

- https://www.perfsonar.net/media/cms_page_media/1256/20141110-Firewall-PerfWG.pdf

