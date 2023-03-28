*************************************
Hardware Requirements
*************************************

The requirements for the perfsonar-core, perfsonar-toolkit, and perfsonar-archive bundles are a minimum of 4 cores and 4GB of RAM. 
The perfsonar-testpoint bundle may work with 2GB of RAM, but 4GB is recommended. 
The clock speed requirements depends on how fast your network is, but we recommend
at least 2GHz cores in general, and 2.8GHz or higher if you want to test 10G paths.

For more information see :doc:`install_hardware_details`.

Virtual Machines
================

In general we do not recommend running perfSONAR on a VM unless you have a way to guarantee a certain amount of NIC bandwidth 
for the perfSONAR VM. Otherwise its very hard to interpret the results. But if a VM is your only option, perfSONAR can still 
be quite helpful for troubleshooting.

For more information see :doc:`install_virtual_machine_details`.

Containers 
==========

We support running the perfSONAR testpoint bundle in a Docker container.
See: `DockerHub <https://hub.docker.com/r/perfsonar/testpoint/>`_

Low-Cost Nodes
==============

perfSONAR can also be run on very small cheap hardware with varying level of success.
There are a variety of perfSONAR use cases where low-end hardware may make sense. These include:

- owamp receiver: the ability to respond to owamp packet loss testing only. 

  - Low end hardware such as a Raspberry Pi has been shown to work fine for this use case.
  - note that the clock on a Raspberry Pi is not accurate for good latency/jitter measurements, but loss works fine.

- portable 1G test node for ad-hoc testing (perfsonar-tools bundle)

  - Requires two 2GHz cores (fore cores recommended) and 1GB RAM
  - sample hardware includes: GigaByte Brix model GBBXBT2807

- 1G Tester with perfsonar-testpoint bundle installed

  - Requires two 2GHz cores (four cores recommended) and 2GB RAM (4GB recommended)
  - sample hardware includes: Zotac Zbox model nano ci320, Intel NUC model NUC5CPYH

- perfSONAR Toolkit running a small number of central managed measurements

  - Requires two 2GHz cores (four cores recommended) and 4GB RAM
  - sample hardware includes Zotac Zbox model nano ci323 (dual NIC), Intel NUC model NUC5CPYH


For more information see :doc:`install_small_node_details`.


