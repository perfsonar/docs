******************************
perfSONAR Installation Options
******************************

perfSONAR has historically been packaged as the **perfSONAR Toolkit**: an ISO containing a custom distribution of the CentOS operating system with all of the perfSONAR tools and services. The **perfSONAR Toolkit** is probably the best distribution for you if at least one or more of the following hold true:

* You are new to perfSONAR
* You plan to only deploy a small number of perfSONAR nodes
* You plan to use the CentOS operating system
* You do NOT wish to install perfSONAR on a host with the operating system already installed

Starting with perfSONAR 3.5, there are several other installation options as well for certain versions of both **CentOS** and **Debian/Ubuntu**:

#. **perfsonar-tools:** This bundle includes all tools used by perfSONAR. These tools are useful for network testing and troubleshooting in general, and we recommend you install these tools on any host where you need to maximize network performance, such as a `Data Transfer Node <http://fasterdata.es.net/science-dmz/DTN/>`_. 
#. **perfsonar-testpoint:** This bundle is targeted at organizations that run a centrally managed test mesh and use a central measurement archive. It contains all perfSONAR tools, including those to publish the location of these services to the perfSONAR Simple Lookup Service and to run scheduled measurements. This is also the bundle to use on :doc:`low-end hardware <low_cost_nodes>`.
#. **perfsonar-core:** The perfsonar-core install includes everything in the perfsonar-testpoint install plus the measurement archive. 
#. **perfsonar-toolkit:** This is the full set of perfSONAR packages Toolkit distribution. It includes everything in perfsonar-core and also contains web interfaces and Toolkit configuration. This provides an option for installing these packages without using the Toolkit ISO. 
#. **perfsonar-centralmanagement:** The perfsonar-centralmanagement bundle installs the :doc:`central mesh config </multi_overview>`, Maddash, centralized config service and the autoconfig. 

One of these options may be desirable if one or more of the following is true:

* You only wish to install a subset of the measurement tools
* You are managing a large deployment
* You would like to use an operating system other than the version of CentOS supported by the Toolkit (such as Debian or Ubuntu)
* You wish to install the perfSONAR packages on an existing host with an operating system pre-installed

.. _install_options_sysreq:

System Requirements 
===================

* **Operating System:**

  * Any system running either a 32-bit or 64-bit **CentOS 6** operating system should be able to follow the process outlined in this document. Other RedHat-based operating systems may work, but are not officially supported at this time.
  * Any system running either a 32-bit, 64-bit or ARM **Debian 7**, **Ubuntu 12** or **Ubuntu 14** is currently supported for the **perfsonar-testpoint** bundle.  Other Debian flavors derived from Debian 7 or Ubuntu 12 or 14 might work too but are not officially supported.

* **Hardware:** 

  * Most modern systems should be adequate to run the perfsonar-tools, perfsonar-testpoint and perfsonar-core bundles. We recommend at least 2GB of RAM and 20GB of disk space. 
  * For running a measurement archive, you should have at least 4GB of RAM, and 50GB of disk. 
  * You may want a 10Gbps network interface card depending on the throughput testing you wish to perform. 
  * See the `fasterdata.es.net hardware page <http://fasterdata.es.net/performance-testing/perfsonar/ps-howto/hardware/>`_ for suggested configurations.

.. seealso:: See the install instructions of each specific option for any further system requirements.
 

CentOS Toolkit ISO Installation 
===============================
* See :doc:`install_getting`

CentOS Bundle Installation 
==========================
* See :doc:`install_centos`

Debian Bundle Installation 
==========================
* See :doc:`install_debian` 




