****************************
Puppet management overview
****************************

Introduction
====================
`Puppet`_ is an open source configuration management system for managing multiple systems. It features a declarative configuration model that allows you to specify the desired state of your services and enforces it as needed.

.. _Puppet: https://puppetlabs.com/puppet/open-source-projects

Puppet can be used to install, configure, update, and manage the state of any services, including perfSONAR related services. Puppet can run on various platforms, but currently the perfSONAR puppet modules have only been tested with CentOS 6.

Architecture
============

With Puppet's, one central server (the "puppet master") provides the configuration for the entire group of nodes being managed, and any number of client nodes that retrieve their configurations from the master.

