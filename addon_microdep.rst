*******************************
Microdep - Event based analysis
*******************************

The  *Microdep* add-on provides a toolset which analyses raw measurements from ``latencybg`` and ``traceroute`` test, and presents results in a map/GIS-based web GUI.

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
  *  *perfsonar-microdep-ana* - Analytic scripts reporting anomalies 
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

**Check status of analysis**. Logg into you analysis host and run::

    systemctl status perfsonar-microdep-gap-ana perfsonar-microdep-trace-ana | grep Loaded:

The response below should appear::

    Loaded: loaded (/lib/systemd/system/perfsonar-microdep-gap-ana.service; enabled; preset: enabled)
    Loaded: loaded (/lib/systemd/system/perfsonar-microdep-trace-ana.service; enabled; preset: enabled)

**Examine the archive main dashboard** by visiting  https://your.user-interface.host/grafana. Verify that new "raw" testrun counters have appeared, i.e. similary to the image below

.. image:: images/addon_microdep_raw-counters.png
        :target: _images/addon_microdep_raw-counters.png
        :scale: 50 %

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

.. _addon_microdep_operation:

Operation
---------

*Microdep* analyses raw results from **latencybg tests**, and results from **traceroute tests** (both UDP and TCP based). The following subsections presents some details of the analysis performed and the new (aggregated) results generated.

Gap analysis
^^^^^^^^^^^^

Microdep search for *Gaps* in data flows from latencybg tests (i.e. by owamp tools) and generate event records when such are found. Event records are pushed to the **microdep_gap_ana** Opensearch index on the *Archive* host.

Parameters controlling Gap analysis may be adjusted by editing ``/etc/perfsonar/microdep/microdep-gap-ana.yml``. See (``<param>:``) in text below.

A *Gap* is defined as a sequence of one or more lost packets. There are two classes of *Gaps*:

  * **Large gaps**: 5 (``minloss:``) or more consequtive packets are missing 
  * **Small gaps**: Less than 5 (``minloss:``) packets are missing

A *Large gap* is considered closed when 5 consequtive packets arrive correctly in sequence (``recover:``).

Event records for *Large gaps* (with event_type = "gap") contains a generous collection of data. The often more relevant values are:

  * **Time lost** (tloss): Downtime in packet flow, i.e. size of gap in milliseconds.
  * **Queueing time** (h_ddelay): Difference between average end-to-end delay of 50 (``win:``) packets ahead of gap and the overall minimum delay observed in a sliding window of last 10000 (``slep:``) packets. 
  * **Jitter** (h_jit): Delay variations observed ahead of gap measured as specified by RFC3550 appendix A.8.
  * **Min delay** (h_min_d): Minimum end-to-end delay seen in a window of 10000  (``slep:``) packets ahead of gap.
  * **Slope** (h_slope_10): Slope of increase in delay ahead of a gap, based on 10 packets received before gap.

See also ``/etc/perfsonar/microdep/mapconfig.yml`` on your *User interface* host for descriptions. 

*Small gaps* are only counted and reported in summary event records (event_type = "gapsum"). Such records are output when the *perfsonar-microdep-gap-ana* service is stopped/reset, by default once every 24h.

.. _addon_microdep_jitter-analysis:

Jitter analysis
^^^^^^^^^^^^^^^

Microdep calculates *Jitter* in data flows from latencybg test (i.e. by owamp tools) by following reccommendations from `RFC3550 <https://datatracker.ietf.org/doc/html/rfc3550#section-6.4.1>`_.

Parameters controlling Jitter analysis may be adjusted by editing ``/etc/perfsonar/microdep/microdep-gap-ana.yml``. See (``<param>:``) in text below.

Simple moving averages are applied. The expressions imlemented are::
  
    D(i,j) = (Rj - Ri) - (Sj - Si) = (Rj - Sj) - (Ri - Si)
    J(i) = J(i-1) + (|D(i-1,i)| - J(i-1))/W

where *D(i,j)* is difference in packet spacing with *Si* and *Ri* being timestamps of packet when sent and received respectively, and *J(i) is jitter after receiving packet number *i*. *W* is a weighting factor set to 16 in RFC3550 but 5 (``rtp:``) in *Microdep*.

Jitter events records (with event_type = "jitter") are pushed to the same index as gap events , i.e. the **microdep_gap_ana** Opensearch index on the *Archive* host.  The maximum time between a jitter event records is 600 seconds (``jitter:``).

Queue analysis
^^^^^^^^^^^^^^

Parameters controlling *Queue* analysis may be adjusted by editing ``/etc/perfsonar/microdep/microdep-gap-ana.yml``. See ``<param>:`` in text below.

As an supplement to jitter measurements Microdep attempts to discover queuing events by looking for radical changes in average end-to-end delay of last 50 (``win:``) packets seen and the minimum end-to-end delay observed in a limited recent time window of 10000 (``slep:``) packets, termed **Queueing time** (or delay difference). Two thresholds apply:

  * When queuing time exceeds 10ms (``ddelay_high:``) significant queuing is considered to take place (i.e. a *queueing event* has started), and an extra jitter event record (see :ref:`addon_microdep_jitter-analysis`) is output presenting jitter (h_jit) and queueing time (h_ddelay) data.
  * When queuing time returns below 2ms (``ddelay_low:``) queuing is no longer considered significant (i.e. a *queuing event* has concluded), and an extra jitter event record is again output.

