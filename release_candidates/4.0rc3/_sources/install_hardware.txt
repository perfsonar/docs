*************************************
Hardware Requirements
*************************************

The main requirements for perfSONAR are a minimum of 2 cores and 4GB of RAM.
The clock speed of your cores depends on how fast your network is, but we recommend
at least 2GHz cores in general, and 2.8GHz or higher if you want to test 10G paths.

For more information see :doc:`install_hardware_details`.

Virtual Machines
================

In general we do not recommend running perfSONAR on a VM unless you have a way to guarantee a certian amount of NIC bandwidth 
for the perfSONAR VM. Otherwise its very hard to interpret the results. But if a VM is your only option, perfSONAR can still 
be quite helpful for troubleshooting.

For more information see :doc:`install_virtual_machine_details`.

Containers 
==========

While not yet fully supported, perfSONAR tools seem to work well in a Linux container such as Docker.
See: `DockerHub <https://hub.docker.com/r/bltierney/perfsonar-testpoint-docker/>`_

Low-Cost Nodes
==============

perfSONAR can also be run on very small cheap hardware with varying level of success.
We do not recommend running perfSONAR on ARM-based systems such as the Raspberry Pi,
but perfSONAR seems to work fine on Intel Celeron-based systems such as the GigaByte BRIX.

For more information see :doc:`install_small_node_details`.


