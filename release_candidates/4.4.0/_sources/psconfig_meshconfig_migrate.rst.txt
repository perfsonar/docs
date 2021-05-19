**************************************************************
MeshConfig to pSConfig Migration Guide
**************************************************************

.. _psconfig_mesconfig_migrate-agents:

Upgrading Agents
=================================

.. _psconfig_mesconfig_migrate-agents-overview:

Overview
----------
Any host that reads a template file (or mesh file in MeshConfig terminology) is considered an agent. Agent hosts that upgrade to 4.1 will automatically upgrade to pSConfig and **no further action is required** by the host administrator. All configuration files will be migrated and the old software will be removed automatically. All agents are capable of reading the old MeshConfig JSON format, so your old mesh files you are pointing at will continue to work even once you have upgraded to the pSConfig agent. 

For those interested in the exact details of what happens on upgrade let's take a look at the two supported agents in MeshConfig, *perfsonar-meshconfig-agent* and *perfsonar-meshconfig-guiagent*

.. _psconfig_mesconfig_migrate-agents-pscheduler:

Upgrade details of *perfsonar-meshconfig-agent* to *perfsonar-psconfig-pscheduler*
-------------------------------------------------------------------------------------
.. note:: This section provides advanced details for those interested in the upgrade process. You DO NOT need to run any of the commands in this section, all the work is done automatically on upgrade.

The *perfsonar-meshconfig-agent* package was responsible for reading a JSON mesh file and creating pScheduler tasks. In perfSONAR 4.1, this package is replaced by *perfsonar-psconfig-pscheduler* that can read a pSConfig template (or a JSON file in the old MeshConfig format) and create pScheduler tasks. The installer package does this by running the following command::

    psconfig pscheduler-migrate
    
This command performs the following actions:

#. It translates the file ``/etc/perfsonar/meshconfig-agent.conf`` to the new format supported by the agent and stores the result in ``etc/perfsonar/psconfig/pscheduler-agent.json``. This only runs if ``/etc/perfsonar/meshconfig-agent.conf`` exists and after it is complete, a backup is created at ``/etc/perfsonar/meshconfig-agent.conf.DATETIME`` where ``DATETIME`` is a timestamp of when it was moved.
#. It moves the  contents of ``/etc/perfsonar/meshconfig-agent-tasks.conf`` to ``/var/lib/perfsonar/toolkit/gui-tasks.conf``. Any tasks generated from remote mesh files are removed since they will presumably be recreated when the new pSConfig agent runs and all tasks are no longer stored in a single file. Any global archives are moved to the ``/etc/perfsonar/psconfig/archived.d/`` include directory.  It then translates the results and stores them in ``/etc/perfsonar/psconfig/pscheduler.d/toolkit-webui.json``. These two files are required by the Toolkit GUI since it still internally represents the tasks in the old format and translates upon save. A backup is created at ``/etc/perfsonar/meshconfig-agent-tasks.conf.DATETIME`` where ``DATETIME`` is a timestamp of when it was moved.
#. The ``client_uuid`` and ``psc_tracker`` files are moved from ``/var/lib/perfsonar/meshconfig`` to ``/var/lib/perfsonar/psconfig``.


The output of this command including any errors can be found in ``/var/log/perfsonar/psconfig-pscheduler-migrate.log``.

See :doc:`psconfig_pscheduler_agent` for more information on using the pSConfig pScheduler agent and the features it provides. 

.. _psconfig_mesconfig_migrate-agents-maddash:

Upgrade details of *perfsonar-meshconfig-guiagent* to *perfsonar-psconfig-maddash*
-------------------------------------------------------------------------------------
.. note:: This section provides advanced details for those interested in the upgrade process. You DO NOT need to run any of the commands in this section, all the work is done automatically on upgrade.

