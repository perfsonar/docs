*******************************
Microdep - Event based analysis
*******************************

The  *Microdep* add-on provides a toolset which analyses raw measurements from ``latencybg`` amd ``traceroute`` test, and presents results in a map/GIS-based web GUI.

The name "Microdep" stems from the objective to study, on small time scales, dependability variations observed in end-to-end active measurements. The original ambition was to perform measurements accurate enough to do analysis on a microsecond timescale. However, due to limitations on time accuracy of current systems running perfSONAR, analysis is currently on a millisecond timescale. But in the future...

.. _addon_microdep_installation:

Installation
------------

*Microdep* is available to install via Linux distribution packages from the package repo of perfSONAR version >= 5.3.0. On Debian based distribution (e.g Debian and Ubuntu) apply::
  
   sudo apt install <package-name>

On Red Hat based distributions (e.g. Alma Linux and Rocky Linux) apply::

   sudo dnf install <package-name>

The three core packages to be installed to enable the *Microdep* add-on are

  *  *perfsonar-microdep-map* - Web based map GUI
  *  *perfsonar-microdep-ana* - Analytic scripts reporting anomalities 
  *  *perfsonar-microdep-archive* - Storage additions to "feed" the analytic scripts and store reported anomality events

The add-on may be install on different perfSONAR system architectures. Two variant are described in the following subsection.

Note that no install will output results "out of the box", i.e. some configuration (see :ref:`addon_microdep_configuration`) is always required.
  
All-in-one / toolkit
^^^^^^^^^^^^^^^^^^^^

The most straight forward install of *Microdep* is done on a perfSONAR toolkit host (see :doc:`install_quick_start`), i.e. on a host running a full suit of perfSONAR functionality.

To add *Microdep* run::

    sudo [apt|dnf] install perfsonar-microdep-toolkit

The microdep-toolkit "umbrella" package will ensure installation of the full collection of required packages, i.e. all three mentioned above including their dependencies.
    
Distributed
^^^^^^^^^^^

In operatinal large scale perfSONAR installations system components are typically distributed among several hosts (physical or virtual). One such "hyper distributed" architecture may include 

  * An **User interface** host providing the perfSONAR web GUI.
  * An **Analysis** host to run analytic scripts and return misc findings (e.g. anomality events).
  * A **Measurement archive** host (or cluster) running storage components only (see :doc:`multi_ma_install`)
  * A **Test point** host, or normally a number of testpoints, being hosts running the actual measurements and repoting (raw) results.
  * A **Measurement configuration** host to manage and distribute mesurement topology configurations to testpoints.

See :doc:`install_options` for more info about what software bundles the above hosts may install. 
    
Typical installations will often combined one or more of the above mentioned hosts into one host ("toolkit" being the extreme all-in-one case). A perfSONAR "standard central archive" (described in :doc:`cookbook_central_archive`) is such an architecture.

To install the *Microdep* add-on on the above "hyper distributed" system, add new packages as follows:

  * On the **User interface** host::

      sudo [apt|dnf] install perfsonar-microdep-map

  * On the **Analysis** host::

      sudo [apt|dnf] install perfsonar-microdep-ana

  * On the **Measurement archive** host::

      sudo [apt|dnf] install perfsonar-microdep-archive

If you e.g. choose to run the user interface on the measurement archive host, you install both `perfsonar-microdep-map` and `perfsonar-microdep-archive` on that same host.
      
Verify the install
^^^^^^^^^^^^^^^^^^

Before starting to configure your system to utilize the *Microdep* add-on you may verify the add-on to be operational.

**Preview the map GUI** by accessing https://your.user-interface.host/microdep. An empty map similar to the one blow should be visible.

.. image:: images/addon_microdep_empty-map.png
        :target: _images/addon_microdep_empty-map.png
        :scale: 20 %
	:align: center

**Check status of analysis**. Logg into you analysis host and run::

    systemctl status perfsonar-microdep-gap-ana perfsonar-microdep-trace-ana | grep Loaded:

The response below should appear::

    Loaded: loaded (/lib/systemd/system/perfsonar-microdep-gap-ana.service; enabled; preset: enabled)
    Loaded: loaded (/lib/systemd/system/perfsonar-microdep-trace-ana.service; enabled; preset: enabled)

**Examine the archive main dashboard** by visiting  https://your.user-interface.host/grafana. Verify that new "raw" testrun counters have appeared, i.e. similary to the image below

.. image:: images/addon_microdep_raw-counters.png
        :target: _images/addon_microdep_raw-counters.png
        :scale: 50 %
	:align: center

Note that an empty plot will appear here if your perfSONAR system has no tasks configured, i.e. you perfSONAR archive has never received results from any tests (or your user interface host cannot access you archive host).

.. _addon_microdep_configuration:

Configuration
------------- 

The current version of the *Microdep* add-on performs analysis and reports results based on two types of tests: **traceroute** and **latencybg** ( see :doc:`pscheduler_ref_tests_tools`). Hence, for the add-on to output anything of interest at least one *traceroute task* or one *latencybg task* needs to be configured to generate input to the analysis components.

