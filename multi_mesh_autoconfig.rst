**************************************
Automatic Test Configuration
**************************************

If you have a very large mesh or a mesh that frequently is adding and removing test members, then it may become cumbersome to manually update your tests. For this reason the perfSONAR MeshConfig software has the concept of *automatic test configuration*. 

Automatic test configuration's goal is NOT zero configuration, instead the idea is that there will be some initial configuration steps performed on a server hosting the MeshConfig that describes the tests in a general sense as opposed to explicitly naming each host that will be involved in a test. The MeshConfig provides constructs in the form of *host classes* and *tags* in support of this idea. See :ref:`multi_mesh_autoconfig-classes` for more information on these constructs. 

Once this initial configuration has taken place, each new host can simply point at this central file and know the tests to run *without the administrator of the central mesh configuration file having to update the mesh every time a new host is added* (this last part is what distinguishes it from a traditional MeshConfig setup). The configuration on the end host should also be minimized (though again it will be greater than zero). The configuration primarily consists of pointing at the URL where the central mesh lives (and perhaps optionally pointing at a private lookup service). 

The individual client configurations are simplified even further by using external configuration management software such as `Puppet <https://puppetlabs.com>`_ or similar. Essentially the configuration management software of your choice will need to copy one or two (depending on your use case) configuration files to each new host. See our document on using the :doc:`perfSONAR Puppet module <multi_puppet_install>` for more information on using this type of setup with puppet specifically or for ideas on how to integrate with another configuration managements software of your choosing.

Once you have the basic ideas, there are a few common setups worth discussing further. First, using automated testing  constructs you can develop a simple automated configuration that tests to a fixed set of endpoints. For example, every new host that comes up may always test to the same two hosts, not aware of any other host that comes-up. See :ref:`multi_mesh_autoconfig-fixed` for more details.

You may also go even further and build a dynamic list of hosts from the perfSONAR Lookup Service. In this configuration, new nodes are discovered by other nodes in the mesh and the endpoint to which they test are changed accordingly. For information on this configuration, see :ref:`multi_mesh_autoconfig-dynamic`.


.. _multi_mesh_autoconfig-classes:

Introducing Host Classes and Tags
=================================
There are two main constructs that go into generating dynamic meshes: *host classes* and *tags*. Host classes allow you to describe criteria for a host and its addresses that you want in a test configuration. This is in constrast to the traditional case where you explicitly define the host. You then reference a class instead of a host address in your test groups allowing for any new hosts that match the defined criteria to automatically be included. Let's take a look at a simple example that matches all IP addresses of hosts in the current mesh file with the subnet 10.0.1.0/24::

    <host_class>
        name      my_subnet_class

        <data_source>
            type     current_mesh
        </data_source>

        <match>
           <filter>
               type   netmask
               netmask   10.0.1.0/24
           </filter>
        </match>
    </host_class>


The example above contains the following structural parts common to all classes (see also :ref:`config_mesh-dynamic_gen` for more details):

* The class *name* that identifies the class. We'll use this later in a :ref:`group <config_mesh-group>` definition to indicate we want class members in a specific group.
* The *data source* which indicates the initial list of hosts to filter against. In this case, we specified *current_mesh*, which means any host defined in this mesh or it's include files. For other types of data sources see :ref:`config_mesh-dynamic_sources`. 
* The *filters* in the form of a *match* block. The filter directives define the criteria a host must meet and the match directive indicates if the criteria are met to include ir in the mesh. Not shown is the *exclude* block which defines criteria for  hosts you want excluded for the mesh. For more information on the types of filters available see :ref:`config_mesh-dynamic_filters`.

