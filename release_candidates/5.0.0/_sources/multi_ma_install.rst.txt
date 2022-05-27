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
The measurement archive is implemented using a software package named *perfsonar-archive*. Ypur can install as a standalone package on any perfSONAR supported operating system with the following:

  *CentOS/RedHat:*::

    yum install perfsonar-archive

  *Debian/Ubuntu:*::

     apt-get install perfsonar-archive

Authenticating Measurement Hosts
================================
Measurement hosts need to authenticate to the measurement archive when they register data. This is implemented using one of two methods:

#. A username and password that is passed in the HTTP header of all requests.
#. Using IP based authentication

The remainder of this section describes how to setup both type of accounts.

.. note:: You may have a combination of the above where some accounts authenticate based on IP address and others based on username/password.

.. _multi_ma_install-intro:

Authenticating by Username and Password
----------------------------------------

The username and password is set in OpenSearch. You can create your own but an account is enabled with the minimum set of permissions needed to write to the perfSONAR indices. You can find the details in `/etc/perfsonar/opensearch/logstash_login`.

.. _multi_ma_install-auth_ip:

Authenticating by IP Address
----------------------------

This is done in the Apache proxy for Logstash. See the examples in */etc/httpd/conf.d/apache-logstash.conf*.

Configuring Measurement Hosts
==============================
Each measurement host must be configured to register its data to the central archive. This is done by configuring the :doc:`pSConfig pScheduler Agent <psconfig_pscheduler_agent>` to use the archive. The exact approach depends largely with how you are reading your template and which tasks you want to send to the central archive.

One approach is to define the archive in the pSConfig template being used. In that case, the pSConfig template is going to need a section similar to the following::

      {
        "archiver": "http",
        "data": {
            "schema": 2,
            "_url": "http://ma.example.perfsonar.net/logstash",
            "op": "put"
        }
      }

The full set of options for the ``data`` section of an *archive* object of type *http* are detailed :ref:`here <pscheduler_ref_archivers-archivers-http>`.  The defined ``tasks`` section will need to reference the archive defined above for those tasks to be stored. See :doc:`psconfig_templates_intro` for information on how tasks and archives link together if that is not clear. 

The above example does not define how to set the authentication token for a username and password. It is possible to set the token using HTTP Basic Auth using the ``_headers`` field. Before you do that though you need to base64 encode the username and password separated by a colon. If using the default credentials then run::

    base64 /etc/perfsonar/opensearch/logstash_login 

With the output value you can generate a definition as follows::

    {
        "archiver": "http",
        "data": {
            "schema": 2,
            "_url": "http://ma.example.perfsonar.net/logstash",
            "op": "put",
            "_headers": {
                "content-type": "application/json", "Authorization":"Basic BASE64ENCODEDCREDS"
            }
        }
      }

**It is only recommended you set the** ``_headers`` **if your template is a file on the local system that will never be published to the web.** This is to protect your credentials from being exposed. See :ref:`psconfig_pscheduler_agent-templates-local` for how to setup local templates. Alternatively see :ref:`psconfig_pscheduler_agent-modify-archives` for information on how to define a default archiver locally for all tasks. Finally, if you have a remote template and would like to set the ``_auth-token`` after the agent downloads the template see :ref:`psconfig_pscheduler_agent-modify-transform_all` and :ref:`psconfig_pscheduler_agent-modify-transform_one`.
    
If you are using a remote pSConfig template that has your archive defined in it, make sure you use the ``--configure-archives`` option of ``psconfig remote add`` when you add the URL to the template. Example::

    psconfig remote add --configure-archives URL 
 
 
If the option is not included then the archive will be ignored.