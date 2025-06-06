***************************************
Deploying a Central Measurement Archive
***************************************

Measurement results from your regular tests are stored in a **measurement archive (MA)**. This leads to the definition of two categories of hosts:

#. The **measurement host** that runs regular tests such as throughput, one-way latency, ping and traceroute measurements.
#. The **archive host** that stores the results from the measurement host(s)

By default the perfSONAR Toolkit is both measurement host AND archive host. It comes installed with both the regular testing infrastructure and the measurement archive software. The measurement archive stores all the results from measurements defined in the regular testing configuration of the local host. In many cases, this is an adequate storage strategy. 

As an alternative, you may decide to separate your measurement hosts and archive host(s). This allows a single "centralized" archive host to store results from multiple measurement hosts. A few use cases where this may be desirable are as follows:

* Your measurement hosts are on less powerful (and likely lower cost) hardware that you don't want having the overhead of running the measurement archive. The measurement archive has higher hardware requirements than the measurement tools, so removing it can result in considerable resource savings.
* Your site has the experience and the infrastructure to manage large databases that you would like to leverage for storing measurement results on a dedicated archive host.
* You want to store results in multiple places. For example, you may store your results locally but also store them in a central archive where analysis tools operate on all the data from multiple hosts in one location.

Those are just a few examples. If you think a central measurement archive is right for your measurement strategy, then read the remainder of this document for instructions on how to configure both your archive host and measurement hosts.

Installing the Measurement Archive Software
============================================
The measurement archive is implemented using a software package named *perfsonar-archive*. But you can run the personar install script to setup the package repositories and install the perfSONAR archive in one go. The command will automatically detect the operating system and install the correct packages::

    curl -s https://downloads.perfsonar.net/install | sh -s - archive

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
Each measurement host must be configured to register its data to the central archive. This is done by configuring the :doc:`pSConfig pScheduler Agent <psconfig_pscheduler_agent>` to use the archive. Specifically, it configures the HTTP archiver plugin supported by pScheduler. The full set of options for the HTTP archiver plugin are detailed :ref:`here <pscheduler_ref_archivers-archivers-http>`. The exact approach depends largely on how you are reading your pSConfig template and which tasks you want to send to the central archive. 

Some common scenarios are listed below:

Scenario 1: Writing to a Local Archive
-----------------------------------------------------------------------
Note that by default, a perfSONAR Toolkit writes all tests to a local archive so no additional steps are needed. The archive definition can be found in `/etc/perfsonar/psconfig/archives.d/http_logstash.json`. If you need to regenerate that configuration, you can run the following command::

    /usr/lib/perfsonar/archive/perfsonar-scripts/psconfig_archive.sh

The output of the command will look similar to the following::

    {
        "archiver": "http",
        "data": {
            "schema": 2,
            "_url": "https://{% scheduled_by_address %}/logstash",
            "op": "put",
            "_headers": {
                "x-ps-observer": "{% scheduled_by_address %}",
                "content-type": "application/json", 
                "Authorization":"Basic eXamPleTokEn"
            }
        }
    }

Copy the above output to `/etc/perfsonar/psconfig/archives.d/http_logstash.json` and all pSConfig tests will write to the local archive.

Scenario 2: Writing to a Remote Archive with Username and Password Authentication
--------------------------------------------------------------------------------------------

As an example, let's say we want all our measurement hosts to write results to an archive with the hostname `example.archive`. We can generate a configuration with the following command where the hostname is given as a parameter to the script::

    /usr/lib/perfsonar/archive/perfsonar-scripts/psconfig_archive.sh -n example.archive

The output looks as follows::

    {
        "archiver": "http",
        "data": {
            "schema": 3,
            "_url": "https://example.archive/logstash",
            "verify-ssl": false,
            "op": "put",
            "_headers": {
                "x-ps-observer": "{% scheduled_by_address %}",
                "content-type": "application/json", 
                "Authorization":"Basic eXamPleTokEn"
            }
        },
        "_meta": {
            "esmond_url": "https://example.archive/esmond/perfsonar/archive/"
        }
    }

Note some differences include the URL pointing at the provided host, SSL verification is disabled by default (assumes a self-signed certificate), and an `esmond_url` is generated which can be used by legacy tools to grab data using the legacy Esmond interface. Note this `esmond_url` will never be used by measurement clients to write results, it is only for querying using the backward compatibility interface. 

The simplest method for using the above output is to add it to a new JSON file in the `/etc/perfsonar/psconfig/archives.d/` directory.  See :ref:`psconfig_pscheduler_agent-templates-local` for more information on how to setup local templates.

**It is only recommended you set the** ``Authorization`` **field if your template is a file on the local system that will never be published to the web.** This is to protect your credentials from being exposed. If you would like to use username and password authentication while still publishing to a public pSConfig template, you can remove the Authorization field from the definition published either by hand or re-running the above command with `/usr/lib/perfsonar/archive/perfsonar-scripts/psconfig_archive.sh -a none -n example.archive`. You can then add it back locally using a transform script. See  :ref:`psconfig_pscheduler_agent-modify-transform_all` and :ref:`psconfig_pscheduler_agent-modify-transform_one` for examples of how to do this.

Scenario 3: Writing to a Remote Archive with IP Authentication
---------------------------------------------------------------------------

In this scenario you have configured a list of allowed IPs in */etc/httpd/conf.d/apache-logstash.conf*. You can safely publish to the web without authentication info. Generate the archiver configuration with the following command::

    /usr/lib/perfsonar/archive/perfsonar-scripts/psconfig_archive.sh -a none -n example.archive

The output should look something like the following::

    {
        "archiver": "http",
        "data": {
            "schema": 3,
            "_url": "https://example.archive/logstash",
            "verify-ssl": false,
            "op": "put",
            "_headers": {
                "x-ps-observer": "{% scheduled_by_address %}",
                "content-type": "application/json"
            }
        },
        "_meta": {
            "esmond_url": "https://example.archive/esmond/perfsonar/archive/"
        }
    }

Copy above to your central pSConfig template and your measurement hosts should begin archiving.
