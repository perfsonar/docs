**************
perfSONAR FAQ
**************

(page under construction!)

Sections:

- `Installation Questions`_
- `Tool Questions`_
- `Host and Network Administration Questions`_
- `perfSONAR Archive (esmond) Questions`_
- `perfSONAR Project Questions`_


Installation Questions
----------------------------

*Q: What are the hardware requirements for running the perfSONAR Toolkit?*

A: See :doc:`install_hardware`. 

*Q: Does my machine have to meet the System Requirements?*

A: There is nothing on the perfSONAR Toolkit that will prevent systems that do not meet the requirements from starting. Erroneous or inaccurate behavior is possible if the hardware cannot support the measurement tools. Performance considerations do favor meeting or exceeding the minimum guidelines.

*Q: The Services screen shows many services in the non-running state when first started, what is wrong?*

A: Services should start right away. It may be an indication of an installation problem. See :doc:`manage_logs` for information on where to look for more information.

*Q: I do not see my service in the Directory Of Services, where is it?*

A: Much like DNS, the information that will populate the Lookup Service will take time to propagate. Please allow some time (e.g. a few hours) before your service will be fully visible.

*Q: What should I enter for the *Communities* section of my *Administrative Information* configuration?*

A: The goal of *communities* is to associate some loosely coupled labels to the data that the perfSONAR Toolkit disk will be making available to the larger world. Think of this step similar to assigning labels to photos or music. Some examples of valid answers are:

- Internet2 - The data made available somehow connects the Internet2 backbone
- LHC (CMS, ATLAS, etc.) - The disk is part of the LHC deployment structure
- eVLBI - The disk is a part of the larger telescope community
- MAX - A connector of member of the MAX gigapop
- DOE-SC-LAB - US Department of Energy Office of Science Labs

Use as many community names as necessary to properly categorize the data from the installation.

*Q: I do not think I am a member of a community, should I put anything?*

A: Communities are not required, but they allow other individuals and organizations to find and use your services. It is a good practice to join as many as you may think are applicable.

*Q: How do I disable global registration?*

A: The following commands will stop, and disable, this service:
/sbin/service ls_registration_daemon stop
chkconfig ls_registration_daemon off


*Q: Can I boot from a USB key instead of a DVD?*

A: The perfSONAR Toolkit Netinstall and Fullinstall images are capable of being installed on a USB stick instead of a DVD. To write these images to the media, we recommend using dd, such as::
 
 sudo dd if=pS-Toolkit-4.0-FullInstall-x86_64.iso of=/dev/disk3
 

*Q: During the NetInstall, I see errors about a corrupt file being downloaded. What should I do?*

A: During the NetInstall, you may see some errors about a corrupt file being downloaded along with buttons like Reboot and Retry. This happens if it fails to download an RPM from a mirror, which can happen for numerous reasons. Usually, that error can be solved by hitting Retry. You may have to hit that multiple times depending on which mirrors the install is trying to download the RPM from.

*Q: When trying a clean install with perfSONAR Toolkit, the system doesn't recognize any disks/doesn't see my RAID controller. Things work with other operating systems. What should I do?*

A: If you have started with a different OS, you can attempt to install the necessary packages via yum::

 yum install perfsonar-toolkit

Once it’s installed, reboot the machine.


*Q: I would like to install and patch perfsonar boxes behind a web proxy, is it possible to specify this on the grub command line?*

