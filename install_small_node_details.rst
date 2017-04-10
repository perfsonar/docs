:orphan:

****************************************************************************
Detailed Information and Recommendations for perfSONAR on Low-cost Hardware 
****************************************************************************

A number of folks in the perfSONAR community have been experimenting with running perfSONAR on low cost (less than $150) hardware such as the Raspberry Pi, the cubox, and the Liva. Other works experimented with a bit more expensive (about 200 Euros) hardware like GIGABYTE BRIX. In general this works well, with some caveats. 

#. Time sync issues: Some low end hardware have issues with clock drift, which impacts latency measurements. 
#. CPU performance issues: current ARM processors are not able to push TCP much more than about 300Mbps. Celeron processors do better, and get around 930Mbps. 
#. None of these devices are powerful enough to run the full perfSONAR toolkit which install a measurement archive.

Instead of running an entire perfSONAR Toolkit with a local MA and a web UI and all that, these nodes are best to be run as testpoints and report their results back to a centrally configured measurement archive. The :doc:`perfsonar-testpoint <install_options>` bundle can be used to install everything you need to add a low-end node to a centrally managed test mesh with a central measurement archive.

For installation of Ubuntu from a standard ISO, there is also a script to help autoconfigure the perfsonar repositories and get the required software setup. See the :doc:`low cost nodes configuration <low_cost_nodes_configuration>` section for more information.

.. _install_low_cost_nodes-sysreq:

System Requirements
===================

Most of these low cost devices seem to work best running Ubuntu. The perfsonar-testpoint bundle works on Ubuntu 14. We provide compatible Debian packages for 4 different hardware architectures:

  * 32-bit (i386)
  * 64-bit (amd64)
  * ARMv4t and up (armel)
  * ARMv7 and up (armhf)

We recommend a device with at least 1GB of RAM and 16MB of disk. Many devices will fit these requirements and more depending on your desire and ability to experiment or tinker. 

At this point in time, the most extensively tested platform in this category is the `$100 Liva <http://www.ecs.com.tw/ECSWebSite/Product/Product_LIVA_SPEC.aspx?DetailID=1560&LanID=0>`_ and its second generation the `$150 Liva X <http://www.ecs.com.tw/ECSWebSite/Product/Product_LIVA.aspx?DetailID=1593&LanID=0>`_. Each of these is capable of full 1Gbps and work with a standard Ubuntu Desktop ISO installation.

The Liva X being the second generation hardware seems to be more robust and comes pre-assembled, though a bit more expensive. Both are available for purchase on common sites such as Newegg or Amazon.

Please note that the perfSONAR team is not formally endorsing this particular product - just providing it as an example of a possible turnkey solution for users interested in that sort of thing.

.. _install_low_cost_nodes-instructions:

Installation Instructions
=========================

See instructions for installing the perfsonar-testpoint bundle for Debian: 
:doc:`install_debian`

For installation of Ubuntu from a standard ISO, there is also a script to help autoconfigure the perfsonar repositories and get the required software setup. See the :doc:`low cost nodes configuration <low_cost_nodes_configuration>` section for more information.

.. _install_low_cost_nodes-more-info:

Additional information
======================

Many details on small nodes issues are described in this paper:
  http://www.es.net/assets/pubs_presos/20160701-Chevalier-perfSONAR.pdf
  
See also :doc:`deployment examples <deployment_examples>` section for additional information about low cost nodes deployment examples.

