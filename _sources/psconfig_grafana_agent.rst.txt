**************************************************************
Running the pSConfig Grafana Agent
**************************************************************

.. _psconfig_grafana_agent-intro:

Introduction
===============

.. _psconfig_grafana_agent-intro-role:

pSConfig Grafana Agent's Role
---------------------------------
The role of the *pSConfig Grafana Agent* is to read :doc:`pSConfig templates <psconfig_intro>` and generate a set of dashboards to be displayed by Grafana. It does this by communicating with the Grafana API. The Grafana instance may either be local or remote to the Grafana agent. Performing this role is a multi-step process that includes the following:

#. Read the configured templates and optionally apply local modifications
#. Determine how to display tasks
#. Communicate with Grafana API to create/update/delete dashboards

These steps are completed anytime one of the following events occur:

* The agent starts
* Within a configurable amount of time of a change to a *local* configuration file (changes to remote templates are not detected). By default the value is *1 minute*.
* If no changes, on a configurable interval after the start of the last run. By default these steps are run every *1 hour*. 

.. note:: See :ref:`psconfig_grafana_agent-advanced` for more detail on the configuration options mentioned above. 

.. _psconfig_grafana_agent-install:

Installation
=============

.. _psconfig_grafana_agent-standalone:

Installing the Standalone Package
-----------------------------------
The pSConfig Grafana agent is installed with the package ``perfsonar-psconfig-grafana``. You can run the following commands to install it:

    *RedHat*::
    
        dnf install perfsonar-psconfig-grafana

    *Debian/Ubuntu*::
    
        apt install perfsonar-psconfig-grafana

.. _psconfig_grafana_agent-run:

Running ``psconfig-grafana-agent``
======================================

.. _psconfig_grafana_agent-run-start:

Starting ``psconfig-grafana-agent``
--------------------------------------
::

    systemctl start psconfig-grafana-agent


.. _psconfig_grafana_agent-run-stop:

Stopping ``psconfig-grafana-agent``
--------------------------------------
::

    systemctl stop psconfig-grafana-agent


.. _psconfig_grafana_agent-run-restart:

Restarting ``psconfig-grafana-agent``
--------------------------------------------
::

    systemctl restart psconfig-grafana-agent
    
.. _psconfig_grafana_agent-run-status:

Checking the status of ``psconfig-grafana-agent``
-----------------------------------------------------
::

    systemctl status psconfig-grafana-agent

.. _psconfig_grafana_agent-templates:

Configuring Templates
======================

.. _psconfig_grafana_agent-templates-basics:

Configuration Basics
-----------------------------
In order for the agent to configure Grafana, it must first be configured to read one or more templates. There are multiple ways to add a template depending on its location relative to the host system of the agent. These include:

#. Configuring *remote* templates  by supplying a URL and desired options to the agent. This is most commonly done using the ``psconfig remote`` command. See :ref:`psconfig_grafana_agent-templates-remote` for details.
#. Configuring *local* templates that live on the agent's filesystem either using the ``psconfig remote`` command or by copying the template files to a dedicated directory whose contents are automatically read by the agent. See :ref:`psconfig_grafana_agent-templates-local` for details.


.. _psconfig_grafana_agent-templates-remote:

Remote Templates
-----------------------------
The primary way to add, list, and delete the remote templates read by the agent is with the ``psconfig remote`` command. 

.. note:: The ``psconfig remote`` command simply edits the ``/etc/perfsonar/psconfig/grafana-agent.json`` file. For most users it is recommended to use the ``psconfig remote`` command as opposed to editing the file directly as it is less prone to syntax errors. 

As an example let's say we have a pSConfig template at the URL ``https://10.0.0.1/example.json``. The agent can be configured to read the template by running the following command **as a root user**::

    psconfig remote add "https://10.0.0.1/example.json"

The above command will add the new template to the agent. The agent should begin reading the template within 60 seconds of the change if using default settings (i.e. no agent restart required). 

You may also provide the command with additional processing instructions. To see the full set of options available run the following::

    psconfig remote --help

.. note:: Unlike the :doc:`pSConfig pScheduler Agent <psconfig_pscheduler_agent>`, the Grafana agent will use archive definitions from templates with no extra options like ``--configure-archives``. This is because Grafana ultimately just uses the archives for *reading* data as opposed to *writing* results. Also, the agent would not be particularly useful otherwise since you cannot display results if you do not have them. 

In addition to adding remote templates, you may also view them. The following command lists the remote templates in use by the agent::

    psconfig remote list
    
The above command returns a list of JSON objects containing the template URL and any options set.

Finally, to remove our example remote template we can run the ``psconfig remote delete`` command **as a root user** as shown below::

    psconfig remote delete "https://10.0.0.1/example.json"
    
