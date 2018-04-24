**************************************************************
Running the pSConfig pScheduler Agent
**************************************************************

.. _psconfig_pscheduler_agent-intro:

Introduction
===============

.. _psconfig_pscheduler_agent-intro-role:

pSConfig pScheduler Agent's Role
---------------------------------
The role of the *pSConfig pScheduler Agent* is to read :doc:`pSConfig templates <psconfig_intro>` and generate a set of :doc:`pScheduler <pscheduler_intro>` :term:`tasks <task>`. The diagram below describes this role:

.. figure:: images/psconfig_pscheduler_agent-arch.png
    :align: center
    
    *A diagram showing the psconfig-pscheduler-agent reading templates from a number of sources and submitting tasks to pScheduler servers.*
    
Performing this role is a multi-step process that includes the following:

#. Read the templates and optionally perform local modifications to the template
#. Determine the pScheduler tasks to schedule
#. Communicate with the appropriate pScheduler servers to ensure the tasks are created.

These steps are completed when the following events occur:

* The agent starts
* Within a configurable amount of time of a change to a *local* configuration file (changes to remote files are not detected). By default the value is *1 minute*.
* If no changes, on a configurable interval after the start of the last run. By default these steps are run every *1 hour*. 

.. note:: See :ref:`psconfig_pscheduler_agent-advanced` for more detail on the configuration options mentioned above. 

The remainder of this section describes each of these steps in greater detail.

.. _psconfig_pscheduler_agent-intro-read:

Reading and Modifying Templates
----------------------------------
The agents first job is to read a set of :doc:`templates <psconfig_templates_intro>`. The templates to read are configured by the administrator of the agent. For information on how to configure templates see :ref:`psconfig_pscheduler_agent-templates`.

After reading a template an agent is also capable of performing local modifications to that template. The types of modifications supported include:

* Inclusion of default archives for all tasks. See :ref:`psconfig_pscheduler_agent-modify-archives` for more detail.
* Direct transformations to the template JSON. See :ref:`psconfig_pscheduler_agent-modify-transform_one` and :ref:`psconfig_pscheduler_agent-modify-transform_all`for more detail.

.. _psconfig_pscheduler_agent-intro-determine:

Determining the pScheduler Tasks to Create
-------------------------------------------
An individual agent is not necessarily responsible for creating and managing all the tasks described by a template. Instead, an agent looks at the :ref:`address objects <psconfig_templates_intro-concepts-addresses>` associated with individual tasks and only concerns itself with those it is configured to manage. It determines these addresses as follows:

*  By default, the agent detects the addresses on the local interfaces of the host which it runs. 
*  The default behavior can be overriden by setting the ``addresses`` option in the default configuration file. See :ref:`psconfig_pscheduler_agent-advanced` for more detail.

Once it has the list of addresses for which it is responsible, it is not just a matter of seeing if one of the addresses is in the generated address list for a task. Instead, it must also analyze if the address it matches is also the one designated to schedule the task. This designation is dependent on the task configuration. A full discussion of this stage of the decision process can be found in :ref:`psconfig_templates_advanced-tasks-scheduled_by`.

.. _psconfig_pscheduler_agent-intro-communicate:

Communicating with pScheduler
-------------------------------
Once the set of tasks that needs to be managed is determined, the agent must then decide which pScheduler servers to contact to make sure they are created. It does this by contacting a pScheduler :term:`assist server` that will identify a :term:`lead participant`. The assist server is a pScheduler server running on the local host of the agent by default, but this :ref:`can be overridden <psconfig_pscheduler_agent-advanced>`. How the lead is determined is test plug-in dependent which is why the agent needs a pScheduler assist server to make the decision. 

Once it has the lead, the pSConfig agent will contact that server to see if the task already exists and will create it if not. Tasks are created with an end time that is the later of the following:

* A configurable fixed amount of time after the task is created. By default this is *24 hours*.
* The length of time required to complete a configurable number of runs. By default the value is *2*.

.. note:: See :ref:`psconfig_pscheduler_agent-advanced` for more detail on the configuration options listed above. 

The task will be recreated after its expiration if it is still in the template. If at any point a task is removed, then the task will be canceled the next time the agent runs.

.. note:: The new task is actually put on the schedule several hours before it is set to expire, but with a start time that matches the end time of the old task. This should minimize any downtime between the transition but also prevent test collisions. 

