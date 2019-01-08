*******************************************
perfSONAR Frequently Asked Questions (FAQs)
*******************************************

.. contents:: Topics
    :depth: 1
    :local:
    

Installation Questions
----------------------------

Q: What are the hardware requirements for running the perfSONAR Toolkit?
===========================================================================

**A:** See :doc:`install_hardware`. 

Q: Does my machine have to meet the System Requirements?
===========================================================================

**A:** There is nothing on the perfSONAR Toolkit that will prevent systems that do not meet the requirements from starting. Erroneous or inaccurate behavior is possible if the hardware cannot support the measurement tools. Performance considerations do favor meeting or exceeding the minimum guidelines.

Q: The *Services* screen shows many services in the non-running state when first started, what is wrong?
======================================================================================================================================================

**A:** Services should start right away. It may be an indication of an installation problem. See :doc:`manage_logs` for information on where to look for more information.

Q: I do not see my service in the `directory of services <http://stats.es.net/ServicesDirectory/>`_, where is it?
======================================================================================================================================================

**A:** Much like DNS, the information that will populate the Lookup Service will take time to propagate. Please allow some time (e.g. a few hours) before your service will be fully visible. If it stil does not appear, you may want to look in :ref:`lsregistrationdaemon.log <config_files-lsreg-logs-primary>` for errors.

Q: What should I enter for the *Communities* section of my *Administrative Information* configuration?
======================================================================================================================================================

**A:** The goal of *communities* is to help identify the types of tests and where they are being run by a perfSONAR measurement point. Think of this them as being similar to labels you assign to photos or music. Some examples of communities one might assign are:

- Internet2 - The tests run somehow connects the Internet2 backbone
- LHC (CMS, ATLAS, etc.) - The host is part of the LHC deployment structure
- eVLBI - The host is a part of the larger telescope community
- MAX - A connector of member of the MAX gigapop
- DOE-SC-LAB - US Department of Energy Office of Science Labs

Communities are not required and are currently not strictly defined. Use your best judgement in defining them and try to pick communities that will help others determine if a measurement to your host would be beneficial when configuring their own tests. 

Q: I do not think I am a member of a community, should I put anything?
===========================================================================

**A:** Communities are not required, but they allow other individuals and organizations to find and use your services. Assign a community if you think it will allow others to gain insight on whether running a test to your host is beneficial.

Q: How do I disable global registration?
===========================================================================

**A:** The following commands will stop, and disable, this service:
        
        systemctl stop perfsonar-lsregistrationdaemon
        systemctl disable perfsonar-lsregistrationdaemon

Q: Can I boot from a USB key instead of a DVD?
==============================================

**A:** The perfSONAR Toolkit Netinstall and FullInstall images are capable of being installed on a USB stick instead of a DVD. To write these images to the media, we recommend using dd, such as::
 
 sudo dd if=pS-Toolkit-VERSION-FullInstall-x86_64.iso of=/dev/disk3
 

Q: During the NetInstall, I see errors about a corrupt file being downloaded. What should I do?
================================================================================================
**A:** During the NetInstall, you may see some errors about a corrupt file being downloaded along with buttons like Reboot and Retry. This happens if it fails to download an RPM from a mirror, which can happen for numerous reasons. Usually, that error can be solved by hitting Retry. You may have to hit that multiple times depending on which mirrors the install is trying to download the RPM from.

Q: When trying a clean install with perfSONAR Toolkit, the system doesn't recognize any disks/doesn't see my RAID controller. Things work with other operating systems. What should I do?
=================================================================================================================================================================================================================================

**A:** You can try one of the vanilla CentOS images at http:://www.centos.org and then install the necessary packages via yum::

    yum install perfsonar-toolkit

If that does not work, it sounds like an operating system issue and beyond the scope of perfSONAR.

