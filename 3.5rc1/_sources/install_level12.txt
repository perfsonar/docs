***************************
Level 1 and 2 Installations
***************************

perfSONAR combines a number of measurement tools and services. Depending on your needs, you may need only a subset of the software. As such, we have defined three levels of installation that users may perform:

#. **Level 1:** This is the most basic perfSONAR installation. It contains a bwctl and owamp server along with tools to publish the location of these services to the perfSONAR-PS Simple Lookup Service.  This type of installation also contains the bwctl, owamp and ndt command-line clients so that you may run one-time tests to other servers. This installation does not include tools on the target host to initiate tests that run on regular time intervals nor does it contain measurement archives that store result of tests.  The Level 1 install includes everything you need to run one-time tests and for others to find/schedule tests to your site. Full install instructions are contained within the document.
#. **Level 2:** The Level 2 install includes everything in the Level 1 install plus clients to automatically run scheduled tests over specified time intervals. It also includes centralized configuration software that can distribute test configurations across multiple hosts. Full install instructions can be found within this document.
#. **Level 3:** This is considered the full perfSONAR-PS Toolkit. It included everything from Level 1 and Level 2, in addition to web interfaces and measurement archives. Full install instructions can be found at :doc:`install_centos_netinstall`.

System Requirements 
==================== 
* **Operating System:** Any system running either a 32-bit or 64-bit CentOS 6 operating system should be able to follow the process outlined in this document. Other RedHat-based operating systems may work, but are not officially supported at this time.
* **Hardware:** Most base-level systems should be adequate to run the measurement tools. You may want to explore a 10Gbps network interface card depending on the throughput testing you wish to perform. See the `fasterdata.es.net hardware page <http://fasterdata.es.net/performance-testing/perfsonar/ps-howto/hardware/>`_ for some suggested configurations.

Level 1 Installation 
===================== 

If you would like to do a Level 1 Installation, follow the instructions found in this section.

.. _level1_step1:

Step 1: Configure Yum 
---------------------- 
The process configures yum to point at the necessary repositories to get packages needed for perfSONAR. You will need to follow the steps below:

1. Install the EPEL RPM (Note: For i386 systems replace x86_64 with i386)::
::

    rpm -hUv https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm


2. Install the Internet2-repo RPM  (Note: For i386 systems replace x86_64 with i386):
::

    rpm -hUv http://software.internet2.edu/rpms/el6/x86_64/main/RPMS/Internet2-repo-0.5-7.noarch.rpm


4. Refresh yum's cache so it detects the new RPMS
::

    yum clean all


.. _level1_step2:

Step 2: Install the Level 1 RPM 
-------------------------------- 
Install the perfSONAR_PS-Bundles-Level1 package containing the required tools:
::

    yum install perfSONAR_PS-Bundles-Level1


This will install all the perfSONAR tools, dependencies, boot scripts, create pseudo-users, etc. Once yum completes all the software will be installed, and we can move on to the configuration and verification phases.

.. _level1_step3:

Step 3: Verify NTP and Tuning Parameters 
----------------------------------------- 
The Network Time Protocol (NTP) is required by the tools in order to obtain accurate measurements. Some of the tools such as BWCTL will not even run unless NTP is configured. You can verify NTP is running with the following command:
::

    /usr/sbin/ntpq -p


Also, it is important to make sure that your host is properly tuned for maximum TCP performance on the WAN. You should verify that cubic, not reno, is the default TCP congestion control algorithm, and that the maximum TCP buffers are big enough for your paths of interest. For more information see the `host tuning linux page <http://fasterdata.es.net/host-tuning/linux/>`_ on fasterdata.es.net.

.. _level1_step4:

Step 4: Firewall and Security Considerations 
--------------------------------------------- 

If your host is behind any ACLs or firewalls you should review `perfSONAR FAQ entry <http://www.perfsonar.net/about/faq/#Q6>`_ and/or the `document here <http://stats.es.net/ps-downloads/20130308-Firewall-PerfWG.pdf>`_ on the ports that need to be open.

