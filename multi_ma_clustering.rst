********************************
Clustering a Measurement Archive
********************************

The perfSONAR Measurement Archive software `esmond <http://software.es.net/esmond>`_ is built-on a number of technologies that allow you to run the service across a collection of servers. A collection of servers configured in such a manner is often referred to as a *cluster*. In general, the primary motivation behind running the measurement archive on a cluster is for one or more of the reasons below:

#. *High availability* - If you are running your archive on one server and a component of the software goes down, such as a database, your archive will not be able to service any requests. Clustering can be used to configure things like data replication across servers and failovers to another dataset if a host goes down. 
#. *Load balancing* - If your measurement archive is servicing a large number of requests, you may want to create a cluster so multiple servers can share the load. There are number of strategies for doing this such as round-robing requests or splitting read and write operations.

The esmond software is built on three primary components all capable of being configured in a cluster. The components are

#. `Cassandra <https://cassandra.apache.org>`_ - This is the database that stores the results of a measurement. Cassandra was designed with *horizontal scaling* in mind and as such provides a number of options for data replication, failovers, load balancing and adding/removing/replacing nodes over time. See :ref:`multi_ma_clustering-cassandra` for more details.
#. `PostgreSQL <http://www.postgresql.org>`_ - This is the database that stores measurement metadata (description about the tests run such as the type of test and the parameters used). It natively supports a number of data replication options and tools exist to support failovers and load balancing. See :ref:`multi_ma_clustering-postgresql`
#. `Apache httpd <http://www.postgresql.org>`_ - Esmond runs on the Apache HTTPD web server. Apache has a number of options for handling failovers and load balancing that are detailed in :ref:`multi_ma_clustering-httpd`.

You may cluster some or all of the components if you so choose. For example, you could have a cassandra cluster but run PostgreSQL and Apache on a single server. It should also be noted that all of these components have been around for a number of years and the documentation that exists on clustering them is extensive. This document will do its best to identify key features and common configurations but is by no means an exhaustive list. It is highly recommended you consult each components documentation before embarking on an attempt to create a clustered configuration. 

.. _multi_ma_clustering-cassandra:

Clustering Cassandra
====================

Basics of Cassandra Clustering
-------------------------------
Cassandra is the component that holds all of the measurement results. Cassandra was designed with running on multiple nodes in mind, and is probably more commonly run on multiple nodes than a single node. The ability to implement high availability and load balancing do not require any additional software. The distribution of your data, how many copies exist and the number of nodes that can go down without causing an interruption are primarily determined by the following two variables:

#. The number of nodes in your cluster
#. The replication_factor of your dataset

There are of course other factors, but these are fundamental to getting a basic cluster working. The replication_factor is the total number of complete copies of the data that live in the cluster. For example, let's say we have two nodes and the replication_factor is 1. In this case there is 1 copy of data distributed between the two nodes. Cassandra organizes itself in a token ring, and evenly distributes data amongst each host. In this case that means each node has roughly 50% of the data at a given time. That also means, if one of the nodes goes down, we lose half our data and cassandra cannot run. 

As another example, let's say we still have two nodes but the replication factor is increased to 2. This means that our cluster will keep 2 copies of the data distributed evenly among the nodes. Each node has 100% of the data, so 1 node may go down and our archive can still access the complete set of data.  The main takeaway from this example is that **increasing the replication factor has increased the number of nodes we can tolerate as down**.

As a final example, let's say we keep the replication_factor fixed at 2 but increase to 10 nodes. How many nodes can go down without affecting the cluster? The answer is still only 1. The reason is that adding more nodes further distributes the data amongst the host, with each having roughly 20% of the data (2 replicas divided by 10 hosts = 20% each) but does not increase the number of copies. Thus if we lose 2 nodes, we have no way guaranteeing they didn't overlap in the data they contained. In general, you can only support (replication_factor - 1) hosts going down regadless the number of nodes. In other words, **increasing the number of nodes increases data distribution, but does not increase fault tolerance unless there is a corresponding increase in the replication_factor**.

Those are the basic ideas but there are lots more details published if you are interested. For more information on how Cassandra distributes data see the `Datastax Cassandra Documentation <http://docs.datastax.com/en/cassandra/2.0/cassandra/architecture/architectureDataDistributeAbout_c.html>`_.

Initializing the Cluster
------------------------
Assuming you have read about clustering cassandra, decided it is the best course and identified an initial set of nodes to use in your cluster, you are ready to start configuring your cluster. It is highly recommended you read the `Datastax Cluster Initialization <http://docs.datastax.com/en/cassandra/2.0/cassandra/initialize/initializeTOC.html>`_ page for specifics on how build your cluster. We will go through a simple two node example in this document to give a general idea of the process, but for more information it is highly recommended you see the official documentation.

