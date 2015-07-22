******************************
perfSONAR Installation Options
******************************

perfSONAR has historically been packaged as a single large bundle of packages call the perfSONAR “Toolkit”. The toolkit includes all perfSONAR components, and is probably what you should start with if you are new to perfSONAR.

Starting with perfSONAR 3.5, there are several other installation options as well:


#. **perfSONAR-Tools:** This bundle includes all tools used by perfSONAR. These tools are useful for network testing and troubleshooting in general, and we recommend you install these tools on any host where you need to maximize network performance, such as a `Data Transfer Node <http://fasterdata.es.net/science-dmz/DTN/>`_. 
#. **perfSONAR-TestPoint:** This is the most basic perfSONAR installation, and is targeted at organizations that run a centrally managed test mesh and use a central measurement archive. It contains all perfSONAR tools, along with tools to publish the location of these services to the perfSONAR-PS Simple Lookup Service. This is also the bundle to use on low-end hardware such as the $100 Liva. 
#. **perfSONAR-Core:** The perfSONAR-Core install includes everything in the perfSONAR-TestPoint install plus clients to automatically run scheduled tests over specified time intervals. 
#. **perfSONAR-Complete:** This is considered the full perfSONAR-PS Toolkit rpms. It includes everything in perfSONAR-Core and also contains web interfaces and Toolkit configuration. It is useful if you already have a CentOS host and want to install only the rpms. Full install instructions is included in the document.
#. **perfSONAR-Toolkit ISO:** This installs CentOS and all the Toolkit rpms in perfSONAR-Complete. This is the usual perfSONAR-NetInstall. Full install instructions can be found at :doc:`install_centos_netinstall`.
#. **perfSONAR-CentralManagement:** The perfSONAR-CentralManagement Bundle installs the central mesh config, Maddash, centralized config service and the autoconfig. 

System Requirements 
===================

* **Operating System:**

  * Any system running either a 32-bit or 64-bit **CentOS 6** operating system should be able to follow the process outlined in this document. Other RedHat-based operating systems may work, but are not officially supported at this time.
  * Any system running either a 32-bit, 64-bit or ARM **Debian 7**, **Ubuntu 12** or **Ubuntu 14** is currently supported for the **perfSONAR-TestPoint** bundle.  Other Debian flavors derived from Debian 7 or Ubuntu 12 or 14 might work too but are not officially supported.

* **Hardware:** Most systems should be adequate to run the measurement tools. To run an archive, you should have at least 4GB of RAM, and 500GB of disk. You may want a 10Gbps network interface card depending on the throughput testing you wish to perform. See the `fasterdata.es.net hardware page <http://fasterdata.es.net/performance-testing/perfsonar/ps-howto/hardware/>`_ for some suggested configurations.

Bundle Installation 
===================

* :doc:`install_centos`
* :doc:`install_debian` 




