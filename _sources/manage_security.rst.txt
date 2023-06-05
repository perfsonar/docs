*******************************
Firewalls and Security Software
*******************************

The perfSONAR Toolkit utilizes a number of tools the help protect against attacks on the system. Some of these tools include:
 
    * A default set of *iptables* and *ip6tables* (for CentOS6) or *firewalld* (for CentOS7) rules that only allow connections to ports required by perfSONAR tools.
    * Inclusion of the `fail2ban`_ intrusion detection system (IDS) to log suspicious activity such as brute-force SSH attacks

None of these solutions will protect your host from all kinds of attacks so best common practices and good sense should be used when administering your host. In addition to tools like above it's important :doc:`update your host <manage_update>` with the latest packages and to watch the `mailing lists <http://www.perfsonar.net/about/getting-help/>`_ for important security announcements. 


.. _manage_security-firewall:

Default Firewall Rules and perfSONAR port requirements
======================================================
The perfSONAR Toolkit uses *iptables* and *ip6tables* to implement IPv4 and IPv6 firewall rules respectively. The default configurations for *iptabel* are in ``/etc/sysconfig/iptables`` and ``/etc/sysconfig/ip6tables``. Also see ``/usr/lib/firewalld/services`` and ``/etc/perfsonar/toolkit/perfsonar_firewalld_settings.conf`` for *firewalld* settings on CentOS7.

The current perfSONAR release uses the following ports (used by a Tool when requesting a test. See also :doc:`pscheduler_ref_tests_tools`) by default:

+--------------------------------------------+
| perfSONAR Tools Ports                      | 
+-----------------+-------------+------------+
| Tool            | TCP ports   | UDP Ports  |
+=================+=============+============+
| owamp (control) | 861         |            |
+-----------------+-------------+------------+
| owamp (test)    |             | 8760-9960  |
+-----------------+-------------+------------+
| twamp (control) | 862         |            |
+-----------------+-------------+------------+
| twamp (test)    |             | 18760-19960|
+-----------------+-------------+------------+
| pscheduler      | 443         |            |
+-----------------+-------------+------------+
| traceroute      |             | 33434-33634|
+-----------------+-------------+------------+
| simplestream    | 5890-5900   |            |
+-----------------+-------------+------------+
| nuttcp          | 5000, 5101  |            |
+-----------------+-------------+------------+
| iperf3          | 5201        |            |
+-----------------+-------------+------------+
| iperf2          | 5001        |            |
+-----------------+-------------+------------+
| ntp             |             | 123        |
+-----------------+-------------+------------+

Some ports are also used to access the perfSONAR Toolkit management interfaces:

+--------------------------------------------+
| perfSONAR Toolkit Ports                    | 
+-------------------------------+------------+
| Tool                          | TCP ports  |
+===============================+============+
| management interface          | 443        +   
+-------------------------------+------------+
| archive (opensearch, logstash)| 443        +   
+-------------------------------+------------+


.. note:: ICMP also needs to be open

.. _manage_security-custom:

Adding Your Own Firewall Rules
==============================
For operating systems using *iptables*, the rules added by the perfSONAR Toolkit are contained within a special perfSONAR chain of *iptables* (and *ip6tables*). You may add rules to the other chains, such as the INPUT chain, just as you would any other firewall rule. It is NOT recommended you change the perfSONAR chain as any changes you make could be overwritten by a software update. 

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

Managing Archive Whitelist for Graphs
======================================
The perfSONAR graphs have the ability to reach out to external measurement archives. If you would like to limit the hosts that the graphs can reach, you can edit the file */usr/lib/perfsonar/graphs/etc/graphs.json*. The *url_whitelist* parameter can be uncommented (remove the #) and the names of the host you want to allow can be added to the list. Any address not in the list will result in an error. This change affects both the line graphs and the traceroute viewer.