Host classes allow for a lot of interesting selection criteria. They are made even more powerful though by the second construct: *tags*. Tags are custom labels you can add to any  :ref:`organization <config_mesh-organization>`, :ref:`site <config_mesh-site>`, :ref:`host <config_mesh-host>`, or :ref:`address <config_mesh-address>` directive. You can then match against these using the *tag* filter in your host class. A common use case for this is to tag addresses designated for latency tests and those for throughput tests as such. If we extend our example above and assume that we have tagged addresses in the 10.0.1.0/24 as latency or throughput, we can define the following two classes to distinguish each::

    <host_class>
        name      my_subnet_latency_class

        <data_source>
            type     current_mesh
        </data_source>

        <match>
           <filter>
               type   netmask
               netmask   10.0.1.0/24
           </filter>
           <filter>
               type   tag
               tag    latency
           </filter>
        </match>
    </host_class>
    
    <host_class>
        name      my_subnet_throughput_class

        <data_source>
            type     current_mesh
        </data_source>

        <match>
           <filter>
               type   netmask
               netmask   10.0.1.0/24
           </filter>
           <filter>
               type   tag
               tag    throughput
           </filter>
        </match>
    </host_class>

Notice that each match block has two filters: one of type netmask and another of type tag. There is an implied AND condition between filters like this of different types.

.. note:: You can also explicitly define filters such as AND, OR and NOT. See :ref:`config_mesh-dynamic_filters`

This example really just focuses the host class and tag constructs. It is also not an exhaustive list of all the options available for each of these constructs. See the sections that follow for some further examples of the uses of these constructs. 

.. _multi_mesh_autoconfig-fixed:

Testing to a Fixed Set of Target Hosts
======================================
Perhaps the simplest way to get started with automatic test configuration is having each each new tester test to a fixed set of locations. This test scenario is the right case for you if all of the following hold true:

* You want every dynamic tester to test to the same set of endpoints
* You do not need each tester to know about the other automatically configured testers
* You do not want your automatic tester to appear in a dashboard

In order for this case to work you will need to define the appropriate directives in your :ref:`central MeshConfig file <multi_mesh_autoconfig-fixed-server>` and in the :ref:`agent configuration <multi_mesh_autoconfig-fixed-client>` of the new testers.

.. _multi_mesh_autoconfig-fixed-server:

MeshConfig Server Configuration
-------------------------------


As an example, let's use the following MeshConfig file::

    description      Example Mesh

    <organization>
      description    Acme

      <site>
        <host>
          description    host1.example
          address        host1.example
        </host>
      </site>
  
      <site>
        <host>
          description    host2.example
          address        host2.example
        </host>
      </site>
  
    </organization>

    <host_class>
        name      owamp_agents

        <data_source>
            type     requesting_agent
        </data_source>

        <match>
           <filter>
               type   netmask
               netmask   10.0.1.0/24
           </filter>
        </match>
    
        <host_properties>
            <measurement_archive>
            type        perfsonarbuoy/owamp
            read_url    http://ma.example/esmond/perfsonar/archive
            write_url   http://ma.example/esmond/perfsonar/archive
          </measurement_archive>
        </host_properties>
    </host_class>
    
    <group owamp_group>
      type              disjoint
  
      a_member          host1.example
      a_member          host2.example
  
      b_member          host_class::owamp_agents
    </group>
    
    <test_spec owamp_test>
      type              perfsonarbuoy/owamp
      packet_interval   0.1
      sample_count      600every 600 packets)
    </test_spec>
    
    <test>
      description       OWAMP Tests
      group             owamp_group
      test_spec         owamp_test
    </test>

Let's break down each portion of this file. At the top we define an organization with 2 sites, each containing one host::

    ...
    <organization>
      description    Acme

      <site>
        <host>
          description    host1.example
          address        host1.example
        </host>
      </site>
  
      <site>
        <host>
          description    host2.example
          address        host2.example
        </host>
      </site>
  
    </organization>
    ...
    
