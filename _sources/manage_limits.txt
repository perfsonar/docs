***************************************
Limiting Tests to R&E Networks Only
***************************************

ESnet generates a nightly update of a file with a list of subnets that can be used to limit testing only to 
Research and Education networks around the world, and nothing else.

The pScheduler limits system can use this file to control who can run tests to your host.

A sample pScheduler limits file to use this is available at:
  * /usr/share/doc/pscheduler/limit-examples/identifier-ip-cidr-list-url on hosts with pscheduler installed
  * https://raw.githubusercontent.com/perfsonar/pscheduler/master/pscheduler-docs/pscheduler-docs/limit-examples/identifier-ip-cidr-list-url

Additional information on the ESnet generated filter lists is available at:
  * http://fasterdata.es.net/performance-testing/perfsonar/esnet-perfsonar-services/esnet-limits-file/

Note that perfSONAR 4.0 hosts running bwctl for backward compatibility will need to follow the instructions on fasterdata.es.net to add limits to bwctl as well. 

More information on how to use the pScheduler limits system can be found at: :doc:`pscheduler_server_limits`.




