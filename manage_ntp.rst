***************
Configuring NTP
***************

For perfSONAR tests to work correctly, its critical that NTP be configured properly.

For most installations, selecting "NTP" on the left side menu of the toolkit administration GUI, and clicking 'select closest servers' is all that should be needed. It is recommended to sync with 4-5 servers (not more), and that they all be fairly close by (less than 20ms RTT).

If your network can not connect to enough close servers, you'll want to indenfy some additional close NTP servers, and click on 'manually add server'.

Talk to your network administrator to see what NTP servers are typically used at your site, or look here for a nearby server: 
 *  http://support.ntp.org/bin/view/Servers/StratumOneTimeServers
 *  https://support.ntp.org/bin/view/Servers/StratumTwoTimeServers

Note that www.pool.ntp.org servers are not typically accurate enough for perfSONAR's requirements, and should be avoided.