The addresses of these hosts are *host1.example* and *host2.example* respectively. These hosts will be the fixed endpoints of any new testers we bring up matching the host class we have defined. Our host class, named *owamp_agents* is defined as follows::
 
    ...
    <host_class>
        name      owamp_agents

        <data_source>
            type     requesting_agent
        </data_source>

        <match>
           <filter>
               type   netmask
               netmask   10.0.1.0/24
           </filter>
        </match>
    
        <host_properties>
            <measurement_archive>
            type        perfsonarbuoy/owamp
            read_url    http://ma.example/esmond/perfsonar/archive
            write_url   http://ma.example/esmond/perfsonar/archive
          </measurement_archive>
        </host_properties>
    </host_class>
    ...
    
The first portion to note is the *data_source* of type *requesting_agent*. This means the host class is only compared against client hosts reading this mesh. The *match filter* defined specifies we match against any host's address that has a netmask of *10.0.1.0/24*.  In this class, we also define something called *host_properties*. This is not used for matching, instead it is properties given to a host that matches this class. In this example, it sets the measurement archive for any matching host to store data at *http://ma.example/esmond/perfsonar/archive* (our central archive in this example).

Once the class *owamp_agents* is defined, we are free to reference it in a test *group* as follows::

    <group owamp_group>
      type              disjoint
  
      a_member          host1.example
      a_member          host2.example
  
      b_member          host_class::owamp_agents
    </group>
    
 
Next we define the parameters for our test::

   <test_spec owamp_test>
      type              perfsonarbuoy/owamp
      packet_interval   0.1
      sample_count      600every 600 packets)
   </test_spec>

Finally we bring it all together in the test definition::

     <test>
      description       OWAMP Tests
      group             owamp_group
      test_spec         owamp_test
    </test>

We can then use the *build_json* script as described in :doc:`multi_mesh_server_config` to publish our file to a web server where clients may download it.  

.. _multi_mesh_autoconfig-fixed-client:

MeshConfig Client Configuration
--------------------------------------

On each automatically configured tester you bring-up, you'll need to point it at the JSON file generated in the previous section. Assuming the JSON file is at http://mesh.example/mesh.json, you can do this in the :ref:`agent configuration file <config_files-meshconfig-conf-agent>` as follows::

    <mesh>
        configuration_url   http://mesh.example/mesh.json
    </mesh>

You'll also want to make sure the following is set if you would like to use the measurement archive specified in the host class::

    configure_archives 1

.. note:: This *configure_archives* option assumes the measurement archive provided by the mesh configuration file has :ref:`IP authentication <multi_ma_install-auth_ip>` setup for this host. This is because the mesh configuration cannot securely distribute usernames and API keys. See the :ref:`measurement archive documentation <multi_ma_install-auth_ip>` for information on how to configure IP authentication on your archive server. 

You'll also want to set the following if you are NOT using a Toolkit deployment::

    use_toolkit 0
    
Finally, you'll want to make sure your :ref:`regular testing configuration file <config_files-regtesting-conf-main>` only has the following lines uncommented:

    test_result_directory   /var/lib/perfsonar/regulartesting
    
.. note:: If you have additional *measurement_archive* directives in the file then your tests will be stored there IN ADDITION to those automatically configured by the mesh. This may or may not be desirable depending on your case.

.. _multi_mesh_autoconfig-fixed-tags:

Using Tags with Requesting Agents
---------------------------------

Lets modify our host_class for this example to use a *tag* instead of a *netmask* as follows::

    ...
    <host_class>
        name      owamp_agents

        <data_source>
            type     requesting_agent
        </data_source>

        <match>
           <filter>
               type     tag
               netmask  latency
           </filter>
        </match>
    
        <host_properties>
            <measurement_archive>
            type        perfsonarbuoy/owamp
            read_url    http://ma.example/esmond/perfsonar/archive
            write_url   http://ma.example/esmond/perfsonar/archive
          </measurement_archive>
        </host_properties>
    </host_class>
    ...

