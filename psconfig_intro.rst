******************************
What is pSConfig?
******************************

Introduction
============

**pSConfig** is a *template* framework for describing and configuring a *topology* of *tasks*. If you manage more than one perfSONAR host (or participate in a distributed community of perfSONAR measurement hosts), it can quickly become unwieldy to manually configure the tests you want to run at each location. It can further become difficult to maintain and configure visualization components to display results of the measurements. pSConfig is the perfSONAR component that assists with the management of multiple nodes.
 
Concepts and Terminology
========================
It is helpful to understand a few basic terms when discussing pSConfig. Starting at the most fundamental level, a **task** in the context of pSConfig is a job to do consisting of a test to be carried out, scheduling information and other options. In fact, a task in pSConfig means the same thing as a task in :doc:`pScheduler<pscheduler_intro>`. 

Beyond individual tasks, pSConfig is also concerned with how the tasks are interrelated and arranged, known as the task **topology**. Many tasks have common parameters or are related in some way, so it's important to be able to look at the tasks as more than just a set of independent jobs. pSConfig cares about these relationships so it can be used as input to visualization components such as `MaDDash <http://software.es.net/maddash/>`_ to relate the results in meaningful ways.

A pSConfig **template** is a description of the task topology in a machine readable format. pSConfig templates are expressed in JSON files. The templates are designed to be highly expressive and extensible so that new capabilities can easily be supported. pSConfig templates by themselves are just files, and they only become useful when something reads them and is able to perform action based on their content. 

An **agent** is software that reads one or more pSConfig templates and uses the information to perform a specific function. There are currently two agents in perfSONAR:

    #. **pscheduler-agent** - An agent that parses one or more template(s) for measurements to be run and submits them to :doc:`pScheduler<pscheduler_intro>`
    #. **maddash-agent** - An agent that reads one or more template(s) and creates a `MaDDash <http://software.es.net/maddash/>`_ dashboard to display the results

With the fundamentals out of the way, we can now bring them together to demonstrate the basic workflow of how pSConfig can be used to configure a perfSONAR deployment.


The pSConfig Workflow
======================

One of the most important parts about managing multiple hosts is maintaining the proper set of regular tests. It can be a challenge to not only accurately setup the tests for the first time, but to update these tests as members come and go or test parameters change. In order to make this easier, perfSONAR has the concept of the **Mesh Configuration (MeshConfig)** software. The basic idea is that an administrator defines the desired tests in a central file, publishes this file to the web and the individual hosts download the file and use it to build their test configuration. A diagram of this process is shown below:

.. image:: images/multi-overview.png

You can find information on each of the steps outlined by the diagram in the following sections:

    * **Step 1** of defining the configuration file and **step 2** of publishing the configuration to the web are covered in :doc:`multi_mesh_server_config`. This will be beneficial to administrators planning to run a central configuration file. It is not required reading if you only plan to consume a central configuration file. 
    * **Step 3** of downloading the configuration file is covered in :doc:`multi_mesh_agent_config`. This describes what needs to be done to a perfSONAR host to participate in a mesh configuration and will be beneficial if you have one or more hosts that need to consume one or more central configuration files.

