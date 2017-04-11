***************************
perfSONAR on Low Cost Nodes
***************************

pi-class Devices
================

A number of folks in the perfSONAR community have been experimenting with running perfSONAR on low cost (less than $200) hardware such as the Raspberry Pi, the cubox, and the Liva. In general this can work, with some caveats. 

#. Time sync issues: Some low end hardware have issues with clock drift, which impacts latency measurements. 
#. CPU performance issues: current ARM processors are not able to push TCP much more than about 300Mbps. Celeron processors do better, and get around 930Mbps. 
#. None of these devices are powerful enough to run the full perfSONAR toolkit which install a measurement archive.
#. pSchdeuler may not be suitable for use on pi-class/ARM devices.


$200-class devices
==================

More stable are the small nodes closer in cost to $200, such as the Intel NUC series, Zotac Zbox ci320/ci323, and various other examples available on the market as barebones small PC solutions.

For installation of Ubuntu from a standard ISO, there is also a script to help autoconfigure the perfsonar repositories and get the required software setup. See the :doc:`low cost nodes configuration <low_cost_nodes_configuration>` section for more information.

*******************
System Requirements
*******************

Pi-class devices seem to work best running Ubuntu, but the slightly larger, $200-class nodes will perform using Cnetos or Ubuntu. The perfsonar-testpoint bundle works on Centos 6 and 7, and Ubuntu 12 and 14 - Debian "Wheezy" and "Jessie". We provide compatible Debian packages for 4 different hardware architectures:

  * 32-bit (i386)
  * 64-bit (amd64)
  * ARMv4t and up (armel) - not recommended
  * ARMv7 and up (armhf) - not recommended

$200-class devices should have at least 2GB of RAM and 16MB of disk. Processor should be quad-core with a 2.1GHz speed preferred. Many devices will fit these requirements and more depending on your desire and ability to experiment or tinker. Several brands and models of nodes have been tested running the newest perfSONAR releases. Each of these is capable of near 1Gbps and work with a number of OS releases. 

Raspbian and Bananian may be options for 

Please note that the perfSONAR team is not formally endorsing this particular product - just providing it as an example of a possible turnkey solution for users interested in that sort of thing.


Installation Instructions
=========================

See instructions for installing the perfsonar-testpoint bundle: 
:doc:`install_centos`
:doc:`install_debian`

For installation of Ubuntu from a standard ISO, there is also a script to help autoconfigure the perfsonar repositories and get the required software setup. See the :doc:`low cost nodes configuration <low_cost_nodes_configuration>` section for more information.

The :doc:`perfsonar-testpoint <install_options>` bundle can be used to install everything you need to add a low-end node to a centrally managed test mesh with a central measurement archive.

Certain devices, like the Liva, with EMMC drives require use of Debian/Ubuntu desktop builds to ensure the necessary driver is in place. If the standard server ISO installations do not recognize the onboard memory, it may be worth attempting installation using the desktop ISO versions:
  * `Ubuntu 12.04.05 <http://releases.ubuntu.com/12.04/ubuntu-12.04.5-desktop-amd64.iso>`_ Desktop ISO installation.

Support
=======

Support for low cost node installations is provided by the perfSONAR community through the usual communication channels.
