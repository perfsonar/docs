***********
Host Tuning
***********

Default Tuning Settings
=======================
By default, the perfSONAR Toolkit installation follows the advice of ESnet's "fasterdata" knowledge base for test and measurement hosts:

http://fasterdata.es.net/host-tuning/linux/test-measurement-host-tuning/

These tuning settings should be fine for most uses of perfSONAR, but there are a couple of cases where you might want to adjust these.

  * 40G hosts (or even 2x10G bonded hosts)
  * hosts where much of your testing is over paths with more than 100ms RTT

For such cases, you may want to increase the max buffer settings in /etc/sysctl.conf, for example:

   .. code-block:: none

     #allow hand tuning up to 256MB buffers
     net.core.rmem_max = 268435456 
     net.core.wmem_max = 268435456 
     # allow auto-tuning up to 128MB buffers
     net.ipv4.tcp_rmem = 4096 87380 134217728
     net.ipv4.tcp_wmem = 4096 65536 134217728

Note that any time you upgrade the perfSONAR Toolkit, you should make sure your modified settings are still in place.

Manually Enabling Tuning Settings
=================================
In case you didn't use toolkit installation an optional *perfsonar-toolkit-sysctl* package is available that configures the system with perfSONAR settings. For more information on optional script installation see :ref:`install_el_installation`.

.. note:: In case your host has changed interface speed you can re-run ``/usr/lib/perfsonar/scripts/configure_sysctl`` script in order to tune system settings again. 

Packet Pacing
=============
CentOS7 and Debian now support "Fair Queuing" and kernel-level packet pacing. Pacing can be done on a per socket basis, or you can set a global maximum rate for each NIC on the host.

This can be very helpful for cases where you want to ensure that your perfSONAR host never uses all of your bandwidth. 
For example, to ensure your 10G host never exceeds 7Gbps, run this command:

   .. code-block:: none
   
     tc qdisc add dev $ETH root fq maxrate 7gbit

Where $ETH is the name of your host NIC. Add that command to /etc/rc.local to run at system boot time.

You can also configure your tasks to tell iperf3 to reduce it's bandwidth as well by using the ``bandwidth`` property in a *test* object's ``spec`` field. 

More details on host pacing are available at:
https://fasterdata.es.net/host-tuning/packet-pacing/

