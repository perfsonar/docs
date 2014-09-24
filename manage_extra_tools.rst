***************************
Installing Additional Tools
***************************

You may install tools beyond what is installed on the perfSONAR Toolkit by default. Since the perfSONAR Toolkit is a Linux box, in general any tool compatible with such an environment may be installed. Note that doing so does bare some inherent risk since they may touch configuration files managed by Toolkit software or have additional security considerations. This page details some common additional packages that one may want to install on a Toolkit host.

perfsonarUI
============
Description
------------
perfsonarUI (psUI) is a web application for running and visualizing on-demand tests between perfSONAR measurement points (MPs) or visualizing historical measurement results obtained from perfSONAR measurement archives (MAs). It is designed to be intuitive and user friendly, thus allowing the network operator the troubleshoot network problems as efficiently as possible. The perfSONAR Toolkit by default contains a service named OPPD that allows for integration into perfsonarUI.

Installation
------------
The installation guide describes the deployment of the psUI for RPM based or Debian distributions. You can `download it here <http://downloads.perfsonar.eu/repositories/documents/perfsonarUI_installation_guide.pdf>`_.

Current version of the psUI is 1.3.1 and can be downloaded as:

    * An `RPM package <http://downloads.perfsonar.eu/repositories/rpm/stable/6/noarch/Packages/perfsonar-ui-web-1.3.1-rpm.rpm>`_ for RHEL 6, CentOS 6 or Scientific Linux 6.
    * A `Debian 7 package <http://downloads.perfsonar.eu/repositories/deb/pool/main/p/perfsonar-ui-web/perfsonar-ui-web_1.3.1_all.deb>`_.
    
    .. note:: If installing directly on your Toolkit host you will need to use the RPM. 

Source Code
-----------
The perfSONAR UI source code can be browsed or retreived with subversion::
    
    svn co http://svn.geant.net/GEANT/SA2/ps-visualisation-tools/perfsonar-ui-web/

Usage
-----
A user guide describing how to use the psUI user interface can be `downloaded here <http://downloads.perfsonar.eu/repositories/documents/perfsonarUI_user_guide_1.4.pdf>`_. This guide covers each feature of the UI:

    * How to select a perfSONAR service
    * How to access historical measurements
    * How to make an on-demand measurement
    * How to troubleshoot a path
    * How to configure the UI
    * How to configure authentication with an indentity provider

MaDDash
=======
Description
------------
The Monitoring and Debugging Dashboard (MaDDash) is software for concisely displaying and analyzing the results of network measurements between multiple hosts. If you have a small collection of tests you may want to install MaDDash on the same host as one of your Toolkit nodes.

.. note:: For large test sets it is recommended you install MaDDash on a dedicated non-Toolkit host for performance reasons. 

Installation
------------
You may install MaDDash via yum with the following::
    
    yum install maddash

Usage
-----
See the MaDDash web site `here <http://software.es.net/maddash>`_ for a complete guide.

Source Code
-----------
The MaDDash source code can be obtained from https://github.com/esnet/maddash


Cacti
=====
COMING SOON
