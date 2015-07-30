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
      type              perfsonarbuoy/owamp  # Perform a constant low-bandwidth OWAMP test
      packet_interval   0.1                 # Send 10 packets every second (i.e. pause 0.1 seconds between each packet)
      loss_threshold    10                   # Wait no more than 10 seconds for a response
      sample_count      600                  # Send results back every 60 seconds (once every 600 packets)
      packet_padding    0                    # The size of the packets (not including the IP/UDP headers)
      bucket_width      0.001                # The granularity of the measurements
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
      type              perfsonarbuoy/owamp  # Perform a constant low-bandwidth OWAMP test
      packet_interval   0.1                 # Send 10 packets every second (i.e. pause 0.1 seconds between each packet)
      loss_threshold    10                   # Wait no more than 10 seconds for a response
      sample_count      600                  # Send results back every 60 seconds (once every 600 packets)
      packet_padding    0                    # The size of the packets (not including the IP/UDP headers)
      bucket_width      0.001                # The granularity of the measurements
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

On each automatically configured tester you bring-up, you'll need to point it at the JSON file generated in the previous section. Assuming the JSON file is at http://mesh.example/mesh.json, you can do this in */opt/perfsonar_ps/mesh_config/etc/agent_configuration.conf* as follows::

    <mesh>
        configuration_url   http://mesh.example/mesh.json
    </mesh>

You'll also want to make sure the following is set if you would like to use the measurement archive specified in the host class::

    configure_archives 1

You'll also want to set the follow if you are NOT use a Toolkit deployment or the perfSONAR-Complete bundle::

    use_toolkit 0
    
Finally, you'll want to make sure your */opt/perfsonar_ps/regular_testing/etc/regular_testing.conf* file only has the following lines uncommented::

    test_result_directory   /var/lib/perfsonar/regular_testing

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

In this case, how do we tag our agent downloading the file so that it matches this class? Normally we would do it in the :ref:`host <config_mesh-host>` directive but by definition our requesting agent does not have one of those. Instead we have to add a *local_host* block to the clients *agent_configuration.conf* file::

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
    

