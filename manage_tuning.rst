***********
Host Tuning
***********

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