When finished communicating with all the required pScheduler servers, the agent will remain idle until its next run. 

.. _psconfig_pscheduler_agent-install:

Installation
=============

.. _psconfig_pscheduler_agent-standalone:

Installing the Standalone Package
-----------------------------------
The pSConfig pScheduler agent is installed with the package ``perfsonar-psconfig-pscheduler``. You can run the following commands to install it:

    *CentOS*::
    
        yum install perfsonar-psconfig-pscheduler

    *Debian/Ubuntu*::
    
        apt-get install perfsonar-psconfig-pscheduler

.. _psconfig_pscheduler_agent-bundle:

Installing as Part of a Bundle
-------------------------------
The ``perfsonar-psconfig-pscheduler`` is included in the following :doc:`perfSONAR bundles <install_options>`:

* *perfsonar-testpoint*
* *perfsonar-core*
* *perfsonar-toolkit*

.. _psconfig_pscheduler_agent-run:

Running ``psconfig-pscheduler-agent``
======================================

.. _psconfig_pscheduler_agent-run-start:

Starting ``psconfig-pscheduler-agent``
--------------------------------------
::

    systemctl start psconfig-pscheduler-agent


.. _psconfig_pscheduler_agent-run-stop:

Stopping ``psconfig-pscheduler-agent``
--------------------------------------
::

    systemctl stop psconfig-pscheduler-agent


.. _psconfig_pscheduler_agent-run-restart:

Restarting ``psconfig-pscheduler-agent``
--------------------------------------------
::

    systemctl restart psconfig-pscheduler-agent
    
.. _psconfig_pscheduler_agent-run-status:

Checking the status of ``psconfig-pscheduler-agent``
-----------------------------------------------------
::

    systemctl status psconfig-pscheduler-agent

.. _psconfig_pscheduler_agent-templates:

Configuring Templates
======================

.. _psconfig_pscheduler_agent-templates-basics:

Configuration Basics
-----------------------------
In order for the agent to create tasks, it must first be configured to read one or more templates. There are multiple ways to add a template depending on its location relative to the host system of the agent. These include:

#. Configuring *remote* templates  by supplying a URL and desired options to the agent. This is most commonly done using the ``psconfig remote`` command. See :ref:`psconfig_pscheduler_agent-templates-remote` for details.
#. Configuring *local* templates that live on the agent's filesystem either using the ``psconfig remote`` command or by copying the template files to a dedicated directory whose contents are automatically read by the agent. See :ref:`psconfig_pscheduler_agent-templates-local` for details.


.. _psconfig_pscheduler_agent-templates-remote:

Remote Templates
-----------------------------
The primary way to add, list, and delete the remote templates read by the agent is with the ``psconfig remote`` command. 

.. note:: The ``psconfig remote`` command simply edits the ``/etc/perfsonar/psconfig/pscheduler-agent.json`` file. For most users it is recommended to use the ``psconfig remote`` command as opposed to editing the file directly as it is less prone to syntax errors. 

As an example let's say we have a pSConfig template at the URL ``https://10.0.0.1/example.json``. The agent can be configured to read the template by running the following command **as a root user**::

    psconfig remote add "https://10.0.0.1/example.json"

The above command will add the new template to the agent. The agent should begin reading the template within 60 seconds of the change if using default settings (i.e. no agent restart required). 

You may also provide the command with additional processing instructions. For example, the default behavior of the agent is to ignore the archive definitions of the remote template. This is to ensure the local administrator has a chance to "opt-in" to where the results are sent. To use the archives defined in the remote template we can provide the ``--configure-archives`` option as shown below::

     psconfig remote add --configure-archives "https://10.0.0.1/example.json"

Note that the ``psconfig remote`` command ensures a given URL is only used once by the agent. If we already had ``https://10.0.0.1/example.json`` in our file and then ran the command above, the previous definition would be replaced with one that had the ``configure-archives`` option set. To see the full set of options available run the following::

    psconfig remote --help

In addition to adding remote templates, you may also view them. The following command lists the remote templates in use by the agent::

    psconfig remote list
    
The above command returns a list of JSON objects containing the template URL and any options set.

Finally, to remove our example remote template we can run the ``psconfig remote delete`` command **as a root user** as shown below::

    psconfig remote delete "https://10.0.0.1/example.json"
    
The command accepts only a URL and will remove the agent's pointer to that template. Within 60 seconds of adding that command, the agent will run and begin canceling any tasks from the removed template that it was responsible for creating. 

