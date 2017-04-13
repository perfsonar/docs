*******************************************
perfSONAR User Guide
*******************************************

perfSONAR is a collection of software for performing and sharing end-to-end network measurements. This document guides you through the process of installing, configuring and using perfSONAR on one or more hosts. 

.. _index-getting_started:

Getting Started
---------------
.. toctree::
   :maxdepth: 1
    
   intro_about

.. _index-planning:

Planning for Installation
-------------------------
.. toctree::
   :maxdepth: 1
   
   install_hardware
   install_small_node_details
   install_options
   
   
.. _index-installation:

Installation
------------
.. toctree::
   :maxdepth: 1
   
   install_toolkit
   install_centos
   install_debian


.. _index-toolkit:

perfSONAR Toolkit
-----------------

Toolkit Installation
====================
.. toctree::
   :maxdepth: 1
   
   install_quick_start
   install_getting
   install_centos_netinstall
   install_centos_fullinstall
   install_config_first_time
   install_migrate_centos7
   
Managing the perfSONAR Toolkit
==============================
.. toctree::
   :maxdepth: 1
   
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
   manage_limits
   manage_extra_tools
   manage_daemons
   
Using the perfSONAR Toolkit
============================
.. toctree::
   :maxdepth: 1
   
   using_graphs
   using_ext_tools


.. _index-pscheduler:

Running Measurements with pScheduler
-------------------------------------

Getting Started
====================
.. toctree::
   :maxdepth: 1

   pscheduler_intro

pScheduler Client Commands
==============================
.. toctree::
   :maxdepth: 1

   pscheduler_client_tasks
   pscheduler_client_schedule
   pscheduler_client_utils

pScheduler Server
=================
.. toctree::
   :maxdepth: 1
    
   pscheduler_server_running
   pscheduler_server_limits

pScheduler References and Guides
=================================
.. toctree::
   :maxdepth: 1
   
   pscheduler_ref_tests
   pscheduler_ref_tools
   pscheduler_ref_archivers
   pscheduler_ref_bwctl

.. _index-multiple:

Managing Multiple perfSONAR Hosts
----------------------------------

Introduction to Central Management
==================================
.. toctree::
   :maxdepth: 1
   
   multi_overview

Central Test Configuration
===========================
.. toctree::
   :maxdepth: 1
   
   multi_mesh_server_config
   multi_mesh_agent_config
   multi_mesh_autoconfig
   mca
   
Central Measurement Archive
===========================
.. toctree::
   :maxdepth: 1
   
   multi_ma_install
   multi_ma_clustering
   multi_ma_backups

Central Logging
===============
.. toctree::
   :maxdepth: 1
   
   multi_logging
   
Managing Nodes with Puppet
==========================
.. toctree::
   :maxdepth: 1
   
   multi_puppet_overview
   multi_puppet_install
   multi_puppet_using_server
   multi_puppet_using_client

.. _index-psui:

Additional Tools: perfsonarUI
-----------------------------
.. toctree::
   :maxdepth: 1
   
   install_psui
   using_psui


.. _index-config_ref:

Configuration Reference
-----------------------

.. toctree::
   :maxdepth: 1

   config_files
   config_ls_registration
   config_mesh
   config_mesh_agent
   config_mesh_agent_tasks
   config_mesh_gui
   config_mesh_lookup_hosts
   config_pscheduler
   config_pscheduler_limits
   config_owamp
   config_owamp_limits
   config_bwctl
   config_bwctl_limits
   config_oppd
   
.. _index-troubleshooting:

Troubleshooting
---------------
.. toctree::
   :maxdepth: 1

   troubleshooting_overview
   FAQ

.. _index-data_access:

Accessing Raw Data 
------------------
.. toctree::
   :maxdepth: 1
   
   client_tools
   client_apis

.. _index-previous_releases:

Previous Releases
-----------------
.. toctree::
   :maxdepth: 1
   
   previous_releases

.. _index-future_releases:

Future Releases
---------------
.. toctree::
   :maxdepth: 1
   
   install_rcs

.. _index-further_info:

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

.. _index-deployment:

Deployment Examples
-------------------
.. toctree::
   :maxdepth: 1
   
   deployment_examples

.. _index-related:

Related Projects
----------------
* `esmond <http://software.es.net/esmond/>`_
* `iperf3 <http://software.es.net/iperf/>`_
* `Lookup Service <http://code.google.com/p/simple-lookup-service/>`_
* `MaDDash <http://software.es.net/maddash/>`_
* `psUI <https://forge.geant.net/forge/display/perfsonar/Change+Log/>`_

.. _index-search:

Search
----------------

* :ref:`search`
