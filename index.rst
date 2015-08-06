*******************************************
perfSONAR User Guide
*******************************************

perfSONAR is a collection of software for performing and sharing end-to-end network measurements. This document guides you through the process of installing, configuring and using the perfSONAR on one or more hosts. 


perfSONAR Installation Options
------------------------------
.. toctree::
   :maxdepth: 2
   
   install_options

perfSONAR Toolkit
-----------------

Installation
============
.. toctree::
   :maxdepth: 2
   
   install_quick_start
   install_sys_requirements
   install_getting
   install_centos_netinstall
   install_centos_fullinstall
   install_config_first_time
   
Managing the perfSONAR Toolkit
==============================
.. toctree::
   :maxdepth: 2
   
   manage_choose
   manage_regular_tests
   manage_admin_info
   manage_services
   manage_ntp
   manage_logs
   manage_update
   manage_users
   manage_tuning
   manage_dual_xface
   manage_security
   manage_extra_tools
   
Using the perfSONAR Toolkit
============================
.. toctree::
   :maxdepth: 2
   
   using_graphs
   using_ndt
   using_npad
   using_ext_tools

Additional Installation Options
--------------------------------
.. toctree::
   :maxdepth: 2

   install_centos 
   install_debian
   low_cost_nodes

Additional perfSONAR Tools
--------------------------

perfSONAR UI
============
.. toctree::
   :maxdepth: 2
   
   install_psui
   using_psui

Managing Multiple perfSONAR Hosts
----------------------------------

Introduction to Central Management
==================================
.. toctree::
   :maxdepth: 2
   
   multi_overview

Central Test Configuration
===========================
.. toctree::
   :maxdepth: 2
   
   multi_mesh_server_config
   multi_mesh_agent_config
   multi_mesh_autoconfig
   
Central Measurement Archive
===========================
.. toctree::
   :maxdepth: 2
   
   multi_ma_install
   multi_ma_clustering
   multi_ma_backups

Central Logging
===============
.. toctree::
   :maxdepth: 2
   
   multi_logging
   
Managing Nodes with Puppet
==========================
.. toctree::
   :maxdepth: 2
   
   multi_puppet_install
   multi_puppet_using
   
Accessing Raw Data 
------------------
.. toctree::
   :maxdepth: 1
   
   client_apis

Configuration Reference
-----------------------


BWCTL
=====
.. toctree::
   :maxdepth: 2
   
   config_bwctl
   config_bwctl_limits
   
Lookup Service Registration Daemon
==================================
.. toctree::
   :maxdepth: 2
   
   config_ls_registration
   
MeshConfig
==========
.. toctree::
   :maxdepth: 2
   
   config_mesh
   config_mesh_agent
   config_mesh_gui
   config_mesh_lookup_hosts
   
OPPD
====
.. toctree::
   :maxdepth: 2
   
   config_oppd

OWAMP
=====
.. toctree::
   :maxdepth: 2
   
   config_owamp
   config_owamp_limits

Regular Testing
===============
.. toctree::
   :maxdepth: 2
   
   config_regular_testing

Further Information
-------------------
* `Project Homepage <http://www.perfsonar.net>`_
* `Source Code Repository <https://github.com/perfsonar>`_
* `Issue Tracker <https://github.com/perfsonar/project/issues>`_
* `Project Wiki <https://github.com/perfsonar/project/wiki>`_
* `Frequently Asked Questions (FAQs) <http://www.perfsonar.net/about/faq/>`_
* Mailing Lists

  * `User Mailing List <https://lists.internet2.edu/sympa/subscribe/perfsonar-user>`_ - Forum where users may ask and answer questions about their perfSONAR deployments
  * `Announcement Mailing List <https://lists.internet2.edu/sympa/subscribe/perfsonar-announce>`_ - List where important announcements such as new releases and security updates are posted.

Related Projects
----------------
* `esmond <http://software.es.net/esmond/>`_
* `iperf3 <http://software.es.net/iperf/>`_
* `Lookup Service <http://code.google.com/p/simple-lookup-service/>`_
* `MaDDash <http://software.es.net/maddash/>`_
* `NDT <http://software.internet2.edu/ndt/>`_
* `psUI <https://forge.geant.net/forge/display/perfsonar/Change+Log/>`_
 
Search
----------------

* :ref:`search`
