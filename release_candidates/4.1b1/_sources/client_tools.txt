**********************
perfSONAR Client Tools 
**********************

perfSONAR includes some sample tools to retrieve perfSONAR data from the measurement archive (called esmond) and from the Lookup Service (called sLS). You can also use the :doc:`client_apis` to write your own tools.


esmond clients
--------------
esmond Service clients are available at https://pypi.python.org/pypi/esmond_client/, or can be installed using python's *easy_install*:
::

     easy_install esmond-client

esmond clients include:

- esmond-ps-get-metadata
- esmond-ps-get-endpoints
- esmond-ps-get
- esmond-ps-get-bulk


Lookup Service clients
------------------------
Lookup Service clients are available at https://pypi.python.org/pypi/sls-client/, and can be installed using python's *easy_install*:
::

   easy_install sls-client

The sLS clients include:

- find_ps_ma:  a command line script that returns a list of MAs that have test results for given host. 
- sls_dig:  a script that is similar to "dig" tool. It retrieves information about a host registered in the sLS. 
- sls_report: generate a report of all hosts in the Lookup Service


To run sls_dig: sls_dig <host-name>

To run find_ps_ma: find_ps_ma -n <host-name>

The sls_dig is especially useful if you debugging some problem and want to do a quick lookup on a host registered in the lookup-service. 


Working with GridFTP Data
-------------------------

perfSONAR provides some mechanisms for uploading GridFTP logs into a perfSONAR measurement archive.  
Sample code for this is available in `github <https://github.com/esnet/esmond/blob/develop/esmond_client/clients/esmond-ps-load-gridftp>`_.

Instructions for using and running the script here:
http://software.es.net/esmond/perfsonar_gridftp.html

