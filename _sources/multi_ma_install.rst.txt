***************************************
Deploying a Central Measurement Archive
***************************************

Measurement results from your regular tests are stored in a **measurement archive (MA)**. This leads to the definition of two categories of hosts:

#. The **measurement host** that runs regular tests such as throughput, one-way latency, ping and traceroute measurements.
#. The **archive host** that stores the results from the measurement host(s)

By default the perfSONAR Toolkit is both measurement host AND archive host. It comes installed with both the regular testing infrastructure and the measurement archive software. The measurement archive stores all the results from measurements defined in the regular testing configuration of the local host. In most cases, this is an adequate storage strategy. 

As an alternative, you may decide to separate your measurement hosts and archive host(s). This allows a single "centralized" archive host to store results from multiple measurement hosts. A few use cases where this may be desirable are as follows:

* Your measurement hosts are on less powerful (and likely lower cost) hardware that you don't want having the overhead of running the measurement archive. The measurement archive has higher hardware requirements than the measurement tools, so removing it can result in considerable resource savings.
* Your site has the experience and the infrastructure to manage large databases that you would like to leverage for storing measurement results on a dedicated archive host.
* You want to store results in multiple places. For example, you may store your results locally but also store them in a central archive where complex analysis tools operate on all the data from multiple hosts in one location.

Those are just a few examples. If you think a central measurement archive is right for your measurement strategy, then read the remainder of this document for instructions on how to configure both your archive host and measurement hosts.

Installing the Measurement Archive Software
============================================
The measurement archive is implemented using a software package named *esmond*. The following installation options are available for installing esmond:

#. As part of the perfSONAR *core*, *toolkit* or *centralmanagement* bundles. See :doc:`install_options` for more information.
#. As a standalone package on any perfSONAR supported operating system (e.g. ``yum install esmond``, ``apt-get install esmond``)

Authenticating Measurement Hosts
================================
Measurement hosts need to authenticate to the measurement archive when they register data. This is implemented in esmond using one of two methods:

#. An API key that is passed in the HTTP header of all requests.
#. Using IP based authentication

The remainder of this section describes how to setup both type of accounts.

.. note:: You may have a combination of the above where some accounts authenticate based on IP address and others based on API key.  If a request matches both an API key account and an IP address account, then the API account will be tried first. If the API key authentication fails, then it will fallback to the IP address account. 

.. warning:: It is **highly recommended** you run your measurement archive server with HTTPS. This encrypts transfers and protects the API key (if applicable) from being exposed in plain text since it is just in the HTTP header. See the Apache HTTPD documentation for information on how to configure HTTPS.


.. _multi_ma_install-intro:

Authenticating by API Key
--------------------------------------

As an archive administrator you may create a username, generate an API key, and assign the needed permissions to register data with the commands below:

#. As priviledged user run the commands below replacing *example_user* with the username of the account you would like to create::

    /usr/sbin/esmond_manage add_ps_metadata_post_user example_user
    /usr/sbin/esmond_manage add_timeseries_post_user example_user

#. After running the commands above you should see the generated API key in the output (if not, re-run the commands above and they will re-show you the generated API key without affecting the user you just created). An example of the output line showing the API key (*9130962c6b38722c0b9968e6903e1927e94e16fd* in this example) is below::

    Key: 9130962c6b38722c0b9968e6903e1927e94e16fd for example_user
      
At this point provide the administrator of the measurement host wishing to register datagenerated API key. 

.. note:: There is no technical limitation preventing multiple measurement hosts from sharing an API key. It is up to you as an archive administrator to make a decision about whether you will share accounts between multiple measurement hosts or require unique accounts for each. It is the responsibility of both you and the measurement host administrator to follow best commons security practices and common sense in preventing unwanted parties from obtaining these credentials.

.. _multi_ma_install-auth_ip:

Authenticating by IP Address
----------------------------

As an archive administrator you may create an account that authenticates based on IP address. You may specify an IP mask so that multiple addresses may authenticate. This can be particularly useful in large deployments of measurement hosts in a small set of subnets as it does not require a password (API key) to be defined for each host in their tasks file. As such, automated configuration is made easier by this authentication method. The commands for adding an account that authenticates based on IP are as follows: 

#. As priviledged user run the commands below to create the account. You must provide a username (replacing *example_user*) as the first argument. This is simply used internally to identify the set of permissions associated with the IP addresses. After that may be one or more IP addresses in the form of *X.X.X.X* or *X.X.X.X/Y* where *X* is each octet and *Y* is the subnet. If Y is not specified it defaults to 32 (i.e. only the exact IP address provided matches). The example below will allow the host *10.0.1.1* or any host in the *10.0.2.0/24* subnet to register data to esmond::

    /usr/sbin/esmond_manage add_user_ip_address example_user 10.0.1.1 10.0.2.0/24

Configuring Measurement Hosts
==============================
Each measurement host must be configured to register its data to the central archive. This is done by configuring the :doc:`pSConfig pScheduler Agent <psconfig_pscheduler_agent>` to use the archive. The exact approach depends largely with how you are reading your template and which tasks you want to send to the central archive.

One approach is to define the archive in the pSConfig template being used. In that case, the pSConfig template is going to need a section similar to the following::

    "archives": {
        "example_esmond_archive": {
            "archiver": "esmond",
            "data": {
                "measurement-agent": "{% scheduled_by_address %}",
                "url": "https://ma.example.perfsonar.net/esmond/perfsonar/archive/"
        }
    }

.. note:: It is highly recommended you set the ``measurement-agent`` field to the template variable ``{% scheduled_by_address %}`` for esmond archives as it ensures the requester of the measurement is properly recorded. See :ref:`psconfig_templates_vars-scheduled_by_address` for more details on this variable.

The full set of options for the ``data`` section of an *archive* object of type *esmond* are detailed :ref:`here <pscheduler_ref_archivers-archivers-esmond>`.  The defined ``tasks`` section will need to reference the archive defined above for those tasks to be stored. See :doc:`psconfig_templates_intro` for information on how tasks and archives link together if that is not clear. 

The above example does not define an API key for authentication. It is possible to set the API key using the ``_auth_token`` field. For example::

    "archives": {
        "example_esmond_archive_with_key": {
            "archiver": "esmond",
            "data": {
                "measurement-agent": "{% scheduled_by_address %}",
                "url": "https://ma.example.perfsonar.net/esmond/perfsonar/archive/",
                "_auth-token": "35dfc21ebf95a6deadbeef83f1e052fbadcafe57"
        }
    }

**It is only recommended you set the** ``_auth-token`` **if your template is a file on the local system that will never be published to the web.** This is to protect your API key from being exposed. See :ref:`psconfig_pscheduler_agent-templates-local` for how to setup local templates. Alternatively see :ref:`psconfig_pscheduler_agent-modify-archives` for information on how to define a default archiver locally for all tasks. Finally, if you have a remote template and would like to set the ``_auth-token`` after the agent downloads the template see :ref:`psconfig_pscheduler_agent-modify-transform_all` and :ref:`psconfig_pscheduler_agent-modify-transform_one`.
    
If you are using a remote pSConfig template that has your archive defined in it, make sure you use the ``--configure-archives`` option of ``psconfig remote add`` when you add the URL to the template. Example::

    psconfig remote add --configure-archives URL 
 
 
If the option is not included then the archive will be ignored.