The command accepts only a URL and will remove the agent's pointer to that template. Within 60 seconds of executing that command, the agent will run and instruct Grafana to cease display of any tasks from the removed template. 

.. note:: The ``psconfig remote`` command is also the command used by the :doc:`pScheduler agent <psconfig_pscheduler_agent>` to manage remote templates. If you have both agents installed on the same system, then any ``psconfig remote`` command will affect both agents by default. If you'd only like a command to apply to the Grafana agent then add the ``--agent grafana`` option. Run ``psconfig remote --help`` for full details. 

.. _psconfig_grafana_agent-templates-local:

Local Templates
--------------------------
The agent can read templates from the local filesystem. One way to do this is by giving the ``psconfig remote`` command either a URL beginning with ``file://`` or an absolute path to the file on the filesystem. An example command is below where ``/path/to/template.json`` is the example path to the template file::
    
      psconfig remote add /path/to/template.json

Everything about the command works the same with a file path as it would with a http/https URL. See :ref:`psconfig_grafana_agent-templates-remote` for more details on this command.

A second way you can add a local template is to copy it into the *template include directory*. By default this is located at ``/etc/perfsonar/psconfig/grafana.d/``. For example::

    cp /path/to/template.json /etc/perfsonar/psconfig/grafana.d/template.json
    
Any file ending with ``.json`` in this directory will get read by the agent automatically. Some important notes about including files in this manner:

* Adding a new file, removing a file or updating a file within the template include directory will get detected automatically by the agent within 60 seconds of the change (i.e. no need to restart the agent). 
* Files are read every 60 minutes regardless of changes when the agent checks on the state of the dashboards it has created in Grafana.
* The agent will follow symlinks if you use those instead of copying the file directly, though it may affect the agent's ability to detect changes (i.e. you may have to wait up to 60 minutes for the agent to see the changes).
* The agent ignores any files that do not end in ``.json``

.. _psconfig_grafana_agent-modify:

Modifying Templates
=======================
Template modification in the Grafana agent works exactly the same as in the pScheduler agent. They both use the same commands and directories to perform these operations. See :ref:`psconfig_pscheduler_agent-modify` in the pScheduler agent document for full details. 

.. _psconfig_grafana_agent-displays:

Configuring Displays and Grafana 
==================================

.. _psconfig_grafana_agent-displays-thresholds:

Adjusting Thresholds and Other Parameters
-------------------------------------------------
If you would like to edit the threshold values or colors displayed on grids generated by the agent, then you can edit settings in the `/etc/perfsonar/psconfig/grafana-agent.json` file. In the file there is a `displays` sections which has entries for the different types of tests (e.g. throughput, packet loss, etc). Example::

    "displays": {
        ...
        "throughput_avg": {
            "task_selector":{
                "test_types": ["throughput"]
            },
            "datasource_selector": "auto",
            "stat_field": "result.throughput",
            "stat_type": "avg",
            "row_field": "test.spec.source.keyword",
            "col_field": "test.spec.dest.keyword",
            "value_field": "Average",
            "value_text": "Throughput",
            "unit": "bps",
            "matrix_url_template": "/usr/lib/perfsonar/psconfig/templates/endpoints.json.j2",
            "matrix_url_var1": "source",
            "matrix_url_var2": "dest",
            "thresholds": [
                {
                    "color": "red",
                    "value": null
                },
                {
                    "color": "super-light-yellow",
                    "value": 2000000000
                },
                {
                    "color": "green",
                    "value": 5000000000
                }
            ]
        },
        ...
    }

Under the `thresholds`` section each entry has a color and a value. The color can be a human-readable name that grafana understands or a hex value. The value is the threshold to set and the units will depend on the test type. For throughput this is bits per second. There should also be a `unit`` value which can help inform you if you are unsure. 

