***************************
perfSONAR on Low Cost Nodes
***************************

A number of folks in the perfSONAR community have been experimenting with running perfSONAR on low cost (less than $150) hardware such as the Raspberry Pi, the cubox, and the Liva. In general this works well, with some caveats. 

#. time sync issues: Some low end hardware have issues with clock drift, which impacts latency measurements. 
#. CPU performance issues: current ARM processors are not able to push TCP much more than about 300Mbps. Celeron processors do better, and get around 930Mbps. 
#. None of these devices are powerful enough to run the full perfSONAR toolkit which install a measurement archive.

The :doc:`perfsonar-testpoint <install_options>` bundle can be used to install everything you need to add a low-end node to a centrally managed test mesh with a central measurement archive.

System Requirements
===================

Most of these low cost devices seem to work best running Ubuntu. The perfsonar-testpoint bundle works on Ubuntu 12 and 14. We provide compatible Debian packages for 4 different hardware architectures:

  * 32-bit (i386)
  * 64-bit (amd64)
  * ARMv4t and up (armel)
  * ARMv7 and up (armhf)

We recommend a device with at least 1MB of RAM and 16MB of disk.

Installation Instructions
=========================

See instructions for installing the perfsonar-testpoint bundle: 
:doc:`install_debian`

Support
=======

Support for low cost node installations is provided by the perfSONAR community through the usual communication channels.
