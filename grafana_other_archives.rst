********************************************
Visualising Measurements from other Archives
********************************************
You can visualize measurement data from other meshes and their archives in the perfSONAR Grafana instance. Visualising measurements from other test results store is possible with a pSConfig agent running on such host that sets-up additional dashboards and if the data is in a remote archive, sets-up a perfSONAR Grafana data source that talks to this remote archive.

Installing perfSONAR Grafana on Separate Host
=============================================
You can optionally install perfSONAR Grafana on a separate host than your perfSONAR archive. In order to configure the perfSONAR repositories see appropriate section of :doc:`install_debian` or :doc:`install_el`. Then use relevant package managament command to install the following bundle: ``perfsonar-grafana``.

Adding Measurement Visualization from other Archive
===================================================
.. note:: This instruction assumes that remote mesh definition you want to be visualized is available under the following URL: https://archive.remote/psconfig/foo.json. Change it to your local environment.

In order to visualise measurements from other archive perform the steps below on the perfSONAR Grafana host:

#. Login to the system as a root user or use ``sudo``.

#. Run the following command to tell a pSConfig agent running on the perfSONAR Grafana host to setup new dashboards based on remote pSConfig template::

    # psconfig remote –-agent grafana add "https://archive.remote/psconfig/foo.json"
	
Checking pSConfig Configuration for Grafana
===========================================
In order to verify if pSConfig agent is configured properly run the following command::

$ psconfig remote list
	
The output of the command should look like the following. Your additional mesh confguration should be listed under *Grafana Agent* section.::

    === Grafana Agent ===
    [
       {
          "url": "https://archive.local/psconfig/bar.json"
       },
       {
          "url": "https://archive.remote/psconfig/foo.json"
       }
    ]
    
    === HostMetrics Agent ===
    [
       {
          "url": "https://archive.local/psconfig/bar.json"
       }
    ]