In this case, how do we tag our agent downloading the file so that it matches this class? Normally we would do it in the :ref:`host <config_mesh-host>` directive but by definition our requesting agent does not have one of those. Instead we have to add a *local_host* block to the clients :ref:`agent configuration file <config_files-meshconfig-conf-agent>`::

    <local_host>
        tag latency
    </local_host>
    
If the agent host as more than one address we can also tag individual addresses as follows::

    <local_host>
        <address>
            address 10.0.1.1
            tag latency
        </address>
        <address>
            address 10.0.2.1
            tag throughput
        </address>
    </local_host>

While it does require some additional configuration on the client, it also adds flexibility in using tags to build host classes with *requesting_agent* data sources.

.. _multi_mesh_autoconfig-dynamic:

Testing to a Dynamic Set of Target Hosts
========================================
In many cases, having every host test to a fixed set of endpoints may not meet your needs. Instead, you may want a more dynamic mesh where each tester detects the existence of the others and adjusts it's test set accordingly as members come and go. This is possible by using the MeshConfig constructs already discussed in conjunction with the *perfSONAR Lookup Service*. Such a configuration will allow you to do the following:

* Allow clients to automatically detect new testers, and remove any testers no longer in a mesh
* Include dynamically added testers in an automatically generated dashboard

In order for this case to work you will need access to a lookup service. It is **highly recommended** you use a `private lookup service <https://github.com/esnet/simple-lookup-service/wiki/PrivateLookupService>`_ for this purpose. Using the public lookup service exposes the risk of others being able to (intentionally or unintentionally) change the tests your host runs, perhaps in ways you do not desire. For more information on setting up a private lookup service see `this document <https://github.com/esnet/simple-lookup-service/wiki/PrivateLookupService>`_. Assuming you have a private lookup service setup, you can complete the configuration process by defining the appropriate directives in your :ref:`central MeshConfig file <multi_mesh_autoconfig-dynamic-server>` and in the :ref:`agent configuration <multi_mesh_autoconfig-dynamic-client>` of the new testers.

.. _multi_mesh_autoconfig-dynamic-server:

MeshConfig Server Configuration
------------------------------- 
 
On our MeshConfig server, the first thing we need to setup is a file that defines the hosts we want to extract from the lookup service. By default, you will find it as listed :ref:`here <config_files-meshconfig-conf-lookup_hosts>` for your operating system. An example of this file using a configuration that extracts all hosts running OWAMP (the service that performs one-way latency measurements) and tagged with the community *example*::
 
    ls_instance http://private-ls.example:8090/lookup/records

    <query>
        service_type owamp
    
        <filter>
            filter_key group-communities
            filter_value example
        </filter>
    
        <output_settings>
            organization_name Acme
        
            <measurement_archive>
                type perfsonarbuoy/owamp
                read_url http://ma.example/esmond/perfsonar/archive
                write_url http://ma.example/esmond/perfsonar/archive
            </measurement_archive>
        
            address_tag owamp
        </output_settings>
    </query>
 
Let's breakdown the major components of the file. First we have the *ls_instance* property which sets the private lookup service we want to use to query for hosts::

    ls_instance http://private-ls.example:8090/lookup/records
    ...
    
We can have one or more of these. If you provide multiple, each lookup service will be queried in search of hosts matching the criteria. Next up we have the *query* block::

    <query>
    ...
    </query>

We may have one or more of these blocks in the file. This is where a bulk of the work happens. Within each query you have to define one or more service types::

    service_type owamp
    
In our example we want *owamp* services. It may also be something like *bwctl* or *traceroute*. Next we may optionally define a list of filters::

    <filter>
        filter_key group-communities
        filter_value example
    </filter>

If you don't define any filters then all services of the specified type in the lookup service will return. For each filter that you do define, there is a *filter_key* and a *filter_value*. The key is the name of a lookup service field name you wish to match in the **service** record. You can find a complete list of valid field names in the `Lookup Service Records reference guide <https://docs.google.com/document/u/1/d/1dEROeTwW0R4qcLHKnA2fsWEz8fQWnPKSpPVf_FuB2Vc/pub>`_. 

