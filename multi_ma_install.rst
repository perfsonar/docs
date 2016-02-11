***************************************
Deploying a Central Measurement Archive
***************************************

Measurement results from your regular tests are stored in a **measurement archive (MA)**. This leads to the definition of two categories of hosts:

#. The **measurement host** that runs regular tests such as throughput, one-way latency, ping and traceroute measurements.
#. The **archive host** that stores the results from the measurement host(s)

By default the perfSONAR Toolkit is both measurement host AND archive host. It comes installed with both the regular testing infrastructure and the measurement archive software. The measurement archive stores all the results from measurements defined in the regular testing configuration of the local host. In most cases, this is an adequate storage strategy. 

As an alternative, you may decide to separate your measurement hosts and archive host(s). This allows a single "centralized" archive host to store results from multiple measurement hosts. A few use cases where this may be desirable are as follows:

* Your measurement hosts are on less powerful (and likely lower cost) hardware that you don't want having the overhead of running the measurement archive. The measurement archive has higher hardware requirements than the measurement tools, so removing it can result in considerable resource savings.
* Your site has the experience and the infrastructure to manage large databases that you would like to leverage for storing measurment results on a dedicated archive host.
* You want to store results in multiple places. For example, you may store your results locally but also store them in a central archive where complex analysis tools operate on all the data from multiple hosts in one location.

Those are just a few examples. If you think a central measurement archive is right for your measurement strategy, then read the remainder of this document for instructions on how to configure both your archive host and measurement hosts.

Installing the Measurement Archive Software
============================================
The measurement archive is implemented using a software package named `esmond <http://software.es.net/esmond/>`_. If your central archive is a perfSONAR Toolkit, then esmond is already installed. It is more likely though that you will install your measurement archive on an instance completely separate from the perfSONAR Toolkit. There are a few options for installing esmond:

#. RedHat Linux (including CentOS) users may install a standalone instance of esmond using an RPM. See the `RPM installation page <http://software.es.net/esmond/rpm_install.html>`_ for details on installing a standalone RPM. 
#. You may install esmond as part of the perfSONAR CentralManagement bundle. See :doc:`install_options` for more information.
#. You may consult the `esmond web site <http://software.es.net/esmond/>`_ for more guidance on various other deployment options. 


Authenticating Measurement Hosts
================================
Measurement hosts need to authenticate to the measurement archive when they register data. This is implemented in esmond using one of two methods:

#. A username and API key that is passed in the HTTP header of all requests.
#. Using IP based authentication

The remainder of this section describes how to setup both type of accounts.

.. note:: You may have a combination of the above where some accounts authenticate based on IP address and others based on API key.  If a request matches both an API key account and an IP address account, then the API account will be tried first. If the API key authentication fails, then it will fallback to the IP address account. 

.. warning:: It is **highly recommended** you run your measurement archive server with HTTPS. This encrypts transfers and protects the username and API key (if applicable) from being exposed in plain text since it is just in the HTTP header. See the Apache HTTPD documentation for information on how to configure HTTPS.

Authenticating by Username and API Key
--------------------------------------

As an archive administrator you may create a username, generate an API key, and assign the needed permissions to register data with the commands below:

#. Change to the esmond install directory::

    cd /usr/lib/esmond
#. **RedHat/CentOS users only**: The esmond commands require Python 2.7, which is installed when installing esmond. Unfortunately, the operating system default Python in only version 2.6. Using a **bash** shell, you can enable Python 2.7 for your current shell with the following commands::

    source /opt/rh/python27/enable
    /opt/rh/python27/root/usr/bin/virtualenv --prompt="(esmond)" .
    . bin/activate
#. Run the commands below replacing *example_user* with the username of the account you would like to create::

    python esmond/manage.py add_ps_metadata_post_user example_user
    python esmond/manage.py add_timeseries_post_user example_user
#. After running the commands above you should see the generated API key in the output (if not, re-run the commands above and they will re-show you the generated API key without affecting the user you just created). An example of the output line showing the API key (*9130962c6b38722c0b9968e6903e1927e94e16fd* in this example) is below::

    Key: 9130962c6b38722c0b9968e6903e1927e94e16fd for example_user
    