Task configuration may be achived by several means.
  * A GUI-based configuration service is available (see :doc:`pscompose_intro`).
  * Via CLI pscheduler may be instructed to initiate tasks directly (see :doc:`pscheduler_intro`).
  * A JSON-file with all data required for task initiation may be composed (in a text editor), and published via psConfig (see :doc:`psconfig_intro`).

.. _addon_microdep_raw-output:
    
Latency tests - raw output
^^^^^^^^^^^^^^^^^^^^^^^^^^

Microdep analysis of data-sets from latencybg-test (i.e. the perfsonar-microdep-gap-ana service) requires raw data to be reported by the latency measurement tools (owamp). To enable raw data either

 * tick the *output raw* box in you test specification in psCompose 
 * add ``--output-raw`` to the pscheduler commandline when initiating a latencybg-test (see :doc:`pscheduler_ref_tests_tools`). 
 * add ``output-raw: true`` in the settings structure of latencybg test specifications in your psConfig JSON file. Example below::

     {
     ...
       "tests" : {
         "my-latencybg-test" : {
           "spec" : {
              ...
              "output-raw" : true,
              ...
            },
            "type" : "latencybg"
          }
       }
     ...
     }
     
Connecting hosts - Microdep's data-flow
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As explained in :ref:`addon_microdep_installation` the *Microdep* add-on consists of three core components; a map wed-GUI, analytic services and archiving additions. These components required the data-flow illustrated below to be operational. 

.. image:: images/addon_microdep_data-flow.png
        :target: _images/addon_microdep_data-flow.png
        :scale: 75 %
	:align: center

Test datapackets flow between *Testpoint* hosts to perform measurements. Measurement data (raw for latencybg tests) are uploaded to the *Archive* host. *Analysis* services download results from the *Archive*, process them, and upload record with analytic results back to the *Archive*. The *Map GUI* fetches topology info, analytic results and measurement data from the *Archive* for presentation.

Each arrow in the diagram requires configuration.

  * **Testpoint <-> Testpoint**: Configured in task/test specification (psCompose, pScheduler, psConfig, see also :ref:`addon_microdep_raw-output`).
  * **Testpoint -> Archive**: Configured in task/test specification (psCompose, pScheduler, psConfig).
  * **Archive -> Analysis**: Specified on *analysis* host in YAML config file for each analytic service.

    * In ``/etc/perfsonar/micordep/microdep-gap-ana.yml`` for gap analysis (based on latencybg data)::

	...
        owamp: "https://your.perfsonar.archive.host/opensearch"
        ...
	
    * In ``/etc/perfsonar/micordep/microdep-trace-ana.yml`` for traceroute analysis (based on traceroute data)::

	...
        pssrc: "https://your.perfsonar.archive.host/opensearch"
        ...
	
  * **Analysis -> Archive**: Specified on *Analysis* host in JSON config file and YAML config file for each analytic service.
    
    * In ``/etc/perfsonar/microdep/microdep-ana-archive.json`` for all analytic services. You may generate such a JSON specification by running ``/usr/local/bin/psconfig_archive_ana.sh`` on your *Archive* host. You will probably need to adjust the `_url:` value to match your archive hostname (and probably adjust the authentication setup). An example is::

        {
            "archiver": "http",
            "data": {
                "schema": 1,
                "_url": "https://your.perfsonar.archiv.host/logstash-ana",
                "verify-ssl": false,
                "op": "put",
                "_headers": {
                    "content-type": "application/json",
                    "Authorization":"Basic SomeHashValueSomeHashValueSomeHashValue"
                }
            }
        } 
 
    * In ``/etc/perfsonar/micordep/microdep-gap-ana.yml`` for gap analysis::

	...
        json: "/etc/perfsonar/microdep/microdep-ana-archive.json"
        ...
	
    * In ``/etc/perfsonar/micordep/microdep-trace-ana.yml`` for traceroute analysis::

	...
	oneoutput: "/etc/perfsonar/microdep/microdep-ana-archive.json"
        ...

Note that when install ``perfsonar-microdep-toolkit`` on a perfSONAR *Toolkit* host the default configuration files for the add-on should ensure operation without additional configuration.

Operation
---------

*Microdep* analyses raw results from **latencybg tests**, and results from **traceroute tests**, both UDP and TCP based. The following subsections presents details about what type of analysis is performed and what type of new (aggregated) results are generated.

Gap analysis
^^^^^^^^^^^^

Microdep search for *Gaps* in data flows from latencybg tests (i.e. by owamp tools) and generate event records when such are found.

A *Gap* is defined as a sequence of one or more lost packets. There are two classes of *Gaps*:

  * **Large gaps**: 5 or more consequtive packets are missing (sometimes also called "Big gaps")
  * **Small gaps**: Less than 5 packets are missing

A *Large gap* is considered closed when 5 consequtive packets arrive correctly in sequence.

The thresholds for gaps may be configured in ``/etc/perfsonar/micordep/microdep-gap-ana.yml`` by adjusting ``minloss:`` and ``recover:``.

Event records for *Large gaps* contained a generous collection of data. The often more relevant are:

  *
  *

*Small gaps* are only counted and reported in summary records, typically once per 24h.

Jitter analysis
^^^^^^^^^^^^^^^

Queue analysis
^^^^^^^^^^^^^^