.. note:: The :ref:`lookup hosts configuration file <config_files-meshconfig-conf-lookup_hosts>` currently only supports fields for **service** records and not fields in the host, interface, person or other records. 

The *filter_value* is the value you want the field specified by the *filter_key* to take in order to match. In our example we want the *group-communities* of the service record to take the value of *example*. 

Finally, with our filters defined, we can create *output_settings* which define what the :ref:`host <config_mesh-host>` directives look like in our MeshConfig file::

    <output_settings>
        organization_name Acme
        address_tag owamp
                
        <measurement_archive>
            type perfsonarbuoy/owamp
            read_url http://ma.example/esmond/perfsonar/archive
            write_url http://ma.example/esmond/perfsonar/archive
        </measurement_archive>
    
    </output_settings>
    
None of the fields are required but the example highlights a few common ones to set. First we can set the *organization_name*. This may be useful in later defining a host class that uses this host. In the same spirit, we can also define tags we want applied to the generated elements. In our example we apply an *address_tag* of *owamp*. Last, we can also set a :ref:`measurement_archive <config_mesh-ma>` that we want the generated host elements to use. These look just like the same element we'd define in a MeshConfig file with a *type*, *read_url* and *write_url*. 

Once this file is set, we can use it to build a host list the MeshConfig can understand with the following command:
    
    /usr/lib/perfsonar/bin/lookup_hosts --input /etc/perfsonar/meshconfig-lookuphosts.conf --output /var/www/dynamic_host_list.json
    

The *--input* parameter points to the file we just generated. The *--output* points to a location we we want the generated JSON file saved. Either can be changed if you would like things setup differently on your system in terms of file paths. The output file, will contain any hosts found in the lookup service. 
    
.. note:: It is highly recommended you add the *lookup_hosts* command to cron so the host list is frequently updated. 

Assuming the JSON is published, we are ready to setup our MeshConfig file. We can do so as follows::

    description      Example Dynamic Mesh
    
    include http://mesh.example/dynamic_host_list.json
    
    <host_class>
        name      owamp_agents

        <data_source>
            type     current_mesh
        </data_source>

        <match>
           <filter>
               type   tag
               netmask   owamp
           </filter>
        </match>
    </host_class>
    
    <group owamp_group>
      type              mesh
      
      member          host_class::owamp_agents
    </group>
    
    <test_spec owamp_test>
      type              perfsonarbuoy/owamp
      packet_interval   0.1
      sample_count      600every 600 packets)
    </test_spec>
    
    <test>
      description       OWAMP Tests
      group             owamp_group
      test_spec         owamp_test
    </test>

This file should look pretty familiar at this point, but let's highlight some of the important parts. First we use an *include* directive to insert our dynamically generated host list::

    include http://mesh.example/dynamic_host_list.json
    ...

Next we define a *host_class* that uses the current mesh as the data source (since it has an include of our dynamic list) that matches anything tagged *owamp*::

    <host_class>
        name      owamp_agents

        <data_source>
            type     current_mesh
        </data_source>

        <match>
           <filter>
               type   tag
               netmask   owamp
           </filter>
        </match>
    </host_class>

Notice that we do not need to explicitly define any hosts in this case. You of course, can mix explicit and dynamically generated hosts but for this simple example it is unnecessary. With this file defined, we can now convert it to JSON and publish it for our clients to consume. 


.. _multi_mesh_autoconfig-dynamic-client:

MeshConfig Client Configuration
-------------------------------

The configuration of the client in terms of the MeshConfig agent is largely the same as what is described in :doc:`multi_mesh_agent_config` and :ref:`multi_mesh_autoconfig-fixed-client`. There is not anything further to add on that file, but there is extra configuration to be done of the service that registers your clients in the lookup service. Specifically you need to do the following:

