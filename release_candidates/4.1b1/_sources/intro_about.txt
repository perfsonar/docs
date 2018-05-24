******************
What is perfSONAR?
******************

perfSONAR is a collection of open source software for performing and sharing end-to-end network measurements. It consists of multiple tools brought together in a manner best illustrated in the diagram below:

.. image:: images/intro_about-arch.png
        :target: _images/intro_about-arch.png

Your deployment may install some or all of the components depending on your goals. See :doc:`install_options` for a discussion on how to choose a deployment strategy that best suits your needs.

The sections that follow provide a brief in overview of the components at each layer and provide links to more detail where applicable. 

.. _intro_about-tools:

Tools
-----
perfSONAR includes numerous utilities responsible for carrying out the actual network measurements and form the foundational layer of perfSONAR. In general, you will not invoke these tools directly but instead use the :doc:`pscheduler<pscheduler_intro>` command from the :ref:`scheduling <intro_about-scheduling>` layer to execute them. The default tools that come with perfSONAR include:

    * owamp_ - A tool primarily used for measuring packet loss and one-way delay. It includes the command *owping* for single short-lived tests and the *powstream* command for long-running background tests. 
    * iperf3_ - A rewrite of the classic iperf tool used to measure network throughput and associated metrics.
    * iperf2_ - Also known as just *iperf*, a common tool used to measure network throughput that has been around for many years.
    * nuttcp_ - Another throughput tool with some useful options not found in other tools. 
    * traceroute_ - The classic packet trace tool used in identifying  network paths
    * tracepath_ - Another path trace tool that also measures path MTU
    * paris-traceroute_ - A packet trace tool that attempts to identify paths in the presence of load balancers
    * ping_ - The classic utility for determining reachability, round-trip time (RTT) and basic packet loss.

.. _intro_about-scheduling:

Scheduling
----------
The scheduling layer consists of a single tool named :doc:`pScheduler<pscheduler_intro>` and is responsible for:

    #. Finding time-slots to run the :ref:`tools <intro_about-tools>` while avoiding scheduling conflicts that would negatively impact results
    #. Executing the tools and gathering results
    #. Sending to the results to the :ref:`archiving<intro_about-archiving>` layer (if needed)
    
More information on using the pScheduler can be found in the section :ref:`index-pscheduler`.

.. _intro_about-archiving:

Archiving
----------
The archiving layer currently consists a single component named esmond_ that stores measurement information as time-series data. It is often referred to as the *measurement archive (MA)* and the term is used interchangeably with *esmond*. It can be installed on each measurement host if they meet hardware requirements or a single central instance may store results from multiple measurement hosts. For more information on esmond see the `esmond documentation <http://software.es.net/esmond>`_. For information on running a central measurement archive see :doc:`multi_ma_install`.

.. note: The :doc:`pScheduler<pscheduler_intro>` component does allow the creation of plug-ins for sending results to other types of archives, this is just the setup included with relevant perfSONAR bundles by default. See :doc:`pscheduler_ref_archivers` for a list of a few other options currently available as plug-ins. 

.. _intro_about-configuration: 

Configuration
-------------

The configuration layer is where desired measurements are defined along with instructions on where to store them. The primary component as this layer is called the *MeshConfig*. The MeshConfig consists of three main parts:
    #. **MeshConfig Agent** - This is the component that runs on the local measurement host and makes sure the scheduling layer is configured to run all the desired tests. It can do so by looking at manually defined tests in a local file or reading a remotely hosted configuration file that contains tests its supposed to run. See :doc:`multi_mesh_agent_config` for more details.
    #. **MeshConfig GUIAgent** - This component can read from a remote mesh file and generate a `MaDDash <http://software.es.net/maddash>`_ dashboard that displays the results of the tests. See :ref:`intro_about-visualization` for more information on the visualization tools perfSONAR provides and the `MaDDash Auto-configuration <http://software.es.net/maddash/mesh_config.html>`_ page for more information on the MeshConfig GUIAgent.
    #. **MeshConfig JSON Builder** - This is a simple tool that takes a configuration file in `Apache-like configuration format <http://search.cpan.org/dist/Config-General/General.pm>`_ and converts it into a JSON format readable as a remote mesh by the MeshConfig Agent and GUIAgent. See :doc:`multi_mesh_server_config` for more details.
    
In order to simplify the process above there are also a few graphical interfaces for defining tests:

    * **Toolkit GUI** - This ships with every perfSONAR Toolkit and allows defining tests for the MeshConfig Agent on the local host only. See :doc:`manage_regular_tests` for more details.
    * **pSConfig Web Admin** - This is a web-based application for defining remote meshes that can be read by the MeshConfig/pSConfig Agents of multiple hosts as well as the MeshConfig/pSConfig GUIAgent. See :doc:`pwa` for more details.


.. _intro_about-visualization:

Visualization
--------------

perfSONAR also includes components for visualizing the data. These components provide a window into the data and are the primary way most operators analyze and identify network issues.  The primary tools provided by the main perfSONAR project are:

    * **Graphs** - The perfSONAR graphs package provides a set of graphs that display the various measurements over time and provide useful information about the hosts involved. See :doc:`using_graphs` for more detail.
    * **MaDDash** - This component queries the :ref:`archiving layer <intro_about-archiving>` periodically for measurements and displays a dashboard indicating the performance of each relative to a set of defined thresholds. It can also send alerts based on patterns in the dashboard. See the `MaDDash documentation <http://software.es.net/maddash>`_ for more details.


.. _intro_about-discovery:

Discovery
---------
Each perfSONAR node can run a component called the **Lookup Service (LS) Registration Daemon** that registers its existence in a public and/or private `lookup service <http://software.es.net/simple-lookup-service/>`_. The registration daemon gathers information about each perfSONAR layer as well as the host on which it runs. This information is then used in multiple places to help debug problems and find hosts with which to test when building new configurations. 

In general, no configuration is needed of the registration component but for a guide of the options available see :doc:`config_ls_registration`. For a guide on automatically building test configurations based on registered lookup service content see :doc:`multi_mesh_autoconfig`.

Additional Components
----------------------
In addition to what's included in the diagram above, there are some additional tools available that interact with one or more of the layers shown. For example:

    * :doc:`perfSONAR UI <using_psui>` is a component that interacts with both the :ref:`scheduling <intro_about-scheduling>` and :ref:`archiving <intro_about-archiving>` layers to execute tests and visualize results. It currently uses the legacy perfSONAR scheduling system and will be updated to support pScheduler in a future release. See :doc:`using_psui` for more details.

Many of the layers provide open APIs, so its possible to use or write third-party tools to do even more. For information on the APIs available see :doc:`client_apis`.


.. _owamp: http://software.internet2.edu/owamp
.. _iperf3: http://software.es.net/iperf
.. _iperf2: https://sourceforge.net/projects/iperf2/
.. _nuttcp: https://fasterdata.es.net/performance-testing/network-troubleshooting-tools/nuttcp/
.. _traceroute: https://linux.die.net/man/8/traceroute
.. _tracepath: https://linux.die.net/man/8/tracepath
.. _paris-traceroute: http://manpages.ubuntu.com/manpages/trusty/man8/paris-traceroute.8.html
.. _ping: https://linux.die.net/man/8/ping
.. _esmond: http://software.es.net/esmond
