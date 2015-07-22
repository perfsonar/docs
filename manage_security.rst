*******************************
Firewalls and Security Software
*******************************

The perfSONAR Toolkit utilizes a number of tools the help protect against attacks on the system. Some of these tools include:
 
    * A default set of iptables and ip6tables firewall rules that only allow connections to ports required by perfSONAR tools.
    * Inclusion of the `fail2ban`_ intrusion detection system (IDS) to log suspicious activity such as brute-force SSH attacks

None of these solutions will protect your host from all kinds of attacks so best common practices and good sense should be used when administering your host. In addition to tools like above it's important :doc:`update your host <manage_update>` with the latest packages and to watch the `mailing lists <http://www.perfsonar.net/about/getting-help/>`_ for important security announcements. 

Default Firewall Rules
======================
The perfSONAR Toolkit uses *iptables* and *ip6tables* to implement IPv4 and IPv6 firewall rules respectively. You can find the default configurations for each in */etc/sysconfig/iptables* and */etc/sysconfig/ip6tables*. You can find more information about the ports open and a complete list of rules on `our security page <http://www.perfsonar.net/deploy/security-considerations/>`_.

Adding Your Own Firewall Rules
==============================
The rules added by the perfSONAR toolkit are contained within a special perfSONAR chain of iptables (and ip6tables). You may add rules to the other chains, such as the INPUT chain, just as you would any other firewall rule. It is NOT recommended you change the perfSONAR chain as any changes you make could be overwritten by a software update. 

An example that will block access to port 8000 for all traffic is shown in the steps below (note it is not recommended you run this command as it will block access to the NPAD tool):

    #. Login to your host via SSH or the terminal as a root user
    #. View your current iptables rules with the following ``/sbin/service iptables status`` command. Note that the command does not necessarily show all the details of each rule and you should look in */etc/sysconfig/iptables* for a full description. For example  the second rule in the INPUT chain may look like it accepts all traffic, but in reality it only accepts all traffic *from the loopback interface*. An example is shown below::
    
        # /sbin/service iptables status
        Table: filter
        Chain INPUT (policy ACCEPT)
        num  target     prot opt source               destination         
        1    fail2ban-SSH  tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:22 
        2    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           
        3    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED 
        4    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpt:22 
        5    ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           state NEW udp spt:547 dpt:546 
        6    perfSONAR  all  --  0.0.0.0/0            0.0.0.0/0           
        7    REJECT     all  --  0.0.0.0/0            0.0.0.0/0           reject-with icmp-port-unreachable 

        Chain FORWARD (policy ACCEPT)
        num  target     prot opt source               destination         
        1    REJECT     all  --  0.0.0.0/0            0.0.0.0/0           reject-with icmp-port-unreachable 

        Chain OUTPUT (policy ACCEPT)
        num  target     prot opt source               destination         
        1    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           

        Chain fail2ban-SSH (1 references)
        num  target     prot opt source               destination         
        1    RETURN     all  --  0.0.0.0/0            0.0.0.0/0           

        Chain perfSONAR (1 references)
        num  target     prot opt source               destination         
        1    ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0           icmp type 255 
        2    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:80 state NEW,ESTABLISHED 
        3    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:443 state NEW,ESTABLISHED 
        4    ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpt:123 udp 
        5    ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpts:33434:33634 
        6    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpt:8000 
        7    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpts:8001:8020 
        8    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpt:7123 
        9    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpts:3001:3003 
        10   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpt:861 
        11   ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpts:8760:9960 
        12   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpt:4823 
        13   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpts:6001:6200 
        14   ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpts:6001:6200 
        15   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpts:5000:5900 
        16   ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpts:5000:5900 
        17   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpts:10101:10300 
        18   ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpts:10101:10300 
        19   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpt:7 
        20   ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpt:7 
        21   RETURN     all  --  0.0.0.0/0            0.0.0.0/0       
    #. Run the  iptables command below to block port 8000. Note that we are adding this rule to the INPUT chain and leaving the perfSONAR chain untouched. We are also adding it at position 5 which ensures it is processed before the perfSONAR rules::
    
        iptables -I INPUT 5 -p tcp --dport 8000 -j REJECT
    #. Now save your configuration change::
        
        /sbin/service iptables save
        
    #. We can now see our new rule was added::
    
        # /sbin/service iptables status
        Table: filter
        Chain INPUT (policy ACCEPT)
        num  target     prot opt source               destination         
        1    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           
        2    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED 
        3    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpt:22 
        4    ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           state NEW udp spt:547 dpt:546 
        5    REJECT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:8000 reject-with icmp-port-unreachable 
        6    perfSONAR  all  --  0.0.0.0/0            0.0.0.0/0           
        7    REJECT     all  --  0.0.0.0/0            0.0.0.0/0           reject-with icmp-port-unreachable 

        Chain FORWARD (policy ACCEPT)
        num  target     prot opt source               destination         
        1    REJECT     all  --  0.0.0.0/0            0.0.0.0/0           reject-with icmp-port-unreachable 

        Chain OUTPUT (policy ACCEPT)
        num  target     prot opt source               destination         
        1    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           

        Chain perfSONAR (1 references)
        num  target     prot opt source               destination         
        1    ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0           icmp type 255 
        2    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:80 state NEW,ESTABLISHED 
        3    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:443 state NEW,ESTABLISHED 
        4    ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpt:123 udp 
        5    ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpts:33434:33634 
        6    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpt:8000 
        7    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpts:8001:8020 
        8    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpt:7123 
        9    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpts:3001:3003 
        10   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpt:861 
        11   ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpts:8760:9960 
        12   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpt:4823 
        13   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpts:6001:6200 
        14   ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpts:6001:6200 
        15   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpts:5000:5600 
        16   ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpts:5000:5900 
        17   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpts:10101:10300 
        18   ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpts:10101:10300 
        19   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW,ESTABLISHED tcp dpt:7 
        20   ACCEPT     udp  --  0.0.0.0/0            0.0.0.0/0           udp dpt:7 
        21   RETURN     all  --  0.0.0.0/0            0.0.0.0/0           

.. note:: Prior to version 3.4, custom firewall rules were not handled properly. As such you may find that when upgrading from versions older than 3.4 that you will lose any custom rules. Following the steps above should ensure your rules are maintained for updates beyond 3.4 in the foreseeable future.

Fail2ban Intrusion Detection System
====================================
By default the perfSONAR Toolkit installs and configures the `fail2ban`_ Intrusion Detection System (IDS). This software will log suspicious activity such as a rapid succession of failed SSH login attempts in */var/log/secure*. By default it will not act to mitigate any attempts, only log them (though the default IP table rules do SSH throttling). If you would like to change this default behavior to send email or block unwanted intrusions, see the configuration file */etc/fail2ban/jail.conf* and the `fail2ban manual`_ for details.

.. _fail2ban: http://www.fail2ban.org
.. _fail2ban manual: http://www.fail2ban.org/wiki/index.php/MANUAL_0_8