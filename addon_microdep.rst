*******************************
Microdep - Event based analysis
*******************************

The  *Microdep* add-on provides a toolset which analyses raw measurements from ``latencybg`` amd ``traceroute`` test, and presents results in a map/GIS-based web GUI.

The name "Microdep" stems from the objective to study, on small time scales, dependability variations observed in end-to-end active measurements. The original ambition was to perform measurements accurate enough to do analysis on a microsecond timescale. However, due to limitations on time accuracy of current systems running perfSONAR, analysis is currently on a millisecond timescale. But in the future...

.. _addon_microdep_installation:

Installation
------------

*Microdep* is available to install via Linux distribution packages from the package repo of perfSONAR version >= 5.3.0. On Debian based distribution (e.g Debian and Ubuntu) ``sudo apt install <package-name>`` is applied while on Red Hat based distributions (e.g. Alma Linux and Rocky Linux) ``sudo dnf install <package-name>`` is applied.

The three core packages to be installed to enable the Microdep add-on are

  *  *perfsonar-microdep-map* - Web based map GUI
  *  *perfsonar-microdep-ana* - Analytic scripts reporting anomalities 
  *  *perfsonar-microdep-archive* - Storage additions to "feed" the analytic scripts and store reported anomality events

Different perfSONAR system architecture are supported for the add-on. Two variant are described below.

Note that no install will output results "out of the box", i.e. some configuration (see :ref:`addon_microdep_configuration`) is always required.
  
All-on-one / toolkit
^^^^^^^^^^^^^^^^^^^^

The most straigh forward install of *Microdep* is done on a perfSONAR toolkit host (see :doc:`install_quick_start`), i.e. on a host running a full suit of perfSONAR functionality.

To add *Microdep* run::

    sudo [apt|dnf] install perfsonar-microdep-toolkit

The microdep-toolkit "umbrella" package will ensure the full collection of required packages are installed, i.e. all three mentioned above including their dependencies.
    
Distributed
^^^^^^^^^^^

In operatinal large scale perfSONAR installations system components are typically distributed among several hosts (physical or virtual). One such "hyper distributed" architecture may include a dedicated 

  * *User interface* host providing the perfsonar web GUI.
  * *Analysis* host to run analytic scripts and return misc findings (e.g. anomality events).
  * *Central measurement archive* host (or cluster) running storage components only (see :doc:`multi_ma_install`)
  * *Test point*, or normally a number of testpoints, being hosts running the actual measurements and repoting (raw) results.
  * *Measurement configuration* host to manage and distribute mesurement topology configurations to testpoints.

See :doc:`install_options` for more info about what software bundles the above hosts may install. 
    
Typical installations will often combined one or more of the above mentioned hosts into one host ("toolkit" being the extreme case). A perfSONAR "standard central archive" (described in :doc:`cookbook_central_archive`) is such a an architecture.

To install the *Microdep* add-on on the above "hyper distributed" system, add new packages as follows:

  * On the *User interface* host::

      sudo [apt|dnf] install perfsonar-microdep-map

  * On the *Analysis* host::

      sudo [apt|dnf] install perfsonar-microdep-ana

  * On the *Central measurement archive* host::

      sudo [apt|dnf] install perfsonar-microdep-archive


Verify the install
^^^^^^^^^^^^^^^^^^

Before starting to configure your system to utilize the *Microdep* add-on you may verify that the add-on is operational.

**Preview the map GUI** by accessing https://your.user-interface.host/microdep . An empty map similar to the one blow should be visible.

.. image:: images/addon_microdep_empty-map.png
        :target: _images/addon_microdep_empty-map.png
        :scale: 20 %
	:align: center

**Check status of analysis** by logging into you analysis host and running::

    systemctl status perfsonar-microdep-gap-ana perfsonar-microdep-trace-ana | grep Loaded:

The response below should appear::

    Loaded: loaded (/lib/systemd/system/perfsonar-microdep-gap-ana.service; enabled; preset: enabled)
    Loaded: loaded (/lib/systemd/system/perfsonar-microdep-trace-ana.service; enabled; preset: enabled)

**Examine the archive main dashboard** by visiting  https://your.user-interface.host/grafana. Verify that new "raw" testrun counters have appeared, i.e. similary to the image below

.. image:: images/addon_microdep_raw-counters.png
        :target: _images/addon_microdep_raw-counters.png
        :scale: 50 %
	:align: center

Note that an empty plot will appear here if your perfSONAR system has no tasks configured, i.e. you perfSONAR archive has never received results from any tests (or you user interface host cannot access you archive host).

.. _addon_microdep_configuration:

Configuration
------------- 

The current version on the *Microdep* add-on performs analysis and reports results based on to type of tests: **traceroute** and **latencybg** ( see :doc:`pscheduler_ref_tests_tools`). Hence, for the add-on to output anything of interest at least one *traceroute-task* or one *latencybg-task* needs to be configured to generate input to the analysis components of *Microdep*.

Task configuration may be achived by several means.
  * A GUI-based configuration service is available (see :doc:`pscompose`).
  * Via CLI pscheduler may be instructed to initiate tasks directly (see :doc:`pscheduler_intro`).
  * A JSON-file with all data required for task initiation may be composed (in a text editor), verified and published via psConfig (see :doc:`psconfig_intro`).

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

As explained in :ref:`addon_microdep_installation` the *Microdep* addon consists of three core components; a map wed-GUI, analytic services and archiving additions. These components assume the data-flow illustrated below is operational. 

.. image:: images/addon_microdep_data-flow.png
        :target: _images/addon_microdep_data-flow.png
        :scale: 75 %
	:align: center

Test datapackets flow between *testpoint* hosts to performce measurements. Measurement data (raw for latencybg tests) are uploaded to the *archive* host. *Analysis* services download results from the *archive*, process them, and upload record with analytic results. The *map GUI* fetches topology info, analytic results and measurement data for presentation.

Each arrow in the diagram requires configuration.

  * **Testpoint - Testpoint**: Configured in task/test specification (psCompose, psConfig, pScheduler).
  * **Testpoint - Archive**: Configured in task/test specification (psCompose, psConfig, pScheduler, :ref:`addon_microdep_raw-output`).
  * **Archive - Analysis**: Specified in yaml-config file for each analytic service.

    * In `/etc/perfsoner/micordep/microdep-gap-ana.yml` for gap analysis (based on latencybg data)::
       owamp: "https://your.perfsonar.archive.host/opensearch"
    * In `/etc/perfsoner/micordep/microdep-trace-ana.yml` for traceroute analysis (based on traceroute data)::
       pssrc: "https://your.perfsonar.archive.host/opensearch"

  * **Analysis - Archive**: Specified in json config file as well a yaml config file for each analytic service.
    
    * In `/etc/perfsonar/microdep/microdep-ana-archive.json` for all analytic services. The content should be the archive specification output when running `/usr/local/bin/psconfig_archive_ana.sh` on your archive host. You will need to adjust the `_url:` vaule to match your archive hostname (and probably improve the authentication setup). A example is::
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
	
    * In `/etc/perfsoner/micordep/microdep-gap-ana.yml` for gap analysis (based on latencybg data)::
       owamp: "https://your.perfsonar.archive.host/opensearch"
    * In `/etc/perfsoner/micordep/microdep-trace-ana.yml` for traceroute analysis (based on traceroute data)::
       pssrc: "https://your.perfsonar.archive.host/opensearch"
       
 