A: Anaconda documentation indicates this grub parameter should do the trick::
 
 proxy=[protocol://][username[:password]@]host[:port]
 
Note that during a fresh network installation, Anaconda does install updates immediately (e.g. it wouldn't use a version of an RPM from when the ISO was built), and doesn't actually run any network services before the reboot. 
 
*Q: Which repository addresses will be used to get updates to the perfSONAR software?*

A: By default, the Internet2 repo points at a mirror list hosted by software.internet2.edu. In this mirror list is linux.mirrors.es.net. In order to use the default configuration you will need to allow access to software.internet2.edu so you can grab the mirrorlist. After that, the packages can be downloaded from any of the sites listed which includes linux.mirrors.es.net, software.internet2.edu, and a few other places. You should be able to get away with just opening up access to software.internet2.edu (so it can get the mirror list) and linux.mirrors.es.net (so you can get the packages). 
Those should be the only places you need as linux.mirrors.es.net also has a mirror for all the base CentOS packages.

*Q: Is there a way to re-image perfSONAR resources remotely?*

A: If the intention is to use the perfSONAR ISO as the base, the installer just needs view the installation medium like a DVD or USB would be mounted.
As for specifics of a mechanism to remotely install, consult the documentation of your server. For instance some services support "virtual media" if they contain a DRACs with the enterprise feature set enabled.
For a more general solution, and going on the assumption that a remote console access is available to a servers, consider a package called iPXE. iPXE can do is attach an ISO via iSCSI or HTTP, so all that is needed is to put up a server the remote machines can reach. The commands to do it are::

 set net0/ip 10.9.8.7
 set net0/netmask 255.255.255.0
 set net0/gateway 10.9.8.1
 set dns 10.9.8.2
 sanboot http://server.kinber.org/toolkit.iso

If there is DHCP available, the four set commands can be removed and a single dhcp command put in their place. Any HTTP server used to serve the ISO must support range requests. The standard Apache on most systems will.
Note that iPXE needs to be on a bootable medium, and it’s operationally better when separate from the disk in the machine. This means that remote locations will need to have something like a USB stick installed. Once in place, set the BIOS to ignore it and boot it explicitly when needed. Since it’s a regular USB device, it can be updated remotely while the main OS is running.



*Q: I am trying to run perfSONAR on low-cost hardware (e.g. raspberry pi, etc.). Where should I start?*

A: There are numerous hardware platforms that have emerged that are an attractive option for use in network performance measurement. The perfSONAR collaboration does not recommend, nor support, the use of perfSONAR on low-end, ARM-based hardware such as the Raspberry PI. It has been shown that it is difficult to distinguish network issues, from host issues, on these devices. In particular, we do not recommend these devices for testing throughput. Use of latency based tools (Ping, OWAMP) is possible provided that an accurate clock source is available.
For more information, see :doc:`install_low_cost_nodes`.


*Q: I am running a small node, and seeing a lot of IO. What is going on?*

A: Some users report abnormalities on their small nodes related to I/O activity (e.g. iostat reports long w_await times - sometimes measured in multiple seconds). These coincide with intervals of testing, in particular related to OWAMP.
Deeper investigation found that there is too much I/O going on: syslogd and systemd-journald processing syslog messages from "owampd and powstream” in “/var/log/messages”, sometimes up to 30-40 syslog messages per second depending on the testing configuration of a host. Given that small nodes are based on flash memory, changes should be made to ensure a more balanced approach to logging:
Do journaling on memory by editing “/etc/systemd/journald.conf”.
Make option "Storage=volatile” instead of the default “Storage=auto”. Make sure to limit the maximum usage of memory for journaling. You can do this by fiddling with “RuntimeKeepFree” and “RuntimeMaxUse” options.
Don’t *restart* the journaling service (i.e., don’t do “systemctl restart systemd-journald”). Do an *OS reboot* instead.


*Q: Where can I find more resources regarding timekeeping for VMWare Virtual Machines?*

A: VMWare has two resources worth reading:

- Timekeeping In Virtual Machines
- Timekeeping best practices for Linux guests



Tool Questions
----------------

*Q: What is pscheduler, and how do I use it?*

A: pscheduler is used to schedule network tests on perfSONAR hosts. See :doc:`using_pscheduler`

*Q: What is BWCTL, and how do I use it?*

A: BWCTL is the previous tool (before pscheduler) that was used to schedule network tests on perfSONAR hosts.
For more info see :doc:`using_tools`. BWCTL is still supported in v4.0, but will be deprecated in a future release.


*Q: What is OWAMP, and how do I use it?*

A: OWAMP (One-Way Ping) is a client server program that was developed to provide delay and jitter measurements between two target computers. At boot time, the perfSONAR Toolkit starts an OWAMP server process and leaves it listening on TCP port 861. This server may then be used by remote clients. Additionally, perfSONAR includes an OWAMP client application that can be used to test to remote instances. For more info see :doc:`using_tools`.

*Q: What happened to the NDT and NPAD tools?*

A: NDT and NPAD depend on web100, which is no longer supported, so they have been dropped from perfSONAR starting with v4.0. 
If you need similar functionality, we recommend that you use https://www.measurementlab.net/tests/


*Q: How can I set limits to prevent others from overusing my test host? What is the purpose of pscheduler limits?* 

A: The pscheduler limits system allows you to limit the influence that outside users have on your system. 
For example, to prevent your machine/network from being saturated with throughput tests, limit the duration and maximum bandwidth available. For more information see :doc:`pscheduler_server_limits`.


*Q: When attempting to use BWCTL with an IPv6 address, the command fails: bwctl: Unable to connect to 2001:468:1:11::16:66:4823. What should I do?*

A: Wrap the IPv6 address in square brackets and double quotes (to prevent the shell from trying to interpret the brackets). For example::

 bwctl -T iperf3 -c "[2001:468:1:11::16:66]:4823"


*Q: Can I run both throughput and latency/loss tests on the same interface without interference due to the way pscheduler scheduling works?*

A: Ping tests can be scheduled on the same host as throughput tests, but owamp tests can’t currently (they use powstream instead of owping).


*Q: How can I force testing over IPv4 or IPv6 in the mesh configuration?*

A: There is both a ipv4_only and ipv6_only option you can set in the test parameters of a mesh config. Setting them both at the same time gives an error.

*Q: How do I configure a test mesh to pace all TCP traffic to only 5Gbps, so that I don't use all my sites bandwidth?*

A: Currently it is not possible to set iperf3's *--fq-rate* flag via the mesh config file, but this should be in the next release. In the meantime, you can set pacing for your entire host using the commands described
at: https://fasterdata.es.net/host-tuning/packet-pacing/


*Q: After upgrading to 3.5 my maddash instance won't start (e.g. HTTP fails)?*

A: If after running yum update you see this error::

 [user@host ~]$ sudo /etc/init.d/httpd start
 Starting httpd: Syntax error on line 1 of /etc/httpd/conf.d/apache-esmond.conf:

    Invalid command 'WSGIScriptAlias', perhaps misspelled or defined by a module not included in the server configuration
                                                             [FAILED]
   
There could be a problem with the version of one of the WSGI libraries that was pulled in. You can verify it as such::

    [user@host ~]$ yum list installed | grep -i wsgi
    python27-mod_wsgi.x86_64             3.4-12.el6.centos.alt            @scl
    Due to the specific version of python that maddash/perfSONAR requires, the workaround is to uninstall the version above, and use the version found in the perfSONAR repository:
    [user@host ~]$  sudo yum erase "python27-mod_wsgi*"
    [user@host ~]$  sudo yum --disablerepo="*" --enablerepo="Internet2" --enablerepo="base" install esmond
    Then restart cassandra, and start httpd
    [user@host ~]$  sudo /sbin/service cassandra stop
    Shutdown Cassandra: OK
    [user@host ~]$  sudo /sbin/service cassandra start
    Starting Cassandra: OK
    [user@host ~]$  sudo /sbin/service httpd start
    Starting httpd: [ OK ]



*Q: I want to operate a "Dynamic" Maddash Mesh with hosts from a lookup service. Where do I start?*

A: There is information on this method of mesh configuration available at the following link:

- :doc:`multi_mesh_autoconfig`

The server and agent each have needs regarding the definition of tests, information on each can be found via these links:

- :doc:`multi_mesh_server_config`
- :doc:`multi_mesh_agent_config`

*Q: If you have made manual changes to regular_testing.conf to point to a different MA (or multiple MAs), and you subsequently change test configurations through the GUI, does this leave your MA customizations alone?*

A: Yes. The GUI leaves all measurement_archive blocks alone.


*Q: Why do I get such weird results when I test from a 10G connected host to 1G connected host?*

A: See https://fasterdata.es.net/performance-testing/troubleshooting/interface-speed-mismatch/


*Q: My perfSONAR results show consistent line-rate performance, but a researcher at my site is reporting really poor performance, what gives?*

A: perfSONAR is designed to give a "best case scenario" test result for end to end testing:
perfSONAR is typically installed on well-provisioned server-class hardware that contains adequate CPU, memory, and NIC support
The perfSONAR toolkit follows this recommended host tuning: https://fasterdata.es.net/host-tuning/linux/

pscheduler's throughput tests invoke "memory to memory" test tools. 
perfSONAR typically runs short single streamed TCP tests.
The user of a network may not have a machine that is as tuned as a perfSONAR node, could be using an application that is incorrect for the job of data movement, and may have a bottleneck due to storage performance. Consider all of these factors when working with them to identify performance issues. It is often the case that the 'network' may be working fine, but the host and software infrastructure need additional attention.

*Q: How do I change the default tool used in a test mesh?* 

A: The file resides at: /etc/perfsonar/regulartesting.conf

*Q: Is there a way to visualize GridFTP results in Maddash?* 

A: Please see documentation at http://software.es.net/esmond/perfsonar_gridftp.html



Host and Network Administration Questions
------------------------------------------


*Q: Where are the relevant logs for perfSONAR services?*

A: Please see :doc:`manage_logs` for more information. 


*Q: Can I Use a firewall?*

A: Please see :doc:`manage_security`.


*Q: How many NTP servers do I need, can I select them all?*

A: It is recommended that 4 to 5 close and active servers be used. The Select Closest Servers button will help with this decision. Note that some servers may not be available due to routing restrictions (e.g. non-R&E networks vs R&E networks - a common problem for Internet2 and ESnet servers).

*Q: When setting up a dual homed host, how can one get individual tests to use one interface or another?*

A: See :doc:`manage_dual_xface`.
 

*Q: How do I change the MTU for a device?*

A: Changing the MTU on your perfSONAR host should only be done if the underlying network supports the chosen size. Please work with your local network staff before making this change on any host.
You can view the MTU of your network devices by executing the /sbin/ifconfig command.
To temporarily change the MTU for a device, you use the ifconfig command and specify the device and the new MTU. For example: ifconfig eth0 mtu 9000 up
 
To make these changes permanent you need to modify the specific devices configuration file. These files are in /etc/sysconfig/network-scripts/ and have names like ifcfg-eth0 for the device eth0 and ifcfg-eth1 for eth1.
 
For example you could add the line MTU="9000" for IPv4 or IPV6_MTU="9000" for IPv6 to /etc/sysconfig/network-scripts/ifcfg-eth0.
After making the changes you need to restart the network services by running the command 'service network restart' as root.


*Q: How can I configure my toolkit to allow a private IP?* 

A: The file resides at:
/usr/lib/perfsonar/web-ng/etc/web_admin.conf
The config option is allow_internal_addresses. Set it to 1.



*Q: How do I change the SSL certificate used by the web server?*

A: The toolkit by default generates a self-signed SSL certificate that it configures for use with the Apache web server. Some users may desire to replace this certificate with a certificate signed by a certificate authority (CA).

You may also need to replace the certificate due to a problem sometimes encountered with browsers not accepting the self-signed certificate. You may see an error like the following::
 
    HOST uses an invalid security certificate.
    The certificate is not trusted because it is self-signed.
    The certificate is only valid for localhost.localdomain
    (Error code: sec_error_untrusted_issuer)
 
You can find instructions for installing a new certificate in Apache
`here <http://httpd.apache.org/docs/2.0/ssl/ssl_faq.html#aboutcerts>`_.
 

*Q: I forgot to enable IPv6 in CentOS when I installed the toolkit. How do I enable it?*

A: It is recommended that you always enable IPv6 during the CentOS installation portion of the toolkit setup. If you did not enable it, then you can do so with the following steps:

Login to the toolkit as a user capable of running sudo
Run sudo and enter your sudo password
Open the file /etc/modprobe.conf in a text editor and remove the following lines::

  alias net-pf-10 off
  alias ipv6 off
  options ipv6 disable=1

Then Restart the host. You can now assign an IPv6 address.

*Q: Why is the static IPv6 address I assigned during the net-install process not configured when my host starts-up?*

A: When you perform the net-install of the toolkit, you will be prompted twice to enter networking information by CentOS. The first time is to define the networking to be used for downloading required packages. The second prompt is later in the installation and defines what will be configured on the host post-installation. It is a known CentOS behavior that IPv6 information entered at the first prompt is not automatically filled-in at the second prompt. This can be confusing because the IPv4 information does get automatically filled-in. If you do not manually enter the IPv6 information a second time, then your host will not have the address configured post-installation. You will have to manually assign the address if this happens.


*Q: How do I setup a perfSONAR node to have two interfaces on the same subnet?*

A: This can be accomplished by setting the following items in sysctl::
 
 net.ipv4.conf.default.arp_filter = 2
 net.ipv4.conf.all.arp_filter = 2

More information available here:
http://z-issue.com/wp/linux-rhel-6-centos-6-two-nics-in-the-same-subnet-but-secondary-doesnt-ping/


*Q: What TCP congestion control algorithm is used by the perfSONAR Toolkit?*

A: The perfSONAR toolkit sets the TCP congestion control algorithm to htcp. 

*Q: How can I add custom rules to IPTables?*

A: See :ref:`manage_security-custom`


*Q: Is it possible to change the default port for tool X?*

A: Some measurement tools use 2 kinds of ports:

- Contact ports, e.g. a well known location to contact the daemon to initiate a test
- Test ports, e.g. negotiated ports to flow test or control traffic when a test is requested

Test ports are easily configured to run on a specific set of ports, and can be configured to be opened in a site firewall. The daemon is often able to negotiate these at run time. The contact port is well known, and because of that should never be changed to a different value. Doing so severely impacts the ability of the tool to interoperate on a global scale.

As an example, the OWAMP server listens on the registered port 861 (see http://tools.ietf.org/search/rfc4656 section 2). This is the standard port for the application, in the same way that port 80 is the standard port for an HTTP server. While one can run a web server on a port other than 80, it makes the web server less useful because it's not a standard config. The same is true for OWAMP. The OWAMP protocol is standardized, and has a well-known port - port 861 - associated with it. Running the OWAMP daemon on a non-standard port introduces significant interoperability challenges between deployments.

If you're going to run a measurement infrastructure inside your own organization, you are of course free to do whatever you want. If you want to integrate with the rest of the world, the measurement tools should be run on the standard port to ensure interoperability.

*Q: Why doesn't the perfSONAR toolkit include the most recent version of vendor X’s driver?*

A: We only support the default CentOS device drivers on the toolkit. Check your NIC vendor's website to see if a newer version of the driver is available for download.

*Q: Can I configure yum to exclude kernel packages from it's update procedure?*

A: A detailed explanation of yum configuration can be found in the RHEL documents: https://access.redhat.com/site/solutions/10185. There are two ways to exclude kernel packages from a yum update, the first solution can be invoked on the command line::
 
  yum update --exclude=kernel*
 
To make permanent changes, edit the /etc/yum.conf file and following entries to it::
 
 [main]
 cachedir=/var/cache/yum/$basearch/$releasever
 keepcache=0
 debuglevel=2
 logfile=/var/log/yum.log
 exclude=kernel* samba*                           <==== 
 
 
NOTE: If there are multiple package to be excluded then separate them using a single space or comma.
 
*Q: How can I configure yum to automatically update the system?*

A: Note that as of version v3.4, this is enabled by default. See :doc:`manage_update`.

*Q: My host was impacted by Linux security issue (Shellshock/Heartbleed/etc.). What should I do?*

A: Please check the `vulnerability archive <https://access.redhat.com/security/vulnerabilities>`_ for updates, and upgrade your system as soon as the update is available.

*Q: A CVE announcement was made for the current perfSONAR Toolkit Kernel, what do I do?*

A: The perfSONAR development effort subscribes to all major outlets that will announce kernel CVEs. In the event that a CVE is announced that directly effects operation of the perfSONAR Toolkit, the following steps will take place:

- Announcements regarding the CVE will be posted to the perfsonar-user and perfsonar-announce mailing lists 
- A timeline will be relayed regarding availability of new kernels.
- It is strongly suggested that perfSONAR Toolkit hosts be upgraded immediately. (Run the command: sudo yum update)

*Q: How to get rid of "There isn't a perfSONAR sudo user defined" message?*

A: Either add a non-root user to the pssudo group or remove the line /etc/perfsonar/toolkit/scripts/add_pssudo_user —auto from /root/.bashrc. Note that future updates could revert the /root/.bashrc file.

**TODO: Change this to /etc/profile.d**

*Q: I am seeing a "Can't locate object method 'ssl_opts' via package 'LWP::UserAgent'" error when trying to use a Central Measurement Archive. What should I do?*

A: This is due to a old version of the perl-libwww-perl package that is included with CentOS 6. If you remove “ca_certificate_path” from the configuration file things will work.


*Q: Is it possible to use non-intel SFP+ optics in the Intel X520-SR2 NIC?*

A: The ixgbe driver has an option to allow alternative optics:
allow_unsupported_sfp=1
This can be tested using the fillow commands:
sudo modprobe -r ixgbe
sudo modprobe ixgbe allow_unsupported_sfp=0


*Q: How can I tune a Dell server for a high throughput and low latency?*

A: Dell offers this guide on tuning: 

http://i.dell.com/sites/content/shared-content/data-sheets/en/Documents/configuring-low-latency-environments-on-dell-poweredge-12g-servers.pdf

*Q: How do I backup a perfSONAR instance or migrate the configuration and data to a new machine?*

A: To back up perfSONAR configurations and logs::

 /opt/perfsonar_ps/ls_registration_daemon/etc/*
 /opt/perfsonar_ps/mesh_config/etc/*
 /opt/perfsonar_ps/regular_testing/etc/*
 /opt/perfsonar_ps/toolkit/etc/*
 /opt/perfsonar_ps/traceroute_ma/etc/*
 /opt/perfsonar_ps/serviceTest/etc/*
 /opt/perfsonar_ps/snmp_ma/etc/*
 /opt/esmond/*
 /etc/httpd/conf.d/apache-toolkit_web_gui.conf
 /etc/owampd/*
 /etc/bwctld/*
 /etc/cassandra/*
 /var/lib/pgsql/*
 /var/lib/cassandra/*
 /var/lib/perfsonar/*
 /var/log/perfsonar/*

To back up perfSONAR data, see :doc:`multi_ma_backups`.

*Q: What is PTP?*

A: PTP is the Precision Time Protocol, also known as IEEE 1588, a more-accurate successor to the Network Time Protocol which as been used for many years to discipline the clocks in general-purpose computers. Under ideal conditions, PTP can discipline a clock to within a few microseconds of UTC. Compare this with NTP, which typically has accuracy of about a millisecond when used with clocks on the Internet and 100 microseconds or less when using a stratum-1 clock in a LAN environment.

*Q: What is required to use PTP in my network?*

A: Unlike NTP, which provides satisfactory operation using software clients and a pool of servers usually on the Internet, running PTP requires specialized equipment:

- Clocks. For production-grade service, PTP requires a minimum of two grandmaster clocks. These are dedicated hardware appliances that use the Global Positioning System to recover accurate time and a high-precision oscillator for holdover during periods when GPS is not available. At this writing, base model clocks cost about US$2,500 each.
- Network Infrastructure. PTP requires that all network elements between the grandmaster and slaves be capable of functioning as a boundary clock. This is a feature typically found on high-end routers and switches designed for use in low-latency applications.
- Network Interface Cards. Interfaces in the slave system require hardware support for the timestamping that makes PTP work accurately. While software-only PTP clients exist, they may suffer inaccuracies induced by the vagaries of running under a general-purpose operating system and provide inaccurate results when testing latency in a LAN environment.

*Q: Does perfSONAR support PTP?*

A: Not at this time. The prohibitive cost of deploying PTP makes it unlikely to be used widely enough to merit adding support. The current perfSONAR code contains assumptions that the clock is disciplined by NTP and would need to be modified for other protocols.


perfSONAR Archive (esmond) Questions
-------------------------------------

*Q: How much memory is needed for a host running an MA?*

A: Cassandra will try to use 4G of memory by default (if its available on the system). It is possible to tweak the memory settings if you want it to use less. Read more here: 

- http://docs.datastax.com/en/cassandra/2.0/cassandra/operations/ops_tune_jvm_c.html. 

Tuning this makes it possible to run an MA on a host with less memory.

*Q: I have a measurement archive machine with esmond running, and there is a separate disk partition mounted on the machine where I want to store all the incoming measurement data from measurement points. What is the proper way to change the default directory location for storing the measurement archive data?*

A: Change the directory where cassandra and postgres store data. This is controlled through the respective tools configuration files and not esmond directly.

For cassandra, in /etc/cassandra/conf/cassandra.yaml change the commitlog_directory, data_file_directories and saved_caches_directory to the new locations you desire. Restart cassandra: /sbin/service cassandra restart

For postgres, in /var/lib/pgsql/data/postgresql.conf change the data_directory to the new location. Restart postgres: /etc/init.d postgresql restart. 

You will need to rebuild the esmond tables after this change is made. To do so, follow the instructions here: http://software.es.net/esmond/rpm_install.html#configuration

An alternative way to do what you want is to stop both postgres and cassandra, move /var/lib/cassandra and /var/lib/pgsql to the new partition and then create symlinks to the new location in /var/lib/cassandra and /var/lib/pgsql. That saves the need to rebuild postgres and preserves any existing data.

*Q: How can I nuke all of the data in esmond, and start from scratch?*

A: Note, many of these commands should be done as root, and will destroy existing data and metadata collections. An additional step to load the esmond key into a regular testing file may be required (read output of tools to know for sure)::

 /etc/init.d/postgresql stop
 rm -rf /var/lib/pgsql/data/*
 /sbin/service postgresql initdb
 /sbin/service postgresql start
 wait about 20 seconds
 sudo -u postgres psql -c "CREATE USER esmond WITH PASSWORD '7hc4m1'"
 sudo -u postgres psql -c "CREATE DATABASE esmond"
 sudo -u postgres psql -c "GRANT ALL ON DATABASE esmond to esmond"
 cp -f /opt/perfsonar_ps/toolkit/etc/default_service_configs/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf
 /sbin/service postgresql restart
 sed -i "s/sql_db_name = .*/sql_db_name = esmond/g" /opt/esmond/esmond.conf
 sed -i "s/sql_db_user = .*/sql_db_user = esmond/g" /opt/esmond/esmond.conf
 sed -i "s/sql_db_password = .*/sql_db_password = 7hc4m1/g" /opt/esmond/esmond.conf
 /opt/perfsonar_ps/toolkit/scripts/system_environment/configure_esmond 



*Q: I have a central MA for my perfSONAR data. What happens if the central MA goes down for a while, or the network is unavailable between the beacons and the MA? Are the measurements lost, or are they buffered to be delivered later? Does this have any effect on the timing of subsequent measurements?*

A: The beacons observe a "push" architecture (i.e. the perfsonar node which made a measurement connects to the central MA to store the results) to the central MA.
If the host MA goes down, the missed measurements are stored on local disk under /var/lib/regular_testing and the regular_testing daemon tries to register them when the MA comes back. If the MA is down too long though (where “too long” varies on the system and number of tests being run) the backlog of tests can get too big and regular-testing can’t catch-up. On a Toolkit installation, we actually clean out the backlog of tests for this reason as we have frequently seen hosts get in a state where the backlog of tests is too big. For more info see :doc:`multi_overview`.

*Q: What if there are multiple MAs used for a central MA architecture, but only one is down or unreachable, what will happen?*

A: Each MA will be treated the same as if they were the only MA in the file. In other words, the one that is up will get the data and a backlog will be kept on disk for the one that is down. When the downed MA comes back up the daemon will try to register the old data points.

*Q: Cassandra seems to be using 100% CPU on my system and I can't figure out why.*

A: Cassandra features a nodetool utility that can be used to see what is going on. For instance, if you notice that after you restart cassandra it spends lots of time 'compacting', you can view status as such::

 $ nodetool compactionstats
 pending tasks: 1
          compaction type        keyspace           table       completed           total      unit  progress
               Compaction          esmondrate_aggregations       140157665      2632220068     bytes     5.32%
 Active compaction remaining time :        n/a

If after repeated runnings the total progress does not move, cassandra may be having trouble compacting. There may be the following logs in the file::

 INFO [CompactionExecutor:8] 2016-04-02 12:32:18,205 CompactionController.java (line 192) Compacting large row esmond/rate_aggregations:ps:packet_loss_rate:b30f54e8df9549ceb8292278b782f05b:2015 (121215124 bytes) incrementally
 INFO [CompactionExecutor:8] 2016-04-03 04:50:45,168 CompactionController.java (line 192) Compacting large row esmond/rate_aggregations:ps:time_error_estimates:b30f54e8df9549ceb8292278b782f05b:2015 (123923983 bytes) incrementally
 INFO [CompactionExecutor:8] 2016-04-03 22:06:38,417 CompactionController.java (line 192) Compacting large row esmond/rate_aggregations:ps:packet_loss_rate:76b654c4279241f19898dcdb8cacdfb2:2015 (120871402 bytes) incrementally

It may be the case that an exceptionally large data row can't be compacted. When the size of the row exceeded 64Mb, Cassandra should try to swap to disk, and that may fail.

It is possible to edit /etc/cassandra/conf/cassandra.yaml and change the "in_memory_compaction_limit_in_mb" value up from 64 to 256 and restart cassandra. Once the row or rows in question are compacted, you can change it back and restart again.


*Q: How can I clean up the data in my esmond instance?*

A: Information on this can be found here: :ref:`multi_ma_backups-delete`.

*Q: How can I backup the data in my esmond instance?*

A: Information on this can be found here: http://docs.datastax.com/en/cassandra/2.0/cassandra/operations/ops_backup_restore_c.html

Additionally, to back up perfSONAR data from an MA see guidance on this page: :doc:`multi_ma_backups`.  
Note that some steps may destroy data. 

For PostgreSQL: *This will delete any existing data and replace it with the backup*
For Cassandra and nodetool, It also overwrites existing data (via https://specs.openstack.org/openstack/trove-specs/specs/liberty/cassandra-backup-restore.html):
A snapshot can be restored by moving all \*.db files from a snapshot directory to the respective keyspace overwriting any existing files.

   
*Q: Where can I find documentation on interacting with perfSONAR archive via a custom client?*

A: See: 

- http://software.es.net/esmond/perfsonar_client_rest.html 
- http://software.es.net/esmond/perfsonar_client_perl.html 
- http://software.es.net/esmond/perfsonar_client_python.html

perfSONAR project Questions
---------------------------

*Q: How do I join the perfSONAR Collaboration?* 

A: Please contact us at perfsonar-lead@internet2.edu.


*Q: Where can I ask questions or report bugs?*

A: For questions, send email to perfsonar-user at internet2 dot edu. You may also join the mailing list by visiting https://lists.internet2.edu/sympa/info/perfsonar-user. 

Report bugs at https://github.com/perfsonar/project/issues.


*Q: Which licenses do perfSONAR products use?*

A: perfSONAR components are licensed under the Apache 2.0 license. 


*Q: How does version numbering work for the perfSONAR project?*

A: See https://github.com/perfsonar/project/wiki/Versioning if you are interested in learning about our version numbering scheme.


 


