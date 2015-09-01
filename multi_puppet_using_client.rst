*******************************
Configuring the puppet clients
*******************************

Notes
===============

* The puppet version in `EPEL` is old (2.7.23)
* Full configuration instructions can be found in the `Puppet Post-Install Documentation`_
* Don't forget to create and sign a `certificate for each client node`_

.. _Puppet Post-Install Documentation: http://docs.puppetlabs.com/guides/install_puppet/post_install.html 
.. _certificate for each client node: http://docs.puppetlabs.com/guides/install_puppet/post_install.html#sign-the-new-nodes-certificate

Configuring the client nodes
=============================

If you have configured your server according to the example :doc:`/multi_puppet_using_server`, you can use the same puppet.conf on your client nodes. Simply copy ``/etc/puppet/puppet.conf`` from your server to any client nodes.

Otherwise, after installing Puppet, edit the default /etc/puppet/puppet.conf that was created during the install process, or use `this example puppet.conf`_.

.. _this example puppet.conf: https://raw.githubusercontent.com/perfsonar/central-management/master/config-management/puppet/etc/puppet/puppet.conf

The only part you should have to change is the hostname at the top::

    server = hostname.test.com

Substitute your server's hostname here. Note that this parameter is optional for the server, but if you configure it here, you can use the same puppet.conf on the clients and on the server.



