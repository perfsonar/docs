****************************
Installing Puppet
****************************

System Requirements
====================
* Any system capable of running puppet
* The puppet module has only been tested with **CentOS 6** at this time
* CentOS 6 requires the `EPEL` repository
* The puppet version in `EPEL` is old (2.7.23)
* Full installation instructions can be found in the `Puppet Install Documentation`_

.. _Puppet Install Documentation: http://docs.puppetlabs.com/guides/install_puppet/pre_install.html

Server Installation
============

1. Install the `EPEL` repository::

    sudo yum install epel-release

2. Install Puppet and Puppet Server ::

    sudo yum install puppet puppet-server

Client Installation
============

You must install puppet on each client node.

1. Install the `EPEL` repository::

    sudo yum install epel-release

2. Install the Puppet client::

    sudo yum install puppet