In more advanced cases if we want to have different grids of the same type to have different thresholds (and display only once) then we can copy the existing config and create a second entry that updates the `task_selector`, `thresholds` and adds a `priority` (to both the new and original) as follows::

        "displays": {
        ...
        "throughput_avg": {
            "task_selector":{
                "test_types": ["throughput"]
            },
            "priority": {
                "group": "throughput",
                "level": 1
            },
            "datasource_selector": "auto",
            "stat_field": "result.throughput",
            "stat_type": "avg",
            "row_field": "test.spec.source.keyword",
            "col_field": "test.spec.dest.keyword",
            "value_field": "Average",
            "value_text": "Throughput",
            "unit": "bps",
            "matrix_url_template": "/usr/lib/perfsonar/psconfig/templates/endpoints.json.j2",
            "matrix_url_var1": "source",
            "matrix_url_var2": "dest",
            "thresholds": [
                {
                    "color": "red",
                    "value": null
                },
                {
                    "color": "super-light-yellow",
                    "value": 2000000000
                },
                {
                    "color": "green",
                    "value": 5000000000
                }
            ]
        },

        "throughput_avg_special_tests": {
            "task_selector":{
                "names": ["super_special_test"]
            },
            "priority": {
                "group": "throughput",
                "level": 10
            },
            "datasource_selector": "auto",
            "stat_field": "result.throughput",
            "stat_type": "avg",
            "row_field": "test.spec.source.keyword",
            "col_field": "test.spec.dest.keyword",
            "value_field": "Average",
            "value_text": "Throughput",
            "unit": "bps",
            "matrix_url_template": "/usr/lib/perfsonar/psconfig/templates/endpoints.json.j2",
            "matrix_url_var1": "source",
            "matrix_url_var2": "dest",
            "thresholds": [
                {
                    "color": "red",
                    "value": null
                },
                {
                    "color": "super-light-yellow",
                    "value": 10000000000
                },
                {
                    "color": "green",
                    "value": 50000000000
                }
            ]
        },
        ...
    }

Since technically `super_special_test` would match both because its both a throughput test and has the name `super_special_test` we use priority to indicate that the name match has precedence. If we did not add that, we would get two grids displayed for super_special_test with different thresholds. 

Beyond changing thredholds, the default displays may be fine in most cases but you can add more entries to the displays section for different test types or have it grab different stats. Feel free to experiment with the different fields to learn more. 

.. _psconfig_grafana_agent-org_dashboards:

Organizing Grids and Dashboards
-----------------------------------------------
Grouping grids onto the same dashboard can be controlled through your pSConfig JSON template under the `tasks` section. There are two values that need to be set under the task `reference` section:

    1. Set the `display-task-name` to get a human readable title for the task
    2. Set the `display-task-group` to a list of dashboard names in which you want the grid included (NOTE: This must be an array even if it is just one element)

See the snippet below that includes a grid displayed as *Example Throughput* in a dashboard named *Example Dashboard*::

    "example_throughput" : {
        "reference": {
            "display-set-source": "{% jq .addresses[0]._meta.\"display-set\" %}",
            "display-set-dest": "{% jq .addresses[1]._meta.\"display-set\" %}",
            "display-task-name": "Example Throughput",
            "display-task-group": ["Example Dashboard"]
        },
        "group" : "example_thr_group",
        "schedule" : "schedule_0"
        "test" : "example_thr_test"
    }

.. _psconfig_grafana_agent-multi_xfaces:

Graphing Multiple Interfaces on Same Dashboard
-----------------------------------------------
A common use case is that a single measurement host may have multiple interfaces, such as one dedicated to throughput and another dedicated to latency. The address for each interface is defined as separate `address` objects in your pSConfig file. By default, when the Grafana dashboards are generated these addresses will not be on the same graphs since the agent does not know they belong together. If you want this data to be on the same graph page you need to set some parameters that indicate the addresses should be grouped together. This requires two changes to your pSConfig template: 

    1. Update the `address` definitions with a `_meta` tag of `display-set`.
    2. Update the `task` definitions to include a `reference` section with `display-set-source` and `display-set-dest` that includes the `dispay-set` value from the source and destination.

Let's look at these steps in detail. First let's say we have a host two interfaces: *example-tp.perfsonar.net* and *example-lat.perfsonar.net* that we want shown on the same graphs. When we define the addresses, we create a `display-set` called `example.perfsonar.net` (this can be any string as long as it is consistent between the two addresses) in our pSConfig template JSON. For example::

    "example-tp.perfsonar.net" : {
      "_meta" : {
         "display-set" : "example.perfsonar.net"
      },
      "address" : "example-tp.perfsonar.net"
   },
   "example-lat.perfsonar.net" : {
        "_meta" : {
           "display-set" : "example.perfsonar.net"
        },
        "address" : "example-lat.perfsonar.net"
    }

The next step is to make sure these values are passed to pScheduler when the tasks are created. This gives the agent enough information to build queries that can include results using both addresses on the graph. We do this by setting a `display-set-source` and `display-set-dest` in the `reference` section of the task. These use `jq` to dynamically set the values based on the source and destination. The task definition should look like the following and you can copy the definition of `display-set-source` and `display-set-dest` exactly to your template::

     "example_throughput" : {
        "reference": {
            "display-set-source": "{% jq .addresses[0]._meta.\"display-set\" %}",
            "display-set-dest": "{% jq .addresses[1]._meta.\"display-set\" %}",
            "display-task-name": "Example Throughput",
            "display-task-group": ["Example Dashboard"]
        },
        "group" : "example_thr_group",
        "schedule" : "schedule_0"
        "test" : "example_thr_test"
    }

