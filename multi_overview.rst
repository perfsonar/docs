******************************
Central Configuration Overview
******************************

If you manage more than one perfSONAR host for your organization or participate in a distributed community of perfSONAR measurement hosts, it can quickly become unwieldy to manually configure the tests you want to run for each host. perfSONAR provides some additional tools that make it easier to manage multiple toolkits and ensure each deployment gets the correct set of tests. It also provides ways to store and visualize the results from multiple hosts. See the sections that follow for important information on each of these topics. 

Defining Tests for Multiple Hosts
=================================

One of the most important parts about managing multiple hosts is maintaining the proper set of regular tests. It can be a challenge to not only accurately setup the tests for the first time, but to update these tests as members come and go or test parameters change. In order to make this easier, perfSONAR has the concept of the **Mesh Configuration (MeshConfig)** software. The basic idea is that an administrator defines the desired tests in a central file, publishes this file to the web and the individual hosts download the file and use it to build their test configuration. A diagram of this process is shown below:

.. image:: images/multi-overview.png

You can find information on each of the steps outlined by the diagram in the following sections:

    * **Step 1** of defining the configuration file and **step 2** of publishing the configuration to the web are covered in :doc:`multi_server_config`. This will be beneficial to administrators planning to run a central configuration file. It is not required reading if you only plan to consume a central configuration file. 
    * **Step 3** of downloading the configuration file is covered in :doc:`multi_agent_config`. This describes what needs to be done to a perfSONAR host to participate in a mesh configuration and will be beneficial if you have one or more hosts that need to consume one or more central configuration files.

Storing Your Measurements
=========================
Measurement results are stored in a component called the measurement archive (MA). If you are running the perfSONAR Toolkit, then your results will be stored in an MA on your local Toolkit node by default. It is possible to configure multiple perfSONAR hosts to write to the same remote MA. This may be especially desirable if your hosts that are performing measurements do not have powerful hardware and do not want to waste resources hosting a measurement archive. For more information on running a central MA see :doc:`multi_central_MA`.

Visualizing the Results
=======================
Visualizing the measurement results for multiple hosts is another desirable aspect of central configuration and management. Currently there is an :doc:`additional tool <manage_extra_tools>` called `MaDDash <http://software.es.net/maddash/>`_ developed in conjunction with the perfSONAR project that organizes tests from multiple hosts into grids. It is even capable of `integrating with the perfSONAR mesh configuration tools <http://software.es.net/maddash/mesh_config.html>`_ to generate a display based on your central configuration file. The full set of MaDDash options and features is beyond the scope of this guide, but see the `MaDDash documentation <http://software.es.net/maddash/>`_ for more details. 
