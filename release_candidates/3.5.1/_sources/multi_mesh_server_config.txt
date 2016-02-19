***************************************
Publishing a Central Configuration File
***************************************

This page details how to create and publish a central configuration that can be consumed by multiple perfSONAR hosts to build their regular testing configuration. The steps to do so can be broken down as follows and are covered in the remainder of this document:

#. :ref:`multi_service_config-install` -  If you are building the configuration file on a perfSONAR Toolkit host you may skip this step as your host has everything it needs. Otherwise, you need to install some tools to help build the configuration files. 
#. :ref:`multi_service_config-gen` - You will need to generate a configuration file in the proper format that defines all the tests you want run. 
#. :ref:`multi_service_config-json` - The configuration file in the last step will need o be converted to JSON which is the format consumers of the file will understand
#. :ref:`multi_service_config-publish` - The JSON version of the configuration file will need to be published to a web server reachable by the perfSONAR that need to read it to generate there regular tests.

.. _multi_service_config-install:

Installing the Required Software
================================
If you are building the configuration file on a perfSONAR Toolkit host you may skip this step as your host has everything it needs. Otherwise, you will need to install the tool used to convert the configuration you build to its final format. You can install this tool via *yum*. 

.. note:: You will need to point your system at the Internet2 yum repository as detailed at their `software site <http://software.internet2.edu>`_.

You may install the package with the following commands:

**RedHat/CentOS**::

    yum install perfsonar-meshconfig-jsonbuilder

**Debian**::

    apt-get install perfsonar-meshconfig-jsonbuilder

.. _multi_service_config-gen:

Generating the Configuration
============================
You need to build a configuration file using your favorite text editor. The syntax of the file is in `Apache configuration format <http://httpd.apache.org/docs/current/configuring.html>`_. For a full list of options see :doc:`config_mesh`. It is also helpful to look at a few examples:

* See the file under `doc/example.conf <https://raw.githubusercontent.com/perfsonar/mesh-config/master/doc/example.conf>`_ that comes with the software
* `ESnet <http://www.es.net>`_ makes the mesh configuration files they use for their regular testing available `here <https://github.com/esnet/esnet-perfsonar-mesh>`_.

Let's take a quick look at a simple example::

    description Example Mesh Config

    <administrator>
      name       John Smith
      email      jsmith@acme.local
    </administrator>

    <organization>
        description 	Acme Examples, Inc
    
        <site>
            <host>
                  description Acme East
                  address east-bwctl.acme.local
                  address east-owamp.acme.local
            </host>
        </site>
    
         <site>
            <host>
                  description Acme West
                  address west-bwctl.acme.local
                  address west-owamp.acme.local
            </host>
        </site>
    </organization>

    <test_spec bwctl_test>
      type              perfsonarbuoy/bwctl  # Perform a bwctl test (i.e. achievable bandwidth)
      tool              bwctl/iperf3         # Use 'iperf' to do the bandwidh test
      protocol          tcp                  # Run a TCP bandwidth test
      interval          21600                # Run the test every 6 hours
      duration          20                   # Perform a 20 second test
      force_bidirectional 1                  # do bidirectional test
      random_start_percentage 10             # randomize start time
      omit_interval     5                    # ignore first few seconds of test 
    </test_spec>

    <test_spec owamp_test>
      type              perfsonarbuoy/owamp  # Perform a constant low-bandwidth OWAMP test
      packet_interval   0.1                  # Send 10 packets every second (i.e. pause 0.1 seconds between each packet)
      loss_threshold    10                   # Wait no more than 10 seconds for a response
      session_count     10800                # Refresh the test every half hour (once every 18000 packets)
      sample_count      600                  # Send results back every 60 seconds (once every 600 packets)
      packet_padding    0                    # The size of the packets (not including the IP/UDP headers)
      bucket_width      0.0001               # The granularity of the measurements
      force_bidirectional 1                  # do bidirectional test
    </test_spec>


    <group acme_bwctl_group>
        type       mesh
    
        member     east-bwctl.acme.local
        member     west-bwctl.acme.local
    </group>

    <group acme_owamp_group>
        type       mesh
    
        member     east-owamp.acme.local
        member     west-owamp.acme.local
    </group>

    <test>
      description       Example Throughput Testing
      group             acme_bwctl_group 
      test_spec         bwctl_test 
    </test>

    <test>
      description       Example OWAMP Testing
      group             acme_owamp_group 
      test_spec         owamp_test 
    </test>

Let's take a closer look at each section:

* The first thing we define is an **administrator** with a name and email. This is simply contact information if someone has questions about the mesh. You may define multiple administrator blocks.
* The second block is the **organization**. Here we provide the name of the organization and a list of **site** blocks. A site represents a physical location, such as if you an organization has a North American and European office. This construct is not relevant to the test and is primarily there for keeping things organized. In the example we only have one organization, *Acme Examples, Inc.* and they have two sites: *Acme East* and *Acme West*. 
* Inside each **site** block is one or more **host** blocks. This is where we define the location of perfSONAR hosts that will perform tests. A host may have one or more *addresses*. In this example each site has one host and each host has two addresses. Each address corresponds to a different interface on the host. We can specify which address we want a test to use later to allow for regular testing to select the desired interface. For more information on hosts with multiple interfaces see :doc:`manage_dual_xface`.
* The **test_spec** blocks define the parameters of our test. In this example we have two test specs: one defining BWCTL throughput test parameters and another defining OWAMP test parameters.
* The **group** blocks define different testing topologies. In this example we define two groups each with a *mesh* topology (meaning every group member tests to all other group members). In this example they each have two members, one contains both the interfaces to be used for BWCTL tests another contains both the interfaces to be used for OWAMP tests.
* Finally, the **test** blocks bring everything together by associating a *group* and *test_spec*. This means all tests will be run given the group topology using the given test specification's parameters. 

That's the basic idea and considerable variation can be seen in these files. As indicated earlier the best resource is to look at the provided examples and the :doc:`syntax guide <config_mesh>` for more details.

.. note:: This is an important file! You should create back-ups if possible or consider putting it in some type of source control repository (git, subversion, etc). Losing this file after putting effort into building a large test configuration can be very frustrating, so avoid that pitfall if you can.    

.. _multi_service_config-json:

Converting to JSON
=====================

Once you have created your configuration file, you will need to convert it to a JSON format. This format is the one understood by the perfSONAR client software reading it, but is not so easily generated by a human with a text editor (hence the conversion step). You will need to run the command :ref:`build_json <config_files-meshconfig-scripts-json>` and give it the location of the configuration file to be converted and the file to output the JSON. The example below accepts the configuration file *example.conf* as input and outputs to */var/www/html/example.json*:

    /usr/lib/perfsonar/bin/build_json -o /var/www/example.json example.conf 
    
Replace the output path with values appropriate to your setup. If it throws any errors it may be because of a syntax error so go back and review your file carefully. After the command successfully runs you should have a file to publish. 


.. _multi_service_config-publish:

Publishing
==========
Once you have a JSON file you simply need to copy it to a web server. A few other things to consider when publishing your file:

* It is recommended you configure your web server with https. The encryption aspect of https is less important here as you are not passing around sensitive information, but the server authentication aspects have real value. This will allow those reading the file to verify the identity of the server and help prevent certain types of attacks. 
* There should be no sensitive information in the generated JSON. If you are concerned about restricting access, it is recommended you use methods such as iptables or similar to restrict IPs that have access to the web server hosting the JSON file.