Now, Let's assume we have a two node cluster we wish to initialize. Our nodes have IP addresses 10.0.1.35 and 10.0.1.36 respectively. The steps to configure these into a cluster are as follows:

#. `Install cassandra <http://docs.datastax.com/en/cassandra/2.0/cassandra/install/install_cassandraTOC.html>`_ on each node
#. On each node you will need to open the following firewall ports:
    * **TCP ports 7000 and 7001** are needed for internode communication. These are only used between cassandra servers so you only need to allow the other hosts in the cluster to connect to these ports. 
    * **TCP port 9160** is needed so esmond can communicate with the cassandra servers. You may firewall this port so only the host(s) with the esmond package installed may reach this port.
    * You will also want **TCP port 7199** open **FOR LOCALHOST ONLY** so that you may run the ``nodetool`` command to get the status of and perform various administrator tasks on the cluster.
    
    .. seealso:: See the `Datastax Firewall Documentation <http://docs.datastax.com/en/cassandra/2.0/cassandra/security/secureFireWall_r.html>`_ for more details.
#. Next we need to name our cluster. In this example we will name it "Esmond Cluster". On each node open */etc/cassandra/conf/cassandra.yaml* and change ``cluster_name`` to this value::

    cluster_name: 'Esmond Cluster'
#. Next we need to choose a seed node. This node is only used the first time a node comes up to bootstrap itself into the ring. If it goes down it will not affect the nodes that have already been bootstrapped, however you will not be able to add new nodes to a cluster. If you are frequently adding new nodes, you may want to specify multiple seed nodes to prevent this. For our simple two node cluster, one seed node will suffice so we'll choose 10.0.1.35. We set this on both hosts in */etc/cassandra/conf/cassandra.yaml* under the seed_provider property as shown below::

    seed_provider:
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
      parameters:
          - seeds: "10.0.1.35"
#. The final */etc/cassandra/conf/cassandra.yaml* properties we must set is the _listen_address_ and _rpc_address_. The _listen_address_ tells cassandra the interface on which to listen for communication from other cassandra nodes. The _rpc_address_ tells it on which interface it can accept connections from esmond. In our example, each host only has one interface, so the first node will set both of these to 10.0.1.35 and the second node will set them to 10.0.1.36.
    
#. Clear any data on both nodes you may have from old configurations or cassandra inadvertently starting, etc. Note that this does NOT clear out any existing perfSONAR data.::
    
    rm -rf /var/lib/cassandra/data/system/*
#. Restart cassandra on each node::
    
    /sbin/service cassandra restart
    
#. Our two node cluster should be running. We can verify this with the ``nodetool status`` command on either host::

    # nodetool status
    Note: Ownership information does not include topology; for complete information, specify a keyspace
    Datacenter: datacenter1
    =======================
    Status=Up/Down
    |/ State=Normal/Leaving/Joining/Moving
    --  Address    Load       Tokens  Owns   Host ID                               Rack
    UN  10.0.1.35  5.91 MB    256     51.0%  ccdab562-b2a2-459e-9a14-6b9758a827fd  rack1
    UN  10.0.1.36  3.07 MB    256     49.0%  7a2be11f-02c5-4997-926a-817960c71e18  rack1
    

Configuring Esmond to use the Cluster
-------------------------------------
Once the cluster has been initialized, we must configure esmond to use the cluster. This requires setting *cassandra_servers* in */opt/esmond/esmond.conf* to the list of nodes in our cluster::

    cassandra_servers = 10.0.1.35:9160,10.0.1.36:9160

We list all of the nodes because any of them can coordinate the request. Esmond will randomly contact one of the nodes and (assuming we set our replication factor high enough relative to the number of down nodes) will fallback to another node if it tries to contact one that is unreachable.

You may also want to set *cassandra_replicas* to the replication_factor on which you decided. If left unset the default value will be 1. An example::

    cassandra_replicas = 1

Changing the replication_factor
-------------------------------
 You may want to change he replication_factor as you add more nodes, requirements change or if you started esmond before deciding on the value. If you would like to change this do the following:

#. On your esmond node(s), open */opt/esmond/esmond.conf* ant set the property *cassandra_replicas* to the new value: For example::

    cassandra_replicas = 2
#. On any **single** cassandra node run the following (replacing *10.0.1.35* with your host and *2* with the replication factor you desire)::

    cqlsh 10.0.1.35 -e "ALTER KEYSPACE esmond WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 2 };"
#. On **every** cassandra node, run ``nodetool repair``. Do not run in parallel, wait for the command to complete before moving on to the next node. Note that running this command may take awhile depending on the amount of data.

.. _multi_ma_clustering-postgresql:

Clustering PostgresSQL
======================

.. _multi_ma_clustering-httpd:

Clustering Apache httpd
=======================