Q: I would like to install and patch perfsonar boxes behind a web proxy, is it possible to specify this on the grub command line?
======================================================================================================================================================
**A:** Anaconda documentation indicates this grub parameter should do the trick::
 
 proxy=[protocol://][username[:password]@]host[:port]
 
Note that during a fresh network installation, Anaconda does install updates immediately (e.g. it wouldn't use a version of an RPM from when the ISO was built), and doesn't actually run any network services before the reboot. 
 
Q: Which repository addresses will be used to get updates to the perfSONAR software?
========================================================================================================================================================================================
**A:** By default, the perfSONAR repo points at a mirror list hosted by software.internet2.edu. In this mirror list is linux.mirrors.es.net. In order to use the default configuration you will need to allow access to software.internet2.edu so you can grab the mirrorlist. After that, the packages can be downloaded from any of the sites listed which includes linux.mirrors.es.net, software.internet2.edu, and a few other places. You should be able to get away with just opening up access to software.internet2.edu (so it can get the mirror list) and linux.mirrors.es.net (so you can get the packages). 
Those should be the only places you need as linux.mirrors.es.net also has a mirror for all the base CentOS packages.

Q: Is there a way to re-image perfSONAR resources remotely?
========================================================================================================================================================================================
**A:** If the intention is to use the perfSONAR ISO as the base, the installer just needs view the installation medium like a DVD or USB would be mounted.
As for specifics of a mechanism to remotely install, consult the documentation of your server. For instance, some services support "virtual media" if they contain a DRACs with the enterprise feature set enabled.
For a more general solution, and going on the assumption that remote console access is available to a servers, consider a package called iPXE. iPXE can attach an ISO via iSCSI or HTTP, so all that is needed is to put up a server the remote machines can reach. The commands to do it are::

 set net0/ip 10.9.8.7
 set net0/netmask 255.255.255.0
 set net0/gateway 10.9.8.1
 set dns 10.9.8.2
 sanboot http://server.example.net/toolkit.iso

If DHCP is available, the process is considerably simpler::

 dhcp
 sanboot http://server.example.net/toolkit.iso
 
Any HTTP server used to serve the ISO must support range requests. The standard Apache on most systems will.
Note that iPXE needs to be on a bootable medium, and it’s operationally better when separate from the disk in the machine. This means that remote locations will need to have something like a USB stick installed. Once in place, set the BIOS to ignore it and boot it explicitly when needed. Since it’s a regular USB device, it can be updated remotely while the main OS is running.



Q: I am trying to run perfSONAR on low-cost hardware (e.g. raspberry pi, etc.). Where should I start?
========================================================================================================================================================================================
**A:** There are numerous hardware platforms that have emerged that are an attractive option for use in network performance measurement. The perfSONAR collaboration does not recommend, nor support, the use of perfSONAR on low-end, ARM-based hardware such as the Raspberry PI. It has been shown that it is difficult to distinguish network issues, from host issues, on these devices. In particular, we do not recommend these devices for testing throughput. Use of latency based tools (Ping, OWAMP) is possible provided that an accurate clock source is available.
For more information, see :doc:`install_small_node_details`.


Q: I am running a small node, and seeing a lot of IO. What is going on?
========================================================================================================================================================================================
**A:** Some users report abnormalities on their small nodes related to I/O activity (e.g. iostat reports long w_await times - sometimes measured in multiple seconds). These coincide with intervals of testing, in particular related to OWAMP.
Deeper investigation found that there is too much I/O going on: syslogd and systemd-journald processing syslog messages from "owampd and powstream” in “/var/log/messages”, sometimes up to 30-40 syslog messages per second depending on the testing configuration of a host. Given that small nodes are based on flash memory, changes should be made to ensure a more balanced approach to logging:
Do journaling on memory by editing “/etc/systemd/journald.conf”.
Make option "Storage=volatile” instead of the default “Storage=auto”. Make sure to limit the maximum usage of memory for journaling. You can do this by fiddling with “RuntimeKeepFree” and “RuntimeMaxUse” options.
Don’t *restart* the journaling service (i.e., don’t do “systemctl restart systemd-journald”). Do an *OS reboot* instead.


Q: Where can I find more resources regarding timekeeping for VMWare Virtual Machines?
========================================================================================================================================================================================
**A:** VMWare has two resources worth reading:

- `Timekeeping In Virtual Machines <http://www.vmware.com/content/dam/digitalmarketing/vmware/en/pdf/techpaper/Timekeeping-In-VirtualMachines.pdf>`_
- `Timekeeping best practices for Linux guests <https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1006427>`_


Q: How do you upgrade a perfSONAR node from Debian 7 to Debian 9
================================================================

**A:** Because of systemd, upgrading a host running perfSONAR on Debian 7 to Debian 9 is better done in multiple steps as described bellow:

    #. Upgrade Debian 7 to Debian 8 (following Debian instructions, here are `Jessie upgrade notes for i386 architecture <https://www.debian.org/releases/jessie/i386/release-notes/ch-upgrading.en.html>`_)
    #. Reboot (to get systemd running)
    #. Change perfSONAR repository from perfsonar-wheezy-release to perfsonar-release
    #. Upgrade Debian 8 to Debian 9 (following Debian instructions, here are `Stretch upgrade notes for i386 architecture <https://www.debian.org/releases/stretch/i386/release-notes/ch-upgrading.en.html>`_)


Tool Questions
----------------

Q: What is pScheduler and how do I use it?
========================================================================================================================================================================================
**A:** pScheduler is used to schedule network tests on perfSONAR hosts. See :doc:`pscheduler_intro`


Q: What is OWAMP and how do I use it?
========================================================================================================================================================================================
**A:** OWAMP (One-Way Ping) is a client server program that was developed to provide delay and jitter measurements between two target computers. At boot time, the perfSONAR Toolkit starts an OWAMP server process and leaves it listening on TCP port 861. This server may then be used by remote clients. Additionally, perfSONAR includes an OWAMP client application that can be used to test to remote instances. For more information on how it fits into perfSONAR overall see :doc:`intro_about`.

Q: What happened to the NDT and NPAD tools?
========================================================================================================================================================================================
**A:** NDT and NPAD depend on web100, which is no longer supported, so they have been dropped from perfSONAR starting with v4.0. 
If you need similar functionality, we recommend that you use https://www.measurementlab.net/tests/

Q: What happened to the BWCTL tool?
========================================================================================================================================================================================
**A:** BWCTL is no longer included by default with perfSONAR. BWCTL was used to schedule network tests on perfSONAR hosts prior to perfSONAR v4.0 but has been replaced by pScheduler.


Q: How can I set limits to prevent others from overusing my test host? What is the purpose of pscheduler limits?
================================================================================================================

**A:** The pscheduler limits system allows you to limit the influence that outside users have on your system. 
For example, to prevent your machine/network from being saturated with throughput tests, limit the duration and maximum bandwidth available. For more information see :doc:`config_pscheduler_limits`.


Q: Can I run both throughput and latency/loss tests on the same interface without interference due to the way pscheduler scheduling works?
========================================================================================================================================================================================
**A:** Currently you cannot guarantee no interference. pScheduler *rtt* test that execute the ping tool and OWAMP *latency* and *latencybg* tests that execute owping and powstream respectively, are considered background tasks and can be scheduled in parallel to each other as well as throughput tests. Given the frequency with which users prefer to run tools such as ping and owping (and powstream runs constantly), there would be very few tests slots available if this were not the case. This does not mean you cannot run these tests on the same interface, it just means some correlation of results may be necessary when debugging. It is recommended, though not required, you run these tests on separate interfaces from throughput.


Q: How can I force testing over IPv4 or IPv6 in a pSConfig template?
========================================================================================================================================================================================
**A:** The exact option may very depending on the test plug-in, but in a *test* object's ``spec`` most of the default plug-ins support an ``ip-version`` field that can get set to ``4`` or ``6``.

Q: How do I configure a pSConfig template to pace all TCP traffic to only 5Gbps, so that I don't use all my sites bandwidth?
========================================================================================================================================================================================
**A:** Set the ``bandwidth`` property in a *test* object's ``spec``. It accepts bandwidth as an integer in bits per second.

Q: I want to operate a "dynamic" template with hosts from a lookup service. Where do I start?
========================================================================================================================================================================================
**A:** You can find more information on this at :doc:`psconfig_autoconfig`.

Q: Why do I get such weird results when I test from a 10G connected host to 1G connected host?
========================================================================================================================================================================================
**A:** See https://fasterdata.es.net/performance-testing/troubleshooting/interface-speed-mismatch/


Q: My perfSONAR results show consistent line-rate performance, but a researcher at my site is reporting really poor performance, what gives?
========================================================================================================================================================================================
**A:** perfSONAR is designed to give a "best case scenario" test result for end to end testing:
perfSONAR is typically installed on well-provisioned server-class hardware that contains adequate CPU, memory, and NIC support
The perfSONAR toolkit follows this recommended host tuning: https://fasterdata.es.net/host-tuning/linux/

pScheduler's throughput tests invoke "memory to memory" test tools. 
perfSONAR typically runs short single streamed TCP tests.
The user of a network may not have a machine that is as tuned as a perfSONAR node, could be using an application that is incorrect for the job of data movement, and may have a bottleneck due to storage performance. Consider all of these factors when working with them to identify performance issues. It is often the case that the 'network' may be working fine, but the host and software infrastructure need additional attention.

Q: Is there a way to visualize GridFTP results in MaDDash?
=======================================================================================

**A:** Please see documentation at :doc:`esmond_gridftp`



Host and Network Administration Questions
------------------------------------------


Q: Where are the relevant logs for perfSONAR services?
========================================================================================================================================================================================
**A:** Please see :doc:`manage_logs` for more information. 


Q: Can I use a firewall?
========================================================================================================================================================================================
**A:** Please see :doc:`manage_security`.


Q: How many NTP servers do I need, can I select them all?
========================================================================================================================================================================================
**A:** It is recommended that 4 to 5 close and active servers be used. The Select Closest Servers button will help with this decision. Note that some servers may not be available due to routing restrictions (e.g. non-R&E networks vs R&E networks - a common problem for Internet2 and ESnet servers).

Q: When setting up a dual homed host, how can one get individual tests to use one interface or another?
========================================================================================================================================================================================
**A:** See :doc:`manage_dual_xface`.
 

Q: How do I change the MTU for a device?
========================================================================================================================================================================================
**A:** Changing the MTU on your perfSONAR host should only be done if the underlying network supports the chosen size. Please work with your local network staff before making this change on any host.
You can view the MTU of your network devices by executing the /sbin/ifconfig command.
To temporarily change the MTU for a device, you use the ifconfig command and specify the device and the new MTU. For example: ifconfig eth0 mtu 9000 up
 
To make these changes permanent you need to modify the specific devices configuration file. These files are in /etc/sysconfig/network-scripts/ and have names like ifcfg-eth0 for the device eth0 and ifcfg-eth1 for eth1.
 
For example you could add the line MTU="9000" for IPv4 or IPV6_MTU="9000" for IPv6 to /etc/sysconfig/network-scripts/ifcfg-eth0.
After making the changes you need to restart the network services by running the command 'service network restart' as root.


Q: How can I configure my toolkit web interface to display a private IP?
====================================================================================================================

**A:** The file resides at:
/usr/lib/perfsonar/web-ng/etc/web_admin.conf
The config option is allow_internal_addresses. Set it to 1. This affects the GUI display only, your measurement should work using private addresses with no special modification.



Q: How do I change the SSL certificate used by the web server?
========================================================================================================================================================================================
**A:** The toolkit by default generates a self-signed SSL certificate that it configures for use with the Apache web server. Some users may desire to replace this certificate with a certificate signed by a certificate authority (CA).

You may also need to replace the certificate due to a problem sometimes encountered with browsers not accepting the self-signed certificate. You may see an error like the following::
 
    HOST uses an invalid security certificate.
    The certificate is not trusted because it is self-signed.
    The certificate is only valid for localhost.localdomain
    (Error code: sec_error_untrusted_issuer)
 
You can find instructions for installing a new certificate in Apache
`here <http://httpd.apache.org/docs/2.0/ssl/ssl_faq.html#aboutcerts>`_.
 

Q: I forgot to enable IPv6 in CentOS when I installed the toolkit. How do I enable it?
========================================================================================================================================================================================
**A:** It is recommended that you always enable IPv6 during the CentOS installation portion of the toolkit setup. If you did not enable it, then you can do so with the following steps:

Login to the toolkit as a user capable of running sudo
Run sudo and enter your sudo password
Open the file /etc/modprobe.conf in a text editor and remove the following lines::

  alias net-pf-10 off
  alias ipv6 off
  options ipv6 disable=1

Then Restart the host. You can now assign an IPv6 address.

Q: Why is the static IPv6 address I assigned during the net-install process not configured when my host starts-up?
========================================================================================================================================================================================
**A:** When you perform the net-install of the toolkit, you will be prompted twice to enter networking information by CentOS. The first time is to define the networking to be used for downloading required packages. The second prompt is later in the installation and defines what will be configured on the host post-installation. It is a known CentOS behavior that IPv6 information entered at the first prompt is not automatically filled-in at the second prompt. This can be confusing because the IPv4 information does get automatically filled-in. If you do not manually enter the IPv6 information a second time, then your host will not have the address configured post-installation. You will have to manually assign the address if this happens.


Q: How do I setup a perfSONAR node to have two interfaces on the same subnet?
========================================================================================================================================================================================
**A:** This can be accomplished by setting the following items in sysctl::
 
 net.ipv4.conf.default.arp_filter = 2
 net.ipv4.conf.all.arp_filter = 2

More information available here:
http://z-issue.com/wp/linux-rhel-6-centos-6-two-nics-in-the-same-subnet-but-secondary-doesnt-ping/


Q: What TCP congestion control algorithm is used by the perfSONAR Toolkit?
========================================================================================================================================================================================
**A:** The perfSONAR toolkit sets the TCP congestion control algorithm to htcp. 

Q: How can I add custom rules to my firewall?
========================================================================================================================================================================================
**A:** See :ref:`manage_security-custom`


Q: Is it possible to change the default port for tool X?
========================================================================================================================================================================================
**A:** Some measurement tools use 2 kinds of ports:

- Contact ports, e.g. a well known location to contact the daemon to initiate a test
- Test ports, e.g. negotiated ports to flow test or control traffic when a test is requested

Test ports are easily configured to run on a specific set of ports, and can be configured to be opened in a site firewall. The daemon is often able to negotiate these at run time. The contact port is well known, and because of that should never be changed to a different value. Doing so severely impacts the ability of the tool to interoperate on a global scale.

As an example, the OWAMP server listens on the registered port 861 (see http://tools.ietf.org/search/rfc4656 section 2). This is the standard port for the application, in the same way that port 80 is the standard port for an HTTP server. While one can run a web server on a port other than 80, it makes the web server less useful because it's not a standard config. The same is true for OWAMP. The OWAMP protocol is standardized, and has a well-known port - port 861 - associated with it. Running the OWAMP daemon on a non-standard port introduces significant interoperability challenges between deployments.

If you're going to run a measurement infrastructure inside your own organization, you are of course free to do whatever you want. If you want to integrate with the rest of the world, the measurement tools should be run on the standard port to ensure interoperability.

Q: Why doesn't the perfSONAR toolkit include the most recent version of vendor X’s driver?
========================================================================================================================================================================================
**A:** We only support the default CentOS device drivers on the toolkit. Check your NIC vendor's website to see if a newer version of the driver is available for download.
 
Q: How can I configure yum to automatically update the system?
========================================================================================================================================================================================
**A:** Note that as of version v3.4, this is enabled by default. See :doc:`manage_update`.

Q: My host was impacted by Linux security issue (Shellshock/Heartbleed/etc.). What should I do?
========================================================================================================================================================================================
**A:** Please check the `RedHat vulnerability archive <https://access.redhat.com/security/vulnerabilities>`_ or the `Debian security list <https://www.debian.org/security/>`_ for updates, and upgrade your system as soon as the update is available.


Q: How to get rid of "There isn't a perfSONAR sudo user defined" message?
========================================================================================================================================================================================
**A:** The best option is to add a non-root user to the pssudo group. If you have another method of handling sudo users, comment out the lines in */etc/profile.d/add_psadmin_pssudo.sh*. Do not remove the file entirely, just modify it, otherwise it will get restored on update. 

Q: Is it possible to use non-intel SFP+ optics in the Intel X520-SR2 NIC?
========================================================================================================================================================================================
**A:** The ixgbe driver has an option to allow alternative optics:
allow_unsupported_sfp=1
This can be tested using the fillow commands:
sudo modprobe -r ixgbe
sudo modprobe ixgbe allow_unsupported_sfp=0


Q: How can I tune a Dell server for a high throughput and low latency?
========================================================================================================================================================================================
**A:** Dell offers this guide on tuning: 

http://i.dell.com/sites/content/shared-content/data-sheets/en/Documents/configuring-low-latency-environments-on-dell-poweredge-12g-servers.pdf

Q: How do I backup a perfSONAR instance or migrate the configuration and data to a new machine?
========================================================================================================================================================================================
**A:** See our :doc:`migration guide <install_migrate_centos7>` for a set of scripts that will create a backup/restore of relevant configuration files and measurement data. 

Q: What is PTP?
========================================================================================================================================================================================
**A:** PTP is the Precision Time Protocol, also known as IEEE 1588, a more-accurate successor to the Network Time Protocol which as been used for many years to discipline the clocks in general-purpose computers. Under ideal conditions, PTP can discipline a clock to within a few microseconds of UTC. Compare this with NTP, which typically has accuracy of about a millisecond when used with clocks on the Internet and 100 microseconds or less when using a stratum-1 clock in a LAN environment.

Q: What is required to use PTP in my network?
========================================================================================================================================================================================
**A:** Unlike NTP, which provides satisfactory operation using software clients and a pool of servers usually on the Internet, running PTP requires specialized equipment:

- Clocks. For production-grade service, PTP requires a minimum of two grandmaster clocks. These are dedicated hardware appliances that use the Global Positioning System to recover accurate time and a high-precision oscillator for holdover during periods when GPS is not available. At this writing, base model clocks cost about US$2,500 each.
- Network Infrastructure. PTP requires that all network elements between the grandmaster and slaves be capable of functioning as a boundary clock. This is a feature typically found on high-end routers and switches designed for use in low-latency applications.
- Network Interface Cards. Interfaces in the slave system require hardware support for the timestamping that makes PTP work accurately. While software-only PTP clients exist, they may suffer inaccuracies induced by the vagaries of running under a general-purpose operating system and provide inaccurate results when testing latency in a LAN environment.

Q: Does perfSONAR support PTP?
========================================================================================================================================================================================
**A:** Not at this time. The prohibitive cost of deploying PTP makes it unlikely to be used widely enough to merit adding support. The current perfSONAR code contains assumptions that the clock is disciplined by NTP and would need to be modified for other protocols.

Q: When trying to migrate from a CentOS 6 to a CentOS 7 host I receive pg_dump error. How to fix it?
========================================================================================================================================================================================
**A:** Using a script that will create a backup/restore of relevant configuration files and measurement data may generate ``pg_dump`` error failing to create pScheduler backup. This happens when you have both postgresql 8 and postgresql 9 installed, but pscheduler backup script expects only postgresql 9. This can be patched by editing ``/usr/libexec/pscheduler/commands/backup``:

Remove line:

    pg_dump \

Add in this place these three lines:

    PG_DUMP=pg_dump
    [ -x /usr/pgsql-9.5/bin/pg_dump ] && PG_DUMP=/usr/pgsql-9.5/bin/pg_dump
    $PG_DUMP \

Rerun the backup script.

perfSONAR Archive (esmond) Questions
-------------------------------------

Q: How much memory is needed for a host running an MA?
========================================================================================================================================================================================
**A:** The maximum amount of memory cassandra will use is calculated as a percentage of memory installed on the system. It is possible to tweak the memory settings if you want it to use a higher or lower percentage of memory. Read more here: 

- http://docs.datastax.com/en/cassandra/2.0/cassandra/operations/ops_tune_jvm_c.html. 

Q: I have a measurement archive machine with esmond running, and there is a separate disk partition mounted on the machine where I want to store all the incoming measurement data from measurement points. What is the proper way to change the default directory location for storing the measurement archive data?
=========================================================================================================================================================================================================================================================================================================================================
**A:** Change the directory where cassandra and postgres store data. This is controlled through the respective tools configuration files and not esmond directly.

For cassandra, in /etc/cassandra/conf/cassandra.yaml change the commitlog_directory, data_file_directories and saved_caches_directory to the new locations you desire. Restart cassandr**A:** service cassandra restart

For postgres, in /var/lib/pgsql/data/postgresql.conf cha

Run the following commands::

    /usr/pgsql-9.5/bin/postgresql96-setup initdb
    /usr/lib/perfsonar/scripts/toolkit/system_environment/configure_esmond

An alternative way to do what you want is to stop both postgres and cassandra, move /var/lib/cassandra and /var/lib/pgsql to the new partition and then create symlinks to the new location in /var/lib/cassandra and /var/lib/pgsql. That saves the need to rebuild postgres and preserves any existing data.

Q: How can I nuke all of the data in esmond, and start from scratch?
========================================================================================================================================================================================
**A:** The following will destroy existing data and metadata collections. First create a file named *esmond-nuke.conf* and add the following::

    {
    "policies": [

    {
    "event_type":      "*",
    "summary_type":    "*",
    "summary_window":  "*",
    "expire":          "0"
    }
    
    ]
    }

Then run the following commands to delete all esmond dat::
        
        cd /usr/lib/esmond
        . bin/activate
        python /usr/lib/esmond/util/ps_remove_data.py -c esmond-nuke.conf

Q: I have a central MA for my perfSONAR data. What happens if the central MA goes down for a while, or the network is unavailable between the beacons and the MA? Are the measurements lost, or are they buffered to be delivered later? Does this have any effect on the timing of subsequent measurements?
==============================================================================================================================================================================================================================================================================================================
**A:** All data is pushed to the measurement archive by the pScheduler software running on the measurement hosts. How long pScheduler attempts to register data after a failure is configurable, but by default the retry policy is a step function based on the test/reporting interval. It is best demonstrated by example as follows:

    * It will attempt to re-register OWAMP tests once 5 minutes after a failure. It is not more aggressive because OWAMP data by default reports every 60 seconds and can accrue very quickly.
    * A traceroute or ping test running every 10 minutes will try once after 1 minute and again after 5 minutes.
    * A throughput test running every 4 hours will try once after 1 minute, again after 5 minutes, and then once an hour for the next 11 hours.  


Q: What if there are multiple MAs used for a central MA architecture, but only one is down or unreachable, what will happen?
========================================================================================================================================================================================
**A:** Each MA is handled separately and data should continue to reach the working MA if another is down. 

Q: Cassandra seems to be using 100% CPU on my system and I can't figure out why.
========================================================================================================================================================================================
**A:** Cassandra features a nodetool utility that can be used to see what is going on. For instance, if you notice that after you restart cassandra it spends lots of time 'compacting', you can view status as such::

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

Q: How can I clean up the data in my esmond instance?
========================================================================================================================================================================================
**A:** Information on this can be found here: :ref:`multi_ma_backups-delete`.

Q: How can I backup the data in my esmond instance?
========================================================================================================================================================================================
**A:** Information on this can be found here: Information on this can be found here: :doc:`multi_ma_backups`.  

   
Q: Where can I find documentation on interacting with perfSONAR archive via a custom client?
========================================================================================================================================================================================
**A:** See: 

- :doc:`esmond_api_rest`
- :doc:`esmond_api_perl`
- :doc:`esmond_api_python`

Q: How can I get cassandra to run on a host that only has an IPv6 address?
=========================================================================================================================================================================================================================================================================================================================================
**A:** The default configuration of cassandra will not properly bind to the localhost interface if the host only has an IPv6 address. This is a bug in cassandra where it tries to open an IPv6 socket on 127.0.0.1, which is not possible since 127.0.0.1 is an IPv4 address. You may fix this problem with the following steps:

    #. Open */etc/cassandra/conf/cassandra-env.sh*, find and comment-out the line `JVM_OPTS="$JVM_OPTS -Djava.net.preferIPv4Stack=true"` (by adding a `#` at the beginning of the line). Example::
        
        #JVM_OPTS="$JVM_OPTS -Djava.net.preferIPv4Stack=true"
    #. Open */etc/cassandra/conf/cassandra.yaml*, find, and set the options `listen_address` and `rpc_address` to `"::1"` (NOTE: don't forget the double quotes). Example::
        
        listen_address: "::1"
        ...
        rpc_address: "::1"
    #. Restart *htpd* and *cassandra*::
    
         systemctl restart cassandra
         systemctl restart httpd
         

perfSONAR Project Questions
---------------------------

Q: How do I join the perfSONAR Collaboration?
==========================================================
**A:** Please contact us at perfsonar-lead@internet2.edu.


Q: Where can I ask questions or report bugs?
========================================================================================================================================================================================
**A:** For questions, send email to perfsonar-user at internet2 dot edu. You may also join the mailing list by visiting https://lists.internet2.edu/sympa/info/perfsonar-user. 

Report bugs at https://github.com/perfsonar/project/issues.


Q: Which licenses do perfSONAR products use?
========================================================================================================================================================================================
**A:** perfSONAR components are licensed under the Apache 2.0 license. 


Q: How does version numbering work for the perfSONAR project?
=======================================================================================

**A:** See https://github.com/perfsonar/project/wiki/Versioning if you are interested in learning about our version numbering scheme.




