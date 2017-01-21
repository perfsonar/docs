******************************************************
Limiting Tests to R&E Networks Only
******************************************************

**Note: this page still needs to be updated for v4.0/pschedler!**

ESnet provides a file containing all Research and Education Network subnets based on it's routing table and is updated nightly. 
This file is used to generate a sample bwctl-server.limits and pscheduler/limits.conf file.

It implements the following general policies:

* Allow unrestricted UDP tests from ESnet test system prefixes.
* Allow up to 200Mbps UDP tests from ESnet sites.
* Deny UDP tests from any other locations.
* Allow TCP tests from IPV4 and IPv6 addresses in the global Research and Education community routing table.
* Deny TCP tests from everywhere else.

To use the ESnet bwctl-server.limits file, get this file from ESnet as follows:
::

    cd /etc/bwctl-server
    mv bwctl-server.limits bwctl-server.limits.dist
    wget --no-check-certificate http://stats.es.net/sample_configs/bwctld.limits
    mv bwctld.limits bwctl-server.limits

ESnet provides a shell script that will download and install the latest bwctl-server.limits file. The bwctl-server.limits file is generated once per day between 20:00 and 21:00 Pacific Time. You can run the shell script from cron to keep your bwctl-server.limits file up to date (it is recommended that you do this outside the time window when the new file is being generated). To download the shell script from the ESnet server do the following:
::

    cd /etc/bwctl-server
    wget --no-check-certificate http://stats.es.net/sample_configs/update_limits.sh
    chmod +x update_limits.sh