The *perfsonar-meshconfig-guiagent* package was responsible for reading a JSON mesh file and creating MaDDash dashboards. In perfSONAR 4.1, this package is replaced by *perfsonar-psconfig-maddash* that can read a pSConfig template (or a JSON file in the old MeshConfig format) and create MaDDash dashboards. The installer package does this by running the following command::

    psconfig maddash-migrate
    
This command has one task which is to convert ``/etc/perfsonar/meshconfig-guiagent.conf`` to the new format supported by the agent and stores the results in ``/etc/perfsonar/psconfig/maddash-agent.json``.

The output of this command including any errors can be found in ``/var/log/perfsonar/psconfig-maddash-migrate.log``.

See :doc:`psconfig_maddash_agent` for more information on using the pSConfig MaDDash agent and the features it provides. 

.. note:: Once moving to the new agent, if you are pointing at an old MeshConfig file using ``force_bidirectional``, then how your dashboard is displayed will change from how it looked prior to the upgrade. See :ref:`psconfig_mesconfig_migrate-forcebidir` for more details. 

.. _psconfig_mesconfig_migrate-translate:

Translating an old MeshConfig JSON file to pSConfig Format
==========================================================
The current set of agents support both the old MeshConfig JSON format and the new pSConfig JSON format, so there is no immediate requirement to update your old mesh files. In fact, if you expect some agents will not upgrade right away and be running MeshConfig then your only option is to use the old forma for those old agents. You can choose to maintain both formats if you so desire, or you can just maintain the old MeshConfig format until all agents have upgraded.

At a point where either all the agents reading your template have upgraded or you are in need of a feature only supported by pSConfig, then you will want to start using the new format. You can convert an old MeshConfig JSON file using the following command:

    psconfig translate -o NEW_JSON_FILE OLD_JSON_FILE

Run ``psconfig translate --help`` for a full list of options. The command converts the old MeshConfig JSON at the file path or URL specified by ``OLD_JSON_FILE``  and converts it to the new format that it stores in ``NEW_JSON_FILE``.  Note that it does NOT support the old Apache MeshConfig format, the file MUST be converted to the MeshConfig JSON format first.

Once you have your converted template see :doc:`psconfig_publish` for more details on publishing the new template. Also see :doc:`psconfig_templates_intro` for more information on working with templates. 

.. _psconfig_mesconfig_migrate-forcebidir:

Special Notes on force_bidirectional and Changes to MaDDash Display
=======================================================================
One special behavior of the ``psconfig translate`` command is that it will ignore the ``force_bidirectional`` option by default. This is done because force_bidirectional is an option a number of our examples used historically without much explanation. As a result a lot of people are using it but not really sure why. In most cases it will have a lot of undesirable consequences such as:

* Overtesting of the network in the form of unnecessary duplicate tests
* Increased load on the host systems due to the aforementioned duplicate tests
* Less time available on the schedule due to the aforementioned duplicate tests
* Increased likelihood of firewall problems since more connections are made from different sources
* Dashboards are more difficult to read


Note that disabling ``force_bidirectional`` is NOT the same thing as disabling bidirectional tests (i.e. tests that run in the forward and reverse direction). If you are confused by that statement, you are getting a glimpse of why ``psconfig translate`` is choosing to ignore the option by default. Let's take a closer look at what ``force_bidirectional`` actually does. Below is a diagram with two pairs of hosts and assumes there is an old mesh file using ``force_bidirectional``. The top pair of hosts both run agents and thus both read the old mesh file. In the second pair, only *Host 1* has an agent and reads the mesh file.  In this example ``force_bidirectional`` is **enabled**:

.. figure:: images/psconfig_mesconfig_migrate-force_bidir_1.png
    :align: center
    
    *An example of the tests generated when force_bidirectional is enabled*

Note that in the top pair, each agent requests the test in both directions. This results in a total of four tests with each direction being run twice. In the bottom case, only the first host requests both tests since the agent knows the remote side does not have its own agent as indicated by the ``no_agent`` property in the mesh file. Note that the ``no_agent`` is the main driver for it requesting both directions, not ``force_bidirectional``. Each direction is just run once and there are no duplicate tests.

