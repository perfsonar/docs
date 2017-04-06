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
The :doc:`install_psui` describes the deployment of the psUI for RPM or Debian based distributions using native package system or downloaded packages.

.. include:: psui_artifacts.rst

Source Code
-----------
The perfSONAR UI source code can be browsed via `Fisheye interface <https://svn.geant.net/fisheye/browse/SA2T3-ps-visualisation-tools>`_ or retrieved with subversion: 

::  
    svn co http://svn.geant.net/GEANT/SA2/ps-visualisation-tools/perfsonar-ui-web/

Usage
-----
The user guide describing how to use the psUI user interface can be :doc:`found here <using_psui>`. This guide covers each feature of the UI:

    * How to select a perfSONAR service
    * How to access historical measurements
    * How to make an on-demand measurement
    * How to troubleshoot a path
    * How to configure the UI
    * How to configure authentication with an identity provider

MaDDash
=======
Description
------------
The Monitoring and Debugging Dashboard (MaDDash) is software for concisely displaying and analyzing the results of network measurements between multiple hosts. If you have a small collection of tests you may want to install MaDDash on the same host as one of your Toolkit nodes.

.. note:: It is recommended you install MaDDash on a separate, non-Toolkit host, to ensure it does not affect test results.

Installation
------------
You may install MaDDash with the following commands::
    
*CentOS*::

    yum install maddash

*Debian, Ubuntu*::

    apt-get install maddash

Usage
-----
See the MaDDash web site `here <http://software.es.net/maddash>`_ for a complete install and user guide.

Source Code
-----------
The MaDDash source code can be obtained from https://github.com/esnet/maddash