At this point provide the administrator of the measurement host wishing to register data with the username and API key. 

.. note:: There is no technical limitation preventing multiple measurement hosts from sharing a username and API key. It is up to you as an archive administrator to make a decision about whether you will share accounts between multiple measurement hosts or require unique accounts for each. It is the responsibility of both you and the measurement host administrator to follow best commons security practices and common sense in preventing unwanted parties from obtaining these credentials.

.. _multi_ma_install-auth_ip:

Authenticating by IP Address
----------------------------

As an archive administrator you may create an account that authenticates based on IP address. You may specify an IP mask so that multiple addresses may authenticate. This can be particularly useful in large deployments of measurement hosts in a small set of subnets as it does not require a username and password (API key) to be defined for each host in their regular testing file. As such, automated configuration is made easier by this authentication method. The commands for adding an account that authenticates based on IP are as follows: 

#. Change to the esmond install directory::

    cd /usr/lib/esmond
#. **RedHat/CentOS users only**: The esmond commands require Python 2.7, which is installed when installing esmond. Unfortunately, the operating system default Python in only version 2.6. Using a **bash** shell, you can enable Python 2.7 for your current shell with the following commands::

    source /opt/rh/python27/enable
    /opt/rh/python27/root/usr/bin/virtualenv --prompt="(esmond)" .
    . bin/activate
#. Run the commands below to create the account. You must provide a username as the first argument. This is simply used internally to identify the set of permissions associated with the IP addresses. After that may be one or more IP addresses in the form of *X.X.X.X* or *X.X.X.X/Y* where *X* is each octet and *Y* is the subnet. If Y is not specified it defaults to 32 (i.e. only the exact IP address provided matches). The example below will allow the host 10.0.1.1 or any host in the 10.0.2.0/24 subnet to register data to esmond::

    python esmond/manage.py add_user_ip_address example_user 10.0.1.1 10.0.2.0/24

Configuring Measurement Hosts
==============================
Each measurement host must be configured to register its data to the central archive. You do this by adding a ``measurement_archive`` block to the :ref:`regular testing configuration file <config_files-regtesting-conf-main>` for each type of data to be registered in the central measurement archive. Valid test types are:

* esmond/latency
* esmond/throughput
* esmond/traceroute

If you want all of the test types registered in the central archive then you will need to add three separate ``measurement_archive`` blocks. Each block has the following values related to the central archive:

#. **database** - This is the URL of your archive. Example: https://acme.local/esmond/perfsonar/archive/
#. **username** - The username used to authenticate to the archive. This can be excluded if you plan to authenticate based on IP. Example: example_user
#. **password** - The API key used to authenticate to the archive.  This can be excluded if you plan to authenticate based on IP. Example: 9130962c6b38722c0b9968e6903e1927e94e16fd
#. **ca_certificate_path** - For https, this is the path to a directory where CA certificates are kept that can be used to verify the presented SSL certificate from the server running the archive. Example: /etc/ssl/certs

In addition, a ``measurement_archive`` block contains a number of ``summary`` blocks used to determine how data is summarized. In general, you should copy the summary information in the examples later in this section to ensure graphs and other tools work properly. If you would like to know more about these and other blocks see :doc:`config_regular_testing`.

