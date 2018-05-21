*********************************
perfSONAR on Low-cost Hardware 
*********************************

ARM Devices
============

A number of folks in the perfSONAR community have been experimenting with running perfSONAR on low cost (less than $130) hardware such as the Raspberry Pi, the cubox, and the Liva. In general this can work, with some caveats. 

#. Time sync issues: Some low end hardware have issues with clock drift, which impacts latency measurements. 
#. CPU performance issues: current ARM processors are not able to push TCP much more than about 300Mbps. 

Only the *perfsonar-tools* or *perfsonar-testpoint* bundles should be considered on this class of device.


Celeron Devices
================

perfSONAR tools and services will work better on devices that cost around $200 such as the Intel NUC series, Zotac Zbox ci320 (2.1GHz CPU)/ci323 (dual NIC), GIGABYTE BRIX and various other examples available on the market as barebones small PC solutions. A number of these fulfill perfSONAR general requirements of 4GB RAM and four 2.1GHz cores, and thus should work well. Try to find a device with a fan and dual NICs if possible. These devices are capable of 1Gbps TCP.

Please note that the perfSONAR team is not formally endorsing any particular product. These are just an example of possible solutions.


System Requirements
===================

ARM-based devices seem to work best running Ubuntu, while the slightly larger, $200-class nodes will usually work with CentOS, Debian or Ubuntu. The :doc:`perfsonar-testpoint <install_options>` bundle works on CentOS 7 and Ubuntu 14, 
and Debian "Wheezy" and "Jessie". We provide compatible Debian packages for 4 different hardware architectures:

  * 32-bit (i386)
  * 64-bit (amd64)
  * ARMv4t and up (armel) - not recommended for the full testpoint bundle
  * ARMv7 and up (armhf) - not recommended for the full testpoint bundle



Installation Instructions
=========================

The :doc:`perfsonar-testpoint <install_options>` bundle can be used to install everything you need to add a low-end node to a centrally managed test mesh with a central measurement archive. See: 

- :doc:`install_centos`
- :doc:`install_debian`

Certain devices like the Liva use an EMMC drive that is only supported in the *deskop* version of Ubuntu. 
If the standard server ISO installation doe not recognize the drive, it may be worth attempting installation using the desktop ISO such as `Ubuntu 14.04.05 Desktop <http://releases.ubuntu.com/trusty/ubuntu-14.04.5-desktop-amd64.iso>`_.

Support
=======

Support for low cost node installations is provided by the perfSONAR community through the usual communication channels.


.. _install_low_cost_nodes-more-info:

Additional information
======================

Many details on small nodes issues are described in this paper:
  http://www.es.net/assets/pubs_presos/20160701-Chevalier-perfSONAR.pdf
  
See also the :doc:`deployment examples <deployment_examples>` section for additional information about low cost nodes deployment.

