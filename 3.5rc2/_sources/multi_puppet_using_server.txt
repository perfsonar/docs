****************************
Configuring the puppet master (server)
****************************

Notes
===============

* The puppet version in `EPEL` is old (2.7.23)
* Full configuration instructions can be found in the `Puppet Post-Install Documentation`_

.. _Puppet Post-Install Documentation: http://docs.puppetlabs.com/guides/install_puppet/post_install.html 

Introduction
=================

After installing Puppet, edit the default /etc/puppet/puppet.conf that was created during the install process, or use `this example puppet.conf`_.

.. _this example puppet.conf: https://raw.githubusercontent.com/perfsonar/central-management/master/config-management/puppet/etc/puppet/puppet.conf

The only part you should have to change is the hostname at the top::

    server = hostname.test.com

Substitute your server's hostname here. Note that this parameter is optional for the server, but if you configure it here, you can use the same puppet.conf on the clients and on the server.

Installing the Puppet Module
=======================

To use the perfSONAR puppet module, `download it from Github`_. You can clone it via git or download a ZIP file.

.. _download it from Github: https://github.com/perfsonar/central-management/

Once you have downloaded the module, change to the ``config-management/puppet/`` directory. There are two folders here:
* ``manifests``
* ``modules``

Copy the perfsonar directory to ``/etc/puppet/``::

    sudo cp -R perfsonar /etc/puppet/

You should now have a ``/etc/puppet/perfsonar`` directory containing the perfsonar module.

Declaring your nodes
=======================

To define your nodes, edit the Manifest file,  ``perfsonar/manifests/site_rhel6.pp``; modify it to suit your needs. This file is `also available here`_.

.. _also available here: https://raw.githubusercontent.com/perfsonar/central-management/master/config-management/puppet/perfsonar/manifests/site_rhel6.pp 

The example starts by defining a file bucket, which you can ignore::

    filebucket {
      main:
        path => false,
        server => puppet;
      local:
        path => "/var/lib/puppet/clientbucket/";
    }

Define the hostname of your syslog server, if you are using a central syslog::

    # The hostname of your syslog server
    $syslog_server = "syslog.test.com"

Declare a "default" node. Every node will use this configuration, unless its hostname matches any of the specific definitions later in the file::

    node default {
        class {'rhel6': 
            web100 => true}
        class {'perfsonar':
            mesh => 'mesh1',
            owamp => true,
            bwctl => false,
            rsyslog_client => true,
            rsyslog_server_host => $syslog_server,
            rsyslog_server => false,
            apache_enable => true,
            #mesh_config_server => true,
            # optional port definitions (if undefined, defaults are used)
            #rsyslog_tcp_port => '600',
            #http_port => 8000
        }
    }

In the example, our default node is set to use a web100 kernel, a member of 'mesh1', owamp is enabled, bwctl is disabled, it's configured as a syslog client, apache is enabled, and none of our ports are overridden. Some examples have been included to illustrate how to override ports. In addition to installing the needed software, the module will enable and disable services, and manage the iptables firewall to match the configuration specified here. 

Now we have a specific host definition. The host with the hostname `host1.test.com` will use this configuration, rather than the default::

    ## host1
    node 'host1.test.com' {
        include rhel6
        class {'perfsonar':
            mesh => 'mesh1',
            owamp => true,
            bwctl => true,
            regular_testing => true,
            ls_registration_daemon => true,
            mesh_config_client => true,
            mesh_config_server => false,
            esmond => true,
            esmond_pg_password => 'asdf',
            rsyslog_server_host => $syslog_server,
            #rsyslog_client => 'true',
            #rsyslog_tcp_port => '600',
            rsyslog_server => false,
            rsyslog_udp => false,
            #rsyslog_client => true,
        }
    }

Another specific host configuration::

    # host2
    node 'host2.test.com' {
        class {'rhel6': 
            web100 => false}
        class {'perfsonar':
            mesh => 'testbed',
            owamp => true,
            bwctl => true,
            rsyslog_client => true,
            rsyslog_server_host => $syslog_server,
            mesh_config_client => true,
            rsyslog_server => true,
            #rsyslog_tcp_port => '600',
            #mesh_config_server => true,
            #apache_enable => true,
        }
    }

Here is a declaration for our syslog server::

    # syslog server

    node 'syslog.test.com' {
        class {'rhel6': 
            web100 => false}
        class {'perfsonar':
            mesh => 'testbed',
            owamp => true,
            bwctl => true,
            rsyslog_server => true,
            #rsyslog_tcp_port => '600',
        }
    }

You can have as many node definitions as you like. Additional, you can specify regular expressions in your node definitions. Read the `Puppet node definition documentation`_.

.. _Puppet node definition documentation: http://docs.puppetlabs.com/puppet/3.8/reference/lang_node_definitions.html