Given all the information above, lets look at an example where we want to register all types of data to a measurement archive running at *https://acme.local/esmond/perfsonar/archive/*. The username and API key assigned to us by the archive administrator are *example_user* and *9130962c6b38722c0b9968e6903e1927e94e16fd* respectively. Also, since the server uses https we have installed the CA certificate in */etc/ssl/certs*. Applying these details yields the following configuration::

    <measurement_archive>
        type                esmond/latency
        username            example_user
        database            https://acme.local/esmond/perfsonar/archive/
        password            9130962c6b38722c0b9968e6903e1927e94e16fd
        ca_certificate_path /etc/ssl/certs
        
        <summary>
            summary_window   300
            event_type   packet-loss-rate
            summary_type   aggregation
        </summary>
        <summary>
            summary_window   300
            event_type   histogram-owdelay
            summary_type   aggregation
        </summary>
        <summary>
            summary_window   300
            event_type   histogram-owdelay
            summary_type   statistics
        </summary>
        <summary>
            summary_window   3600
            event_type   packet-loss-rate
            summary_type   aggregation
        </summary>
        <summary>
            summary_window   3600
            event_type   packet-loss-rate-bidir
            summary_type   aggregation
        </summary>
        <summary>
            summary_window   3600
            event_type   histogram-owdelay
            summary_type   aggregation
        </summary>
        <summary>
            summary_window   3600
            event_type   histogram-rtt
            summary_type   aggregation
        </summary>
        <summary>
            summary_window   3600
            event_type   histogram-owdelay
            summary_type   statistics
        </summary>
        <summary>
            summary_window   3600
            event_type   histogram-rtt
            summary_type   statistics
        </summary>
        <summary>
            summary_window   86400
            event_type   packet-loss-rate
            summary_type   aggregation
        </summary>
        <summary>
            summary_window   86400
            event_type   packet-loss-rate-bidir
            summary_type   aggregation
        </summary>
        <summary>
            summary_window   86400
            event_type   histogram-owdelay
            summary_type   aggregation
        </summary>
        <summary>
            summary_window   86400
            event_type   histogram-owdelay
            summary_type   statistics
        </summary>
        <summary>
            summary_window   86400
            event_type   histogram-rtt
            summary_type   aggregation
        </summary>
        <summary>
            summary_window   86400
            event_type   histogram-rtt
            summary_type   statistics
        </summary>
    </measurement_archive>
    <measurement_archive>
        type                esmond/throughput
        database            https://acme.local/esmond/perfsonar/archive/
        username            example_user
        password            9130962c6b38722c0b9968e6903e1927e94e16fd
        ca_certificate_path /etc/ssl/certs
        
        <summary>
            summary_window   86400
            event_type   throughput
            summary_type   average
        </summary>
    </measurement_archive>
    <measurement_archive>
        type                esmond/traceroute
        database            https://acme.local/esmond/perfsonar/archive/
        username            example_user
        password            9130962c6b38722c0b9968e6903e1927e94e16fd
        ca_certificate_path /etc/ssl/certs
    </measurement_archive>

After adding the above to you configuration you will need to restart your regular testing:

    /etc/init.d/perfsonar-regulartesting restart

.. note:: If you central measurement archive goes down for any reason, the regular_testing daemon will queue results on the local disk under the :ref:`test results directory <config_regular_testing-test_result_directory>` as specified in your :ref:`regulartesting.conf <config_files-regtesting-conf-main>` file. It will try to register any results on disk when your measurement archive returns. Since accumulating too many files can cause trouble for disk space and/or the regular_testing daemon's ability to keep up with registering data, these files are cleaned nightly on toolkit installations. 

Registering to Multiple Measurement Archives
--------------------------------------------
You may register to multiple measurement archives by adding multiple ``measurement_archive`` blocks to the :ref:`regular testing configuration file <config_files-regtesting-conf-main>` of the same type. For example, to register traceroute data to both a local and remote archive you may have a configuration like the following::

    <measurement_archive>
        type                esmond/traceroute
        database            https://acme.local/esmond/perfsonar/archive/
        username            example_user
        password            9130962c6b38722c0b9968e6903e1927e94e16fd
        ca_certificate_path /etc/ssl/certs
    </measurement_archive>
     <measurement_archive>
        type                esmond/traceroute
        database            http://localhost/esmond/perfsonar/archive/
        username            perfsonar
        password            5bd139bdb77a85cfe65847e44556a2883a857942
    </measurement_archive>

.. note:: If one or more of your measurement archives goes down, data will continue to be registered to the running archive(s). Data for the down archives will be queued on disk and it will attempt to re-register the data when it returns (as described in the note at the bottom of the previous section). 
