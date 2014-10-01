*************************************
Securely Managing your perfSONAR Host
*************************************

Since perfSONAR hosts often sit outside the firewall, and have a number of open ports, it is very 
important to actively manage your perfSONAR host, and make sure that security patches 
are always up to date. We recommend the following:

  * multiple system administrators from your site should be subscribed to the perfsonar security announcement list: https://lists.internet2.edu/sympa/subscribe/perfsonar-announce, and will install security updates in a timely manner.
  * If you run nagios (or something similar), add your perfSONAR host to your monitoring infrastructure. Consider running some of the nagios security plugins: 
     * http://exchange.nagios.org/directory/Plugins/Security#/
    In particular, the check_yum plugin is quite useful:
     * http://exchange.nagios.org/directory/Plugins/Operating-Systems/Linux/check_yum/details


Yum auto-update
===============

TO DO: Add info on auto-update, and why even with auto-update one still needs to be vigilant with security.