.. note:: The ``psconfig remote`` command is also the command used by the :doc:`MaDDash agent <psconfig_maddash_agent>` to manage remote templates. If you have both agents installed on the same system, then any ``psconfig remote`` command will affect both agents by default. If you'd only like a command to apply to the pScheduler agent then add the ``--agent pscheduler`` option. Run ``psconfig remote --help`` for full details. 

.. _psconfig_pscheduler_agent-templates-local:

Local Templates
--------------------------
The agent can read templates from the local filesystem. One way to do this is by giving the ``psconfig remote`` command either a URL beginning with ``file://`` or an absolute path to the file on the filesystem. An example command is below where ``/path/to/template.json`` is the example path to the template file::
    
      psconfig remote add /path/to/template.json

Everything about the command works the same with a file path as it would with a http/https URL. See :ref:`psconfig_pscheduler_agent-templates-remote` for more details on this command.

A second way you can add a local template is to copy it into the *template include directory*. By default this is located at```/etc/perfsonar/psconfig/pscheduler.d/``. For example::

    cp /path/to/template.json /etc/perfsonar/psconfig/pscheduler.d/template.json
    
    
Any file ending with ``.json`` in this directory will get read by the agent automatically. Some important notes about including files in this manner:

* Adding a new file, removing a file or updating a file within the template include directory will get detected automatically by the agent within 60 seconds of the change (i.e. no need to restart the agent). 
* Files are read every 60 minutes regardless of changes when the agent checks on the state of the tasks it has created in pScheduler.
* Any ``archives`` defined for the tasks will be configured. This is equivalent to the behavior of running ``psconfig remote add`` with the ``-configure-archives`` option. If you do not want to use archives from the template, then remove them from the template file. 
* The agent will follow symlinks if you use those instead of copying the file directly, though it may affect the agent's ability to detect changes (i.e. you may have to wait up to 60 minutes for the agent to see the changes).
* The agent ignores any files that do not end in ``.json``

.. _psconfig_pscheduler_agent-modify:

Modifying Templates
=======================

.. _psconfig_pscheduler_agent-modify-archives:

Configuring Default Archives
-----------------------------
The agent can modify all tasks it manages to include additional archives not defined in the templates themselves. This can be done by copying archive definition files to the *archive include directory*. The default location of the *archive include directory* is ``/etc/perfsonar/psconfig/archives.d/``.

Archive definition files are JSON files that contain exactly one :ref:`pScheduler archive definition <pscheduler_ref_archivers-archivers>`. For example, let's say the file ``/path/to/archive-syslog.json`` contains the following::

    {
        "archiver": "syslog",
        "data": {
            "facility": "local6",
            "priority": "info"
        }
    }

We can copy this file to ``/etc/perfsonar/psconfig/archives.d/`` as follows::

    cp /path/to/archive-syslog.json /etc/perfsonar/psconfig/archives.d/archive-syslog.json
    
Once copied, the agent will detect the change within 60 seconds. It will then recreate all the tasks it manages to include the archive defined above. You may include as many archive files in this directory as needed and all of them will be included with every task. A few other important notes:

* Adding a new file, removing a file or updating a file within the archive include directory will get detected automatically by the agent within 60 seconds of the change (i.e. no need to restart the agent). 
* Files are read every 60 minutes regardless of changes when the agent checks on the state of the tasks it's created in pScheduler.
* The agent will follow symlinks if you use those instead of copying the file directly, though it may affect the agent's ability to detect changes (i.e. you may have to wait up to 60 minutes for the agent to see the changes).
* The agent ignores any files that do not end in ``.json``.

.. _psconfig_pscheduler_agent-modify-transform_all:

Transforming All Remote Templates
-----------------------------------
The agent can make custom local modifications to templates it reads using *transform scripts*. Transform scripts take the form of `jq <https://stedolan.github.io/jq/>`_ and give complete freedom to manipulate the JSON. This can be especially useful with remote templates where the agent administrator may not have the ability to make changes. Some changes you may consider making with transform scripts include (but are not limited to):

* Updating authentication tokens needed by an *archive* object that cannot be safely published in a publicly available template
* Updating parameters related to ports in a *test* object's ``spec`` property if your local site has specific firewall restriction not applicable to other hosts running agents
* Adding additional ``reference`` information to a template *task* object so the generated pScheduler tasks contain extra metadata specific to the agent's host