* Add a pointer to your private lookup service
* Configure any fields you use as a filter in :ref:`lookup hosts configuration file <config_files-meshconfig-conf-lookup_hosts>` if they are not automatically generated (for example, fields like *group-communities*). 

For our example we can do this simply by adding the following lines to the top of the :ref:`LS Registration configuration file <config_files-lsreg-conf-main>`::

    ls_instance http://private-ls.example:8090/lookup/records
    site_project example #site_project is group-communities in the lookup service
    
For more information on the options available in the :ref:`LS Registration configuration file <config_files-lsreg-conf-main>` see :doc:`config_ls_registration` for a complete configuration reference.

.. _multi_mesh_autoconfig-examples:

Examples of Common Host Class Configurations
============================================

.. _multi_mesh_autoconfig-tput_lat:

Testing to Addresses Tagged Throughput and Tagged 10GigE
---------------------------------------------------------

::

    <host_class>
        name      throughput_hosts

        <data_source>
            type     current_mesh
        </data_source>

        <match>
            <filter>
                type and #indicates all nested filters must be true
                
               <filter>
                   type   tag
                   tag   throughput
               </filter>
               <filter>
                   type   tag
                   tag   10gige
               </filter>
            </filter>
        </match>
    </host_class>
    
.. _multi_mesh_autoconfig-netmask:

Testing to All Addresses in an IP Subnet Except a Certain Address
-----------------------------------------------------------------
::

    <host_class>
        name      most_of_subnet

        <data_source>
            type     current_mesh
        </data_source>

        <match>
           <filter>
               type   netmask
               netmask   10.0.1.0/24
           </filter>
        </match>
        <exclude>
            <filter>
               type   netmask
               netmask   10.0.1.1/32 # Excludes 10.0.1.1 from matching
           </filter>
        </exclude>
    </host_class>

.. _multi_mesh_autoconfig-organization:

Testing to All Addresses NOT in an Organization
-----------------------------------------------
::

    <host_class>
        name      non_acme_inc_hosts

        <data_source>
            type     current_mesh
        </data_source>

        <match>
            <filter>
               type not
               
               <filter>
                   type   organization
                   description   acme
               </filter>
            </filter>
        </match>
    </host_class>
    
Alternatively using an exclude block::

    <host_class>
        name      non_acme_inc_hosts

        <data_source>
            type     current_mesh
        </data_source>

        <exclude>
           <filter>
               type   organization
               description   acme
           </filter>
        </exclude>
    </host_class>

Testing to All IPv6 Addresses Tagged Latency
--------------------------------------------
::

    <host_class>
        name      ipv6_latency_hosts

        <data_source>
            type     current_mesh
        </data_source>

        <match>
           <filter>
               type   address_type
               address_type   ipv6
           </filter>
           <filter>
               type   tag
               tag    latency
           </filter>
        </match>
    </host_class>
    
Combining Multiple Classes in a Match 
--------------------------------------
::

    <host_class>
        name      subnet1_latency

        <data_source>
            type     current_mesh
        </data_source>

        <match>
           <filter>
               type   tag
               tag   latency
           </filter>
           <filter>
               type  netmask
               tag   10.0.1.0/24
           </filter>
        </match>
    </host_class>
    
    <host_class>
        name      subnet2_latency

        <data_source>
            type     current_mesh
        </data_source>

        <match>
           <filter>
               type   tag
               tag   latency
           </filter>
           <filter>
               type  netmask
               tag   10.0.2.0/24
           </filter>
        </match>
    </host_class>
    
    <host_class>
        name      subnet1and2_latency

        <data_source>
            type     current_mesh
        </data_source>

        <match>
           <filter>
               type   class
               class  subnet1_latency
           </filter>
           <filter>
               type   class
               class  subnet2_latency
           </filter>
        </match>
    </host_class>
    