Now let's look at the same two pairs but with ``force_bidirectional`` **disabled**:

.. figure:: images/psconfig_mesconfig_migrate-force_bidir_2.png
    :align: center
    
    *An example of the tests generated when force_bidirectional is disabled*

Note that in the top pair, each agent requests the test where it is the source and thus we just get one copy of each test and no duplicate copy. The second host pair is unaffected by the ``force_bidirectional`` change since only the first host has an agent, but it still manages to request both directions of the test. The important takeaway here is that with force_bidirectional off we still get results in both directions, we just eliminate unnecessary duplicates.

Now let's take a closer look at the dashboard and how it displays ``force_bidirectional`` tests. For a group of type mesh (every host tests to every other host) we get a grid like the following:

.. figure:: images/psconfig_mesconfig_migrate-force_bidir_3.png
    :align: center
    
    *An example MaDDash grid when force_bidirectional is enabled for a group of type mesh*
    
Each host in the row represents the source and each column represents the destination. Since we have two tests to display for each direction, the box gets split in two with the top and bottom differentiated by who requested the test. If you've ever wondered what split boxes mean, this is part of that answer. The other part comes from looking at a grid of type *disjoint* (hosts in one group test to hosts in another group). An example of a grid using ``force_bidirectional`` is shown below:

.. figure:: images/psconfig_mesconfig_migrate-force_bidir_4.png
    :align: center
    
    *An example MaDDash grid when force_bidirectional is enabled for a group of type disjoint*

The diagram above highlights a crucial fact: **If you are running a disjoint mesh using force_bidirectional in 4.0 or sooner, half you tests are not even displaying**.  This is not a bug as much of a fact that the box would need to be split *four ways* to show everything, which would not be readable. 

The summary above is driving at the fact that ``force_bidirecional`` both leads to unnecessary duplicate testing and more confusing dashboards. pSConfig aims to improve both of these aspects. The first part of this is discouraging the use of ``force_bidirectional`` in general. In fact, pSConfig does not even support the option (though as we see later it has a way to accomplish the same tests and display them in a more sane way). In MaDDash. whether running the old MeshConfig GUI Agent or the new pSConfig MaDDash Agent, without ``force_bidirectional`` your grids are displayed as follows:

*  Grids for groups of type *mesh* are whole boxes (no split) with the row being the source and the column being the destination.
*  Grids for groups of type *disjoint* are still split with the top being the forward direction and the bottom being the reverse. 

If you absolutely feel you need the equivalent of ``force_bidirectional``, then pSConfig does support a way. Basically what you have to do is define two separate tasks in your template with the only difference being the :ref:`scheduled-by <psconfig_templates_advanced-tasks-scheduled_by>` property (see  :ref:`psconfig_templates_advanced-tasks-scheduled_by` for full details). In the case of the mesh, this leads to **two grids** as follows:

.. figure:: images/psconfig_mesconfig_migrate-force_bidir_5.png
    :align: center
    
    *An example MaDDash grid generated using pSConfig tasks with different scheduled-by properties and of group type mesh*
    
For type *disjoint* the **two grids** look as follows:

.. figure:: images/psconfig_mesconfig_migrate-force_bidir_6.png
    :align: center
    
    *An example MaDDash grid generated using pSConfig tasks with different scheduled-by properties and of group type disjoint*

.. note:: The above is also relevant if using a pSConfig MaDDash Agent to read an old MeshConfig file. In this case, it will convert ``force_bidirectional`` to two tasks and your dashboard will change. You will now have a second grid labelled *Scheduled by Destination* that looks like the second grid in each of the last two diagrams

If you want translation to convert ``force_bidriectional`` to two *task* objects with ``scheduled-by`` set then give ``psconfig translate`` the ``--use-force-bidirectional`` option. Just be sure you know what you are doing and are not creating duplicate tests you don't need. 






 

