**********************
perfSONAR Client Tools 
**********************

perfSONAR includes some sample tools to retrieve perfSONAR-related data. You can also use the :doc:`client_apis` to write your own tools.


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

