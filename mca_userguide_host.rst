*****************
Hosts
*****************

Hosts page displays a list of all hosts and services loaded from configured sLS datasources. For non-super-admin, this is a readonly page mainly exists to 
show which hosts are available, and host information available. 

.. image:: images/mca/hosts.png

If you are MCA super-admin, you can edit the host information and override Measurement Archive endpoints by clicking the pencil button on the right / top corner.

.. image:: images/mca/editma.png

* toolkit_url: If toolkit_url is set to "auto", perfSonar maddash will use hostname of this record to auto-generate the URL that links back to the toolkit instance on maddash matrix view. If you use custom URL for your toolkit instance, change it to the real URL.

* No Agent: (As commented in UI)

* MA Overrides: If this toolkit instance should send test results to MA (Measurement Archives) other than the one that's running locally to this instance
please select the *central* MA to be used by this instance.
