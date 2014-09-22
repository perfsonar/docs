***************************
Installing Additional Tools
***************************

You may install tools beyond what is installed on the perfSONAR Toolkit by default. Since the perfSONAR Toolkit is a Linux box, in general any tool compatible with such an environment may be installed. Note that doing so does bare some inherent risk since they may touch configuration files managed by Toolkit software or have additional security considerations. This page details some common additional packages that one may want to install on a Toolkit host.

MaDDash
=======
The Monitoring and Debugging Dashboard (MaDDash) is software for concisely displaying and analyzing the results of network measurements between multiple hosts. If you have a small collection of tests you may want to install MaDDash on the same host as one of your Toolkit nodes.

.. note:: For large test sets it is recommended you install MaDDash on a dedicated non-Toolkit host for performance reasons. 

You may install MaDDash via yum with the following::
    
    yum install maddash
    
See the MaDDash web site `here <http://software.es.net/maddash>`_ for more details.

Cacti
=====
COMING SOON
