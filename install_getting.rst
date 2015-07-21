********************
Getting the Toolkit Software
********************

.. _GettingChooseInstall:

Choosing an Installation Method
===============================
The perfSONAR Toolkit is currently made available as an ISO image that can be mounted to media such as a CD, DVD or USB drive. This ISO contains a full |CentOS|_ operating system with additional perfSONAR packages required to perform, collect and publish network measurements. There are multiple variations of the ISOs available described below:

+-----------------------+----------------------------+---------------------------+
| Installation Type     | Description                | When to Use               |
+=======================+============================+===========================+
| |CentOS| NetInstall   | |centos_netinstall_descr|  | |centos_netinstall_when|  |
+-----------------------+----------------------------+---------------------------+
| |CentOS| Full Install | |centos_fullinstall_descr| | |centos_fullinstall_when| |
+-----------------------+----------------------------+---------------------------+

.. _GettingDownloads:

Downloads
=========

+----------------------------+--------------+-------------------------------------------------------------------------------+-----------------------------------+
| Installation Type          | Architecture | Downloads                                                                     | Step-by-Step Install Guide        |
+============================+==============+===============================================================================+===================================+
| |CentOS| NetInstall        | i386         | :centos_netinstall_iso:`iso <i386>` :centos_netinstall_md5:`md5 <i386>`       | :doc:`install_centos_netinstall`  |
+----------------------------+--------------+-------------------------------------------------------------------------------+-----------------------------------+
|                            | x86_64       | :centos_netinstall_iso:`iso <x86_64>` :centos_netinstall_md5:`md5 <x86_64>`   |                                   +
+----------------------------+--------------+-------------------------------------------------------------------------------+-----------------------------------+
| |CentOS| Full Install      | i386         | :centos_fullinstall_iso:`iso <i386>` :centos_fullinstall_md5:`md5 <i386>`     | :doc:`install_centos_fullinstall` |
+----------------------------+--------------+-------------------------------------------------------------------------------+-----------------------------------+
|                            | x86_64       | :centos_fullinstall_iso:`iso <x86_64>` :centos_fullinstall_md5:`md5 <x86_64>` |                                   +
+----------------------------+--------------+-------------------------------------------------------------------------------+-----------------------------------+


.. |centos_netinstall_descr|  replace:: The NetInstall is an ISO image that does not directly contain the packages to be installed, just pointers to where they can be downloaded when you run the install media. As a result, the download size of the ISO is relatively small since all the packages are downloaded at install-time. This means you will be getting the latest available versions of the software from the download servers. It also means the host on which you are installing the software MUST have external network connectivity to the CentOS and perfSONAR download servers.

.. |centos_netinstall_when|   replace:: If your host has external network connectivity this is the recommended installation method. The main reason it is recommended is that it will install the latest available packages on initial install.

.. |centos_fullinstall_descr| replace:: This installation type contains all the packages to be installed on the local ISO image. This not only leads to a larger ISO image but also eliminates the need to have external connectivity during the initial installation process. Since the packages are all included on the disc some software packages may be out of date if they were updated since the last time an ISO was generated. You will need to see :doc:`manage_update` if you want to make sure your host has the latest packages after installation. In cases of no networking connectivity it may also be impossible to update your toolkit since updates will need access to the download servers. 

.. |centos_fullinstall_when|  replace:: Use this in cases where the installation host has limited to no network connectivity to the CentOS and perfSONAR download servers. Be aware that this installation type may result in outdated packages initially and updates may be impossible if external network connectivity is not available even after the initial install. 

Alternative installation methods
================================
We now also provide some alternative installation methods based on bundles where only a subset of the perfSONAR toolkit is installed.  These bundles offer more flexibility in your installation options and are also supported on a wider OS selection.  See :doc:`install_bundles` for details.