Additionally, bwctl allows you to limit the parameters of tests such as duration and bandwidth based on the requesters IP address. It does this through a file called bwctld.limits. You may read the bwctld.limits man page or look at the example file provided under /etc/bwctld/bwctld.limits file. ESnet uses a bwctld.limits file that some sites may find useful. This file is based on the routing table and is updated regularly. It implements the following general policies:

* Allow unrestricted UDP tests from ESnet test system prefixes.
* Allow up to 200Mbps UDP tests from ESnet sites.
* Deny UDP tests from any other locations.
* Allow TCP tests from IPV4 and IPv6 addresses in the global Research and Education community routing table.
* Deny TCP tests from everywhere else.

To use the ESnet bwctld.limits file, get this file from ESnet as follows:
::

    cd /etc/bwctld
    mv bwctld.limits bwctld.limits.dist
    wget --no-check-certificate http://stats.es.net/sample_configs/bwctld.limits

ESnet provides a shell script that will download and install the latest bwctld.limits file. The bwctld.limits file is generated once per day between 20:00 and 21:00 Pacific Time. You can run the shell script from cron to keep your bwctld.limits file up to date (it is recommended that you do this outside the time window when the new file is being generated). To download the shell script from the ESnet server do the following:
::

    cd /etc/bwctld
    wget --no-check-certificate http://stats.es.net/sample_configs/update_limits.sh
    chmod +x update_limits.sh

.. _level1_step5:

Step 5: Register your services 
------------------------------- 

In order to publish the existence of your measurement services there is a single file you need to edit with some details about your host. You may populate this information by opening **/opt/perfsonar_ps/ls_registration_daemon/etc/ls_registration_daemon.conf**. You will see numerous properties you may populate. They are commented out meaning you need to remove the ``#`` at the beginning of the line for them to take effect. The properties you are **required** to set are as follows:

::

    ##Hostname or IP address others can use to access your service
    #external_address   myhost.mydomain.example
    
    ##Primary interface on host
    #external_address_if_name eth0

and the other entries (administrator_email, site_name, city, country, latitude, longitude, etc.) are **highly recommended**.

In the example above remove the leading ``#`` before external_address and external_address_if_name respectively. Also replace *myhost.mydomain.example* and *eth0* with the values relevant to your host. There are additional fields available for you to set. None of them are required but it is highly recommended you set as many as possible since it will make finding your services easier for others. More information on the available fields can be found in the configuration file provided by the RPM install. 

.. _level1_step6:

Step 6: Starting your services 
------------------------------- 
You can start all the services by rebooting the host since all are configured to run by default. Otherwise you may start them with the following commands as a root user:
::

    /etc/init.d/bwctld start
    /etc/init.d/owampd start
    /etc/init.d/ls_registration_daemon start

Note that you may have to wait a few hours for NTP to synchronize your clock before starting bwctld and owampd.

Level 2 Installation 
===================== 
If you would like to do a Level 2 Installation, follow the instructions found in this section.

Step 1: Configure Yum (see Level 1 instructions) 
------------------------------------------------- 
Follow :ref:`level1_step1` of the Level 1 instructions exactly then proceed to the next step. 

Step 2: Install the Level 2 RPM 
-------------------------------- 
Install the perfSONAR_PS-Bundles-Level2 package containing the required tools:
::

    yum install perfSONAR_PS-Bundles-Level2


This will install all the perfSONAR tools, dependencies, boot scripts, create pseudo-users, etc. Once yum completes all the software will be installed, and we can move on to the configuration and verification phases.

Step 3-6: Repeat Level 1 Steps 3-6 
----------------------------------- 
Repeat each of the following from the Level 1 installation:

* :ref:`level1_step3`
* :ref:`level1_step4`
* :ref:`level1_step5`
* :ref:`level1_step6`

Step 7: Setup the Mesh Configuration 
------------------------------------- 

If a test mesh already exists this may just be a matter of editing the URL in /opt/perfsonar_ps/mesh_config/etc/agent_configuration.conf. A future document will cover generating a MeshConfig file.