The more relevant data for queuing analysis output in jitter records are:

  * **Queuing time** (h_ddelay): Difference between average end-to-end delay of 50 (``win:``) packets ahead of gap and the overall minimum delay observed in a sliding window of last 10000 (``slep:``) packets. 
  * **Jitter** (h_jit): Delay variations observed ahead of gap measured as specified by RFC3550 appendix A.8.
  * **Min delay** (h_min_d): Minimum end-to-end delay seen in a window of 10000  (``slep:``) packets ahead of gap.

Route error analysis
^^^^^^^^^^^^^^^^^^^^

Microdep search for and report *Route errors* based on output from traceroute tests, both UDP and TCP. A simple anomaly detection algorithm is applied to enable event records output only when the status in a traceroute data set changes significantly.

Event records are pushed to the **microdep_trace_ana** Opensearch index on the *Archive* host.

Parameters controlling *Route error* analysis may be adjusted by editing ``/etc/perfsonar/microdep/microdep-trace-ana.yml``. See ``<param>:`` in text below.

Trace routes are examined for
  * Missing destination IP in last hop, i.e. never reaching its intended destination
  * ICMP errors returned from the network

Route error are documented by four type of event records:
  * **Route warning** (event_type = "routewarn"): An abnormal traceroute, being the (potential) start of a sequence of abnormal traceroutes.
  * **Route error** (event_type = "routeerr"): An number of abnormal traceroutes (default is 1, ``f_csensitivity:``) has being observed.
  * **Route normal** (event_type = "routenorm"): The most common traceroute observed, being 30 (``f_majority:``) or more than the second most common, has changed. The now most common traceroute is considered to be normal. 
  * **Route summary** (event_type = "routesum"): The *perfsonar-microdep-trace-ana* service has been stopped/restarted, triggering the output of a summary event record for the last time period it was running. Default reset interval is 24h.   

Route change analysis
^^^^^^^^^^^^^^^^^^^^^

Microdep search for and report *Route changes* based on output from traceroute tests, both UDP and TCP. A cross-entropy based algorithm is applied to detect when a route has changed significantly.

Event records are pushed to the **microdep_trace_ana** Opensearch index on the *Archive* host.

Parameters controlling *Route change* analysis may be adjusted by editing ``/etc/perfsonar/microdep/microdep-trace-ana.yml``. See ``<param>:`` in text below.

The algorithm applied has in short the following steps:
  * When a new traceroute measurement is available for a peer, a database of counters is updated, counting occurrences of specific IP-address at specific hops in the route.
  * For each hop on the route a `Monte Carlo estimates of the true cross entropy <https://en.wikipedia.org/wiki/Cross-entropy#Estimation>`_  of the IP-address distributions is calculated.
  * The (absolute) shift in cross-entropy value, i.e. the *ce-delta*, from previous to current measurement of each hop of a route is also calculated. 
  * A **Route change** event is recorded if one (or more) hops have *ce-delta* above 3.0 (``ce_delta_limit:``), i.e. the route is considered changed enough to be reported.

In the data set reported by *Route change* event some of the more relevant values are
  * **no_hops_over_ce_limit**: The total number hops in a route considered changed significantly from earlier traceroute measurements.
  * **routechange_ip**: IP-address in hop before first hop with high delta-ce value, i.e. the IP-address of router potentially responsible for a route change.
    * The event record is also enriched with the route-change IP's hostname, ASN, AS-name values.
  * **ce_delta**: A vector showing all ce-delta values along a route, i.e. indicating which part of a route has been changing (edge v.s. core).

User interface
--------------

A dedicated web based user interface to present Microdep event data is available via the ``perfsonar_microdep_map`` packages (see :ref:`addon_microdep_installation`).

A running measurements setup, with traceroute and latencybg test (the latter with *output-raw* enabled, see :ref:`addon_microdep_configuration`) results in a main map GUI similar to the image below

.. image:: images/addon_microdep_main-map-gui-circles.png
        :target: _images/addon_microdep_main-map-gui-circles.png
        :scale: 20 %

The main map GUI is composed of
  * A world map (Open street map) showing testpoint locations and measurement flows between them. See red circle in figure above.
  * A vertical navigation and search bar to the left. See blue circle in figure above.
  * A tab management bar above the world map. See green circle in figure above.

Test flow overview - World map
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When Microdep's analytic services find new traceroute or latencybg test results in the archive, a number event records may be generated (see :ref:`addon_microdep_operation`). The *world map* in the web user interface utilizes topology event records to present the test flow topology being analyzed. The image below shows such an example topology. 

.. image:: images/addon_microdep_map-gui-grey-flows.png
        :target: _images/addon_microdep_map-gui-grey-flows.png
        :scale: 40 %
.. image:: images/addon_microdep_map-gui-tlr-flows.png
        :target: _images/addon_microdep_map-gui-tlr-flows.png
        :scale: 40 %


Testpoint hosts are place at their geo-coordinates (when available), and grey lines are drawn between the testpoint running mesurements (left image above). The lines stay grey until at least one other (none-topoloy) event becomes available. *Traffic light rating* (TLR) is then applied to indicate which flow has reported more significat events (right image above). The TLR coloring reflects values for the currently selected *property* in the navigation/search bar.

Note that a flow line only indicate direction and endpoints of measurements. If the *show hop geo path* box is ticked in the navigation bar the map makes an attempt at drawing the actual route taken by the flows.

Summary popup window
^^^^^^^^^^^^^^^^^^^^

When clicking on a topology

.. image:: images/addon_microdep_map-gui-popup.png
        :target: _images/addon_microdep_map-gui-popup.png
        :scale: 40 %

More text here...

Summaries tables
^^^^^^^^^^^^^^^^

Traceroute viewer
^^^^^^^^^^^^^^^^^

Event record plots
^^^^^^^^^^^^^^^^^^


