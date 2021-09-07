***************************
Installing Additional Tools
***************************

You may install tools beyond what is installed on the perfSONAR Toolkit by default. Since the perfSONAR Toolkit is a Linux box, in general any tool compatible with such an environment may be installed. Note that doing so does bare some inherent risk since they may touch configuration files managed by Toolkit software or have additional security considerations. This page details some common additional packages that one may want to install on a Toolkit host.

MaDDash
=======
Description
------------
The Monitoring and Debugging Dashboard (MaDDash) is software for concisely displaying and analyzing the results of network measurements between multiple hosts. If you have a small collection of tests you may want to install MaDDash on the same host as one of your Toolkit nodes.

.. note:: It is recommended you install MaDDash on a separate, non-Toolkit host, to ensure it does not affect test results.

Installation
------------
You may install MaDDash with the following commands:
    
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