All components of the template JSON can be revised which creates countless possibilities. For transform scripts that you want to apply to ALL templates read by the agent, including both those added with ``psconfig remote`` and those added from the template include directory, you can add a file to the *transforms include directory*. This directory is located at  ``/etc/perfsonar/psconfig/transforms.d`` by default. The script takes the following form::

    {
        "script": ...
    }
    
The ``...`` can either be a jq statement as a string or it can be an array of strings used for readability. The example below uses the array form to define a script that sets the ``_auth-token`` field to ``ABC123`` of an archiver named ``example-archive-central``::

    {
        "script": [
            "if .archives.\"example-archive-central\" then",
            "    .archives.\"example-archive-central\".data.\"_auth-token\" |= \"ABC123\"",
            "else",
            "    .",
            "end"
        ]
    }

If we say the script above lives in ``/path/to/esmond-auth.json`` we can add it to the agent as follows::

    cp /path/to/esmond-auth.json /etc/perfsonar/psconfig/transforms.d/esmond-auth.json

Once copied, the agent will detect the change within 60 seconds. It will then re-read all the templates, apply the script to each, and recreate any tasks that were altered by the transformation. A few other important notes:

* Adding a new file, removing a file or updating a file within the transforms include directory will get detected automatically by the agent within 60 seconds of the change (i.e. no need to restart the agent). 
* Files are read every 60 minutes regardless of changes when the agent checks on the state of the tasks it's created in pScheduler.
* The agent will follow symlinks if you use those instead of copying the file directly, though it may affect the agent's ability to detect changes (i.e. you may have to wait up to 60 minutes for the agent to see the changes).
* The agent ignores any files that do not end in ``.json``.


.. _psconfig_pscheduler_agent-modify-transform_one:

Transforming Individual Remote Templates
------------------------------------------
It is possible to make custom local modification to *individual* templates added with ``psconfig remote`` using the ``--transform`` option. This is useful if you do not want a script affecting everything read by an agent.

.. note:: Templates added using the template include directory cannot be transformed individually. An agent administrator can apply default transformations to them as detailed in :ref:`psconfig_pscheduler_agent-modify-transform_all` or make the change manually since the administrator presumably has access to the local template.

The ``--transform`` option accepts either a `jq <https://stedolan.github.io/jq/>`_ script as a string or from a file. For the later approach, if the option starts with ``@`` it will read the file specified by the path after the ``@``. The example below shows the form where the script is provided as a string::

    psconfig remote add --transform "if .archives.\"example-archive-central\" then .archives.\"example-archive-central\".data.\"_auth-token\" |= \"ABC123\" else . end" "https://10.0.0.1/example.json"

Alternatively, if we assume our script lives in a file at ``/path/to/esmond-auth.json`` with the format described in :ref:`psconfig_pscheduler_agent-modify-transform_all`, we can run::

    psconfig remote add --transform @/path/to/esmond-auth.json "https://10.0.0.1/example.json"

In both cases you can run ``psconfig remote list`` to verify the transform is in the remote definition. 

.. _psconfig_pscheduler_agent-troubleshoot:

Troubleshooting
===================

.. _psconfig_pscheduler_agent-troubleshoot-stats:

Looking at the last run with ``psconfig pscheduler-stats``
-----------------------------------------------------------

.. _psconfig_pscheduler_agent-troubleshoot-tasks:

Viewing Managed pScheduler Tasks with ``psconfig pscheduler-tasks``
--------------------------------------------------------------------

.. _psconfig_pscheduler_agent-troubleshoot-logs:

Reading the Logs
-----------------

.. _psconfig_pscheduler_agent-advanced:

Advanced Configuration
========================
The primary configuration file for the agent lives in ``/etc/perfsonar/psconfig/pscheduler-agent.json``. Generally you should not have to edit that file directly, but if you are interested in the full set of options available, then see the `schema file <https://raw.githubusercontent.com/perfsonar/psconfig/master/doc/psconfig-pscheduler-agent-schema.json>`_.

.. note:: This section will be expanded upon the completion of a command-line tool to aid in configuration.

.. _psconfig_pscheduler_agent-reading:

Further Reading
=========================
* For a full listing of pSConfig pScheduler Agent related files see the reference :ref:`here <config_files-psconfig>`
* For information regarding dynamic templates and how they relate to the pSConfig pScheduler Agent see :doc:`psconfig_autoconfig`