.. _psconfig_grafana_agent-advanced:

Advanced Configuration
-------------------------
The primary configuration file for the agent lives in ``/etc/perfsonar/psconfig/grafana-agent.json``. It provides a number of options for fine-tuning your agent. The best way to edit the file is with the ``psconfig agentctl`` command. You can get a full list of options supported by the agent with the following::

    psconfig agentctl grafana ?
    
For full details on how to use the `psconfig agentctl` command to display, set, and unset properties run::

    psconfig agentctl --help:

.. _psconfig_grafana_agent-troubleshoot:

Troubleshooting
===================

.. _psconfig_grafana_agent-troubleshoot-stats:

Looking at the last run with ``psconfig stats grafana``
-----------------------------------------------------------
It's often helpful to know 
     psconfig stats grafana

Below is an example of the successful output::

    Agent Last Run Start Time: 2018/04/25 15:38:48
    Agent Last Run End Time: 2018/04/25 15:38:49
    Agent Last Run Process ID (PID): 3751
    Agent Last Run Log GUID: BF30C416-489E-11E8-8BB6-530A118410B6
    Total grids managed by agent: 8
    From include files: 5
        /etc/perfsonar/psconfig/grafana.d/template.json: 5
    From remote definitions: 3
        http://10.0.0.1/demo.json: 3

The output fields can be described as follows:

* **Agent Last Run Start Time** is the time when the agent began its last complete run.
* **Agent Last Run End Time** is the time when the last complete run ended.
* **Agent Last Run Process ID (PID)** is the process ID of the agent at the time of its last complete run. This should only change if the agent is restarted.
* **Agent Last Run Log GUID** is a globally unique ID used to identify a run in the logs. You can grep the :ref:`log file <psconfig_grafana_agent-troubleshoot-logs>` with this ID to get the information about a specific run. 
* **Total grids managed by agent** is the number of pSConfig *task* objects that match a grid configured by the agent from all input sources.
* **From include files** is the number of pSConfig *task* objects that match a grid configured by the agent that come from templates in the template include directory. Directly underneath that is a breakdown of the task count by the file from which they originate.
* **From remote definitions** is a count of the number of pSConfig *task* objects that match a grid configured by the agent that come from URLs added using the ``psconfig remote`` command. Underneath is a breakdown of the task count by URL. 

This command is useful as a quick health check of the agent. It can answer questions like:

* When did my agent last run?
* What templates is it using?
* Is it building the expected set of grids?

Also, if it throws an error that can be useful information too. In particular the output below is a good sign that your agent has never ran since it has not created the necessary log file::

    Unable to open /var/log/grafana/psconfig-grafana-agent.log: No such file or directory
    
This script may not give all the answers, but will hopefully get things started when debugging unexpected behavior of the agent.

.. _psconfig_grafana_agent-troubleshoot-logs:

Reading the Logs
-----------------
If you need to debug beyond what the utilities above provide from the logs, then you can manually look at the log files. There us one primary log used by the agent:

    * The **agent log** lives at ``/var/log/perfsonar/psconfig-grafana-agent.log`` and tracks basic information about agent activity and any errors encountered.
    * The **task log** lives at ``/var/log/perfsonar/psconfig-grafana-agent-tasks.log`` and tracks the pScheduler tasks the agent tries to display. This log is useful if you need to look at how pSConfig is defining tasks it gives (or tries to give) to Grafana. 
    * The **transaction log** lives at ``/var/log/perfsonar/psconfig-grafana-agent-transactions.log`` and logs each individual interaction with Grafana's API.

The logs are designed to by parsable with fields in the form of ``key=value`` separated by whitespace. Every line has a ``guid=`` field with an ID unique to the run of an agent. As an example, the GUID can be used for filtering log lines with ``grep`` or similar tools.  It is often easiest to run the ``psconfig stats grafana`` :ref:`command <psconfig_grafana_agent-troubleshoot-stats>` to get the GUID of the last run as a launching point to parse the log. For example, looking at the example output from :ref:`psconfig_grafana_agent-troubleshoot-stats`, the run had a GUID of ``BF30C416-489E-11E8-8BB6-530A118410B6``. Knowing this GUID, all the log messages associated with that run can be queried using a command like the following::

    grep "guid=BF30C416-489E-11E8-8BB6-530A118410B6" /var/log/perfsonar/psconfig-grafana-agent.log

You can further filter that output if needed, and hopefully eventually find the information needed to solve any issues encountered.

.. _psconfig_grafana_agent-reading:

Further Reading
=========================
* For a full listing of pSConfig Grafana Agent related files see the reference :ref:`here <config_files-psconfig>`
