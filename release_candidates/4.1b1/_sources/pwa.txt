*************************************
pSConfig Web Admin
*************************************

.. note:: BETA

pSConfig Web Admin (PWA) is a web-based UI for perfSONAR administrators to publish MeshConfig/pSConfig meshes, which automates tests executed by test nodes, and provides topology information to various services such as MadDash, OSG/WLCG datastore, and others.

TODO: UPDATE SCREENSHOT

.. image:: images/pwa/index.png
    :width: 450px

Included with PWA is a publisher that allows users to download defined meshconfig in JSON format.

.. image:: images/pwa/meshconfigjson.png
    :width: 450px

PWA relies on the perfSONAR Global Lookup Service to provide a list of hosts that administrator can select in PWA's host group editor. PWA can also load host information from a private `Simple Loookup Service <https://github.com/esnet/simple-lookup-service/wiki>`_ instance.

Guide
-------------------------
.. toctree::
   :maxdepth: 2

   pwa_install
   pwa_configure
   pwa_userguide
   pwa_operation

Please submit bug reports / feature request at `PWA Github Repo <http://github.com/perfsonar/pscweb/issues>`_
