****************************
Choosing a Management Method
****************************

perfSONAR nodes can be managed in the following ways:
  * a standalone node
  * part of a centrally managed mesh
  * a combination of the both of these methods

Standalone Node
---------------

If you only have one or two perfSONAR hosts, this is probably what you'll want to do.
In this mode, all configuration is done using the web interface on the perfSONAR node itself.

This is described under :doc:`Configuring Regular Tests <manage_regular_tests>`.

Centrally Managed Node
----------------------

If you want to create a perfSONAR dashboard such as http://ps-dashboard.es.net, or have several perfSONAR hosts to manage,
you probably want to use this method. Details are described under :doc:`Managing Multiple perfSONAR Toolkits <multi_overview>`.

Combination Node
----------------

If you configure tests via the web GUI, and put the host in a managed mesh, your host will run both sets of tests.
This is not recommended, as it can be confusing to figure out which tests are configured where. However
it can be useful if some other organization is managing the mesh that your host is in.



