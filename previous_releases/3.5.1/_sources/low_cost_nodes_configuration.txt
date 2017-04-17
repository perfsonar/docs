****************************
Low Cost Nodes Configuration
****************************

Introduction
============

Running low cost nodes function in much the same way as running a "regular" perfsonar node with a few exceptions. Instead of running an entire toolkit stack with a local MA and a web UI and all that, these nodes are intended to be run as testpoints and report their results back to a centrally configured measurement archive. See the "System Requirements" section of the :doc:`low cost nodes <low_cost_nodes>` page for more information on specifications.


Configuration
=============

There is currently no pre-configured ISO installation for Debian or CentOS that is not a full toolkit install. The following assumes that an `Ubuntu 12.04.05 <http://releases.ubuntu.com/12.04/ubuntu-12.04.5-desktop-amd64.iso>`_ has been installed on your device via standard means such as a USB stick and that network connectivity is available.

The following is a script to automatically set up a few important things such as SSH, NTP, the perfSONAR repositories, the stock perfSONAR tuning and security, as well as auto updates. Simply copy/paste these instructions and at the end you will be left with a fully functional perfSONAR Ubuntu testpoint.

	.. code-block:: console 
	
		# wget http://docs.perfsonar.net/_static/setup_debian_testpoint.sh
		# sudo sh setup_debian_testpoint.sh


To verify it completed successfully, you should be able to see processes like bwctl-server and owamp-server running. Ad hoc tests using bwctl or iperf directly are now possible. See below for information on setting up mesh based regular testing.

Alternatively, you can walk through all of the steps manually for :doc:`Debian/Ubuntu here <install_debian>` or for :doc:`CentOS here <install_centos>`.


Mesh Configuration
==================

perfSONAR 3.5 added the ability to add "tags" to mesh and mesh agent configuration files, allowing for auto discovery and joining of meshes. It is highly encouraged that small nodes make use of this feature to maintain sanity while adding and removing nodes. For more information on mesh auto configuration, :doc:`see this page <multi_mesh_autoconfig>`.

It is also encouraged that MA setup be :doc:`based on IP <multi_ma_install>`, though not required. If IP based auth is not setup, the MA credential information will need to be setup in the regular testing file on the small node so that it is able to authenticate sending results back.


