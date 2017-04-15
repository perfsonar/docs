******************************
perfSONAR Installation Options
******************************

perfSONAR has historically been packaged as the **perfSONAR Toolkit**: an ISO containing a custom distribution of the CentOS operating system with all of the perfSONAR tools and services (including the software required to automatically run tests on a regular schedule, participate in a centrally managed mesh of tests, publish the existence of a measurement node, archive used to store results and web interface). The **perfSONAR Toolkit ISO** is probably the best distribution for you if at least one or more of the following hold true:

* You are new to perfSONAR
* You plan to only deploy a small number of perfSONAR nodes
* You plan to use the CentOS operating system
* You do NOT wish to install perfSONAR on a host with the operating system already installed

There are several other installation options as well for certain versions of both **CentOS** and **Debian/Ubuntu**:

#. **perfsonar-tools:** This bundle includes just the command-line clients needed to run on-demand measurements such as iperf, iperf3, bwctl and owamp. This bundle is generally best for hosts that aren't dedicated measurement nodes but want the command-line utilities available for troubleshooting as the need arises.
#. **perfsonar-testpoint:** This bundle includes everything from the perfsonar-tools bundle as well as the software required to:
      * Automatically run tests on a regular schedule
      * Participate in a centrally managed mesh of tests 
      * Publish the existence of a measurement node 

    This bundle does NOT contain the software required to store measurements locally in an archive; the archive must be remote. This is best for dedicated testers running on lightweight hardware platforms that have a remote location in which to publish results.
#. **perfsonar-core:** The perfsonar-core bundle install includes everything in the perfsonar-testpoint bundle install plus the esmond measurement archive used to store results. This is ideal for dedicated measurement hosts that want to store results locally, but do not want a perfSONAR Toolkit install. In other words, they do not want to use a web interface and want the flexibility to choose default security and tuning settings.
#. **perfsonar-toolkit:** This bundle includes everything in perfsonar-core bundle plus:
    * The web interface used to manage tests
    * Scripts used to apply system-wide default tuning and security settings

    This bundle is for those that wish to install the full suite of tools included on the perfSONAR Toolkit ISO but on an existing Linux system. 
#. **perfsonar-centralmanagement:** The perfsonar-centralmanagement bundle is independent from the bundles above and installs tools needed to centrally manage a large number of hosts and display their results. This includes the esmond measurement archive, tools for building meshes, and dashboard software for displaying results (maddash). 

.. image:: images/install_options-bundle_tree.png


This flowchart was created to help pick the correct option:

.. image:: images/bundle_flowchart.png

 

CentOS Toolkit ISO Installation 
===============================
* See :doc:`install_getting`

CentOS Bundle Installation 
==========================
* See :doc:`install_centos`

Debian Bundle Installation 
==========================
* See :doc:`install_debian` 




