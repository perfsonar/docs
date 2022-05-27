**********************
Archiver Reference
**********************

.. _pscheduler_ref_archivers-intro:

Introduction
============================================

pScheduler's architecture features the concept of :term:`archivers <archiver>`, which send completed measurement results elsewhere for storage or processing.  Archivers are plugins, which means the set of destinations available for use with pScheduler can be easily expanded.

Archiving in pScheduler is reliable.  After each attempt to dispose of the result, the archiver plugin will tell pScheduler whether it succeeded and, if not, whether or not to try again and how long to wait before the next attempt.

.. _pscheduler_ref_archivers-syntax:

Basic JSON Syntax
============================================

Archiving is accomplished by providing an *archive specification* in the form of a JSON object containing these values:

``archiver`` - The name of the archiver to use. See :ref:`pscheduler_ref_archivers-archivers` for a list available in the base pScheduler distribution.

``data`` - A JSON object containing archiver-specific data to be used in deciding how to dispose of the result.

``runs`` (Requires schema 2) - Which runs should be archived.  Valid values are ``succeeded`` for runs that produced a result, ``failed`` for those that did not and ``all`` for both.  This value is optional and will be treated as ``succeeded`` if not provided.

``ttl`` - The absolute amount of time after which the result should be discarded if not successfully archived, specified as an `ISO8601 duration <https://en.wikipedia.org/wiki/ISO_8601#Durations>`_.  This value is optional and will be treated as infinite if not provided.

``uri-host`` (Requeres schema 2) - Host name and optional port to be used in URIs for the task and run provided to the archiver.  This value is optional and will default to the system's best estimate of its own fully-qualified domain name.

For example (commentary is not part of the specification)::

    {
        "schema": 2,                  Second schema, required for 'runs'
        "archiver": "bitbucket",      Send to the archiver that goes nowhere.
        "data": { },                  The "bitbucket" archiver takes no specific data.
        "runs": "all",                Archive all runs.
        "ttl": "PT12H"                Give up after 12 hours if not successfully archived.
    }

.. _pscheduler_ref_archivers-cli:

Archiving from the Command Line
============================================

pScheduler can be directed to send measurement results to an archiver by using the ``--archive`` switch followed by an archive specification.  

.. _pscheduler_ref_archivers-cli-spec:

Specifying Archivers
-------------------------------------------

.. _pscheduler_ref_archivers-cli-spec-string:

Directly, as a String Literal
++++++++++++++++++++++++++++++++++++++++++++++

The archive specification may be added directly to the command line as a string literal containing its JSON::

    % pscheduler task --archive '{ "archiver": "bitbucket", "data": {} }' trace --dest www.perfsonar.net

.. _pscheduler_ref_archivers-cli-spec-flie:

Indirectly, From a File
++++++++++++++++++++++++++++++++++++++++++++++

If the argument given to the ``--archive`` switch begins with ``@``, the remainder of the argument will be treated as the path to a JSON file containing an archive specification which will be opened, read and treated as if it had been typed in by hand.  If the first character of the path is a tilde (``~``), it will be expanded to the user's home directory.  For example::

    % cat /home/fred/archive-to-bitbucket.json
    {
        "archiver": "bitbucket",
        "data": {}
    }

    % pscheduler task --archive @/home/fred/archive-to-bitbucket.json trace --dest www.perfsonar.net

.. _pscheduler_ref_archivers-cli-multi:

Multiple Archivers
-------------------------------------------

The results of a task can be sent to multiple archivers by using the ``--archive`` switch multiple times::

    % pscheduler task \
          --archive @/home/fred/archive-to-esmond.json \
          --archive '{ "archiver": "bitbucket", "data": {} }' \
          trace --dest www.perfsonar.net

Other than system-imposed limits on the length of the command line, there is no limit on the number of archivers that may be specified as part of a task.

.. _pscheduler_ref_archivers-cli-json:

Archiving as Part of a JSON Task Specification
------------------------------------------------

Archive specifications can be added to a JSON task specification as an array of JSON objects as part of the ``archives`` property::

    % cat mytask.json
    {   
        "schema": 1,
        "test": {
            "type": "trace",
            "spec": {
                "schema": 1,
                "dest": "www.perfsonar.net"
            }
        },
        "schedule": {
            "slip": "PT5M"
        },
        "archives": [
            {   
                "archiver": "bitbucket",
                "data": { }
            },
            {   
                "archiver": "syslog",
                "data": { "ident": "just-testing" }
            }

        ]
    }

    % pscheduler task --import mytask.json .

.. note:: The ``.`` in the command above is a placeholder for the test type, which is imported from ``mytask.json``.)

.. _pscheduler_ref_archivers-psconfig:

Archiving in pSConfig Templates
============================================

:doc:`pSConfig <psconfig_intro>` allows for the use of *archive* objects in the ``archives`` section of pSConfig templates. They take the exact same format as described in this document. For more information on pSConfig templates see :doc:`psconfig_templates_intro`

.. _pscheduler_ref_archivers-global:

Archiving Globally
============================================

pScheduler can be configured to apply an archive specification to every run it performs on a host by placing each one in a file in ``/etc/pscheduler/default-archives``.  Files must be readable by the ``pscheduler`` user.

For example, this file will use the HTTP archiver to post the results of all throughput tests to ``https://host.example.com/place/to/post``::

    {
        "archiver": "http",
        "data": {
            "_url": "https://host.example.com/place/to/post",
            "op": "post"
        },
        "transform": {
            "script": "if (.test.type == \"throughput\") then . else null end"
        },
        "ttl": "PT5M"
    }

.. _pscheduler_ref_archivers-archivers:

Archivers
============================================

The archivers listed below are supplied as part of the standard distribution of pScheduler.

.. note:: All items listed in each *Archiver Data* subsection are required unless otherwise noted.

.. _pscheduler_ref_archivers-archivers-bitbucket:

``bitbucket``
-------------------------------------------

The ``bitbucket`` archiver sends measurement results to the `bit bucket <http://catb.org/jargon/html/B/bit-bucket.html>`_ (i.e., it does nothing with them).  This archiver was developed for testing pScheduler and serves no useful function in a production setting.

.. _pscheduler_ref_archivers-archivers-bitbucket-data:

Archiver Data
++++++++++++++++++++++++++++++++++++++++++++++

This archiver uses no archiver-specific data.

.. _pscheduler_ref_archivers-archivers-bitbucket-example:

Example
++++++++++++++++++++++++++++++++++++++++++++++
::

    {
        "archiver": "bitbucket",
        "data": { }
    }

.. _pscheduler_ref_archivers-archivers-esmond:

``esmond``
-------------------------------------------

The ``esmond`` archiver submits measurement results to the esmond time series database using specialized translations of results for ``throughput``, ``latency``, ``trace`` and ``rtt`` tests into a format used by earlier versions of perfSONAR. If it does not recognize a test it will store the raw JSON of the pscheduler result in the ``pscheduler-raw`` event type. 

.. _pscheduler_ref_archivers-archivers-esmond-data:

Archiver Data
++++++++++++++++++++++++++++++++++++++++++++++

``url`` - The URL for the esmond server which will collect the result.

``_auth-token`` - Optional. The authorization token to be used when submitting the result.  Note that the ``_`` prefix indicates that this value is considered a secret and will not be supplied if the task specification is retrieved from pScheduler via its REST API.  If not specified, IP authentication is assumed. 

``measurement-agent`` - Optional. The name of the pScheduler host that produced the result. If not specified, defaults to the endpoint pscheduler deemed the lead.

``retry-policy`` - Optional. Describes how to retry failed attempts to submit the measurement to esmond before giving up.  The default behavior is to try once and then give up.

``data-formatting-policy`` - Optional.  Indicates how the record should be stored.  Valid values are:
  * ``prefer-mapped`` - This is the default. It means that if test is type ``throughput``, ``latency``, ``trace`` and ``rtt`` than store using the traditional metadata and event types. If it does not recognize the result it will store as a ``pscheduler-raw`` record.
  * ``mapped-and-raw`` - Store both a mapped type and a raw record.  Will not store either if not a recognized type that can be mapped.
  * ``mapped-only`` - Only store a mapped type and do not store anything if it is not a known type
  * ``raw-only`` - Only store a ``pscheduler-raw`` record regardless of test type. 

``summaries`` - Optional.  A list of objects containing an ``event-type``, ``summary-type`` and ``summary-window``.  If not specified, defaults to a standard set of summaries used by perfSONAR.  See the :ref:`esmond documentation <psclient-rest-basevsumm>` for more details on summaries.

``verify-ssl`` - Optional.  Defaults to ``false``. If enabled, check SSL certificate of esmond server against list of known certificate authorities (CAs).  See the `requests documentation <http://docs.python-requests.org/en/v1.0.0/user/advanced/#ssl-cert-verification>`_ for more details on environment variables and other options for specifying path to CA store.

.. _pscheduler_ref_archivers-archivers-esmond-example:

Example
++++++++++++++++++++++++++++++++++++++++++++++
::

    {
        "archiver": "esmond",
        "data": {
            "measurement-agent": "ps.example.net",
            "url": "http://ma.example.net/esmond/perfsonar/archive/",
            "_auth-token": "35dfc21ebf95a6deadbeef83f1e052fbadcafe57",
            "retry-policy": [
                { "attempts": 1,  "wait": "PT60S"   },
                { "attempts": 1,  "wait": "PT300S"  },
                { "attempts": 11, "wait": "PT3600S" }
            ]
        }
    }

.. _pscheduler_ref_archivers-archivers-failer:

``failer``
-------------------------------------------

The ``failer`` archiver provides the same archiving function as ``bitbucket`` but introduces failure and retries a random fraction of the time.  This archiver was developed for testing pScheduler and serves no useful function in a production setting.

.. _pscheduler_ref_archivers-archivers-failer-data:

Archiver Data
++++++++++++++++++++++++++++++++++++++++++++++

``fail`` - The fraction of the time that archive attempts will fail, in the range ``[0.0,1.0]``.

``retry`` - The fraction of the time that archive attempts will be retried after a failure, in the range ``[0.0,1.0]``.

.. _pscheduler_ref_archivers-archivers-failer-example:

Example
++++++++++++++++++++++++++++++++++++++++++++++
::
  
    {
        "archiver": "failer",
        "data": {
            "fail": 0.5,
            "retry": 0.75
        }
    }



.. _pscheduler_ref_archivers-archivers-http:

``http``
-------------------------------------------

The ``http`` archiver sends results to HTTP or HTTPS servers using the ``POST`` or ``PUT`` operation.

.. _pscheduler_ref_archivers-archivers-http-data:

Archiver Data
++++++++++++++++++++++++++++++++++++++++++++++

``_url`` - The URL to which the data should be posted or put.

``op`` - Optional.  The HTTP operation to be used, ``post`` or ``put``.

``headers`` - Optional, available in schema 2 and later.  A JSON object consisting of pairs whose values are strings, numeric types or ``null``.  Each pair except those whose values are ``null`` will be passed to the HTTP server as a header.  The archiver gives special treatment to the following headers:

 - ``Content-Type`` - If not provided, the archiver will provide one of ``text/plain`` if the data to be archived is a string or ``application/json`` for any other JSON-representable type.  To force strings into JSON format, provide a ``Content-Type`` of ``application/json``.  This behavior can be disabled by providing a ``Content-Type`` header with the desired type or ``null``.

 - ``Content-Length`` - If not provided (which should be the usual case), the archiver will calculate and supply the length of the content.  This behavior can be disabled by providing a ``Content-Length`` of ``null``.

``bind`` - Optional.  The address on the host to which the HTTP client should bind when making the request.

``retry-policy`` - Optional.  Describes how to retry failed attempts to submit the measurement to esmond before giving up.  The default behavior is to try once and then give up.


.. _pscheduler_ref_archivers-archivers-http-example:

Example
++++++++++++++++++++++++++++++++++++++++++++++
::
  
    {
        "archiver": "http",
        "data": {
            "schema": 2,
            "_url": "https://server.example.com/post/here",
	    "_headers": {
	        "Authorization": "mumblemumble",
	        "Content-Type": "application/json"
	    }
        }
    }


.. _pscheduler_ref_archivers-archivers-kafka:

``kafka``
-------------------------------------------

The Kafka archiver sends the result of a pScheduler test as a message to a preexisting Apache Kafka message bus.

.. _pscheduler_ref_archivers-archivers-kafka-data:

Archiver Data
++++++++++++++++++++++++++++++++++++++++++++++

``topic`` - The topic under which the message should be posted on the message bus.

``server`` - The address of the server hosting the Apache Kafka message bus.

.. _pscheduler_ref_archivers-archivers-kafka-example:

Example
++++++++++++++++++++++++++++++++++++++++++++++
::

    {
    	"archiver": "kafka",
    	"data": {
        	"topic": "test",
        	"server-address": "localhost:9092"
    	}	
    }



.. _pscheduler_ref_archivers-archivers-postgresql:

``postgresql``
-------------------------------------------

The ``postgresql`` archiver connects to a PostgreSQL database and
inserts a row into a table.

The query made to do the insertion will be ``INSERT INTO
table_name(column_name) VALUES (...)`` where ``table_name`` and
``column_name`` are the table and column specified.


.. _pscheduler_ref_archivers-archivers-postgresql-data:

Archiver Data
++++++++++++++++++++++++++++++++++++++++++++++

``_dsn`` - Connection information for the PostgreSQL server.

``table`` - The name of the table where the row will be inserted.

``column`` - The name of the column where the data will be inserted.
This column must be of type ``JSON``, ``JSONB`` or any other that will
be automatically cast on insertion.

``connection-expires`` - Optional.  How long the connection should be
kept alive.  The default is never.

``retry-policy`` - Optional. Describes how to retry failed attempts to
submit the measurement to esmond before giving up.  The default
behavior is to try once and then give up.


.. _pscheduler_ref_archivers-archivers-postgresql-example:

Example
++++++++++++++++++++++++++++++++++++++++++++++
::
  
    {
        "archiver": "postgresql",
        "data": {
            "_dsn": "dbname=measurement user=torgo password=mumble",
            "table": "measurements",
            "column": "json_from_ps",
            "connection-expires": "PT30S",
            "retry-policy": [
                { "attempts": 5,  "wait": "PT5S" }
            ]
        }
    }



.. _pscheduler_ref_archivers-archivers-rabbitmq:

``rabbitmq``
-------------------------------------------

The ``rabbitmq`` archiver sends raw JSON results to `RabbitMQ <https://www.rabbitmq.com>`_.

.. _pscheduler_ref_archivers-archivers-rabbitmq-data:

Archiver Data
++++++++++++++++++++++++++++++++++++++++++++++

``_url`` - An ``amqp`` URL for the RabbitMQ instance which will
receive the result.

``exchange`` (Optional) - The exchange to which the result will be
sent.

``routing-key`` (Optional) - The routing key to be used when queueing
the message.  This can be a string or a standard pScheduler jq
transform.  If the latter, the ``schema`` must be ``2``.  Note that
this transform is provided with the same data that will go to the
archiver, meaning that it is whatever resulted after any ``transform``
in the archive specification.

``connection-expires`` (Optional) - An ISO8601 duration recommending
how long the connection to RabbitMQ for a given URL/exchange/key
combination should be kept alive.  The default is to create a new
connection for each result archived.  Note that a small value such as
``P0D`` can be used to force an existing connection to expire.
Requires ``schema`` of ``2`` or later.

``retry-policy`` (Optional) - Describes how to retry failed attempts
to submit the measurement to RabbitMQ before giving up.  The default
behavior is to try once and then give up.

.. _pscheduler_ref_archivers-archivers-rabbitmq-example:

Example
++++++++++++++++++++++++++++++++++++++++++++++
::
  
    {
        "archiver": "rabbitmq",
        "data": {
            "_url": "amqp://rabbithole.example.org/",
            "routing-key": "bugs",
            "retry-policy": [
                { "attempts": 5,  "wait": "PT1S" },
                { "attempts": 5,  "wait": "PT3S" }
            ]
        }
    }

.. _pscheduler_ref_archivers-archivers-syslog:

``syslog``
-------------------------------------------

The ``syslog`` archiver sends the raw JSON result to the system log.

Note that because most syslog implementations cannot handle arbitrarily-long log messages, this archiver should not be relied upon for anything other than debugging.

.. _pscheduler_ref_archivers-archivers-syslog-data:

Archiver Data
++++++++++++++++++++++++++++++++++++++++++++++

``ident`` - Optional.  The identification string to be used when submitting the log message.

``facility`` - Optional.  The syslog facility to be used when the log entry is submitted.  Valid valies are ``kern``, ``user``, ``mail``, ``daemon``, ``auth``, ``lpr``, ``news``, ``uucp``, ``cron``, ``syslog``, ``local0``, ``local1``, ``local2``, ``local3``, ``local4``, ``local5``, ``local6`` and ``local7``.

``priority`` - Optional.  The syslog priority to be used when the log entry is submitted.  Valid values are ``emerg``, ``alert``, ``crit``, ``err``, ``warning``, ``notice``, ``info`` and ``debug``.

.. _pscheduler_ref_archivers-archivers-syslog-example:

Example
++++++++++++++++++++++++++++++++++++++++++++++
::
  
    {
        "archiver": "syslog",
        "data": {
            "ident": "mytests",
            "facility": "local3",
            "priority": "warning"
        }
    }



.. _pscheduler_ref_archivers-archivers-tcp:

``tcp``
-------------------------------------------

The ``tcp`` archiver connects to a listening TCP socket, sends the raw
JSON result and disconnects.


.. _pscheduler_ref_archivers-archivers-tcp-data:

Archiver Data
++++++++++++++++++++++++++++++++++++++++++++++

``host`` - The host where the data should be sent.

``port`` - The TCP port on the host used for the connection.

``bind`` - Optional.  The local address to bind to when connecting to
``host``.

``ip-version`` - Optional.  The version of the IP protocol to use,
``4`` or ``6``.  If not provided, the archiver will attempt to guess
it by querying DNS for an ``AAAA`` or ``A`` record, in that order.

``retry-policy`` - Optional. Describes how to retry failed attempts to
submit the measurement to esmond before giving up.  The default
behavior is to try once and then give up.


.. _pscheduler_ref_archivers-archivers-tcp-example:

Example
++++++++++++++++++++++++++++++++++++++++++++++
::
  
    {
        "archiver": "tcp",
        "data": {
            "host": "sockets.example.net",
            "port": 6264
        }
    }



.. _pscheduler_ref_archivers-transforms:

Transforms
============================================
As part of an archive specification, pScheduler may be instructed to pre-process a run result before it is handed to the archiver plugin.  This is accomplished by adding a ``transform`` section to the archive specification::

    {
        "archiver": "syslog",
        "data": {
            "ident": "user-task",
            "facility": "local4",
            "priority": "info"
        },
        "transform": {
            "script": "...JQ Script...",
            "raw-output": false
        }
    }

The ``script`` is a string containing a valid script for the `jq JSON processor <https://stedolan.github.io/jq>`_ version 1.5.  There is a `tutorial on jq and pScheduler <https://www.youtube.com/watch?v=FrT6R75M3BE>`_ available on the `perfSONAR project's YouTube channel <https://www.youtube.com/perfSONARProject>`_.  The value returned by the script should be JSON or plain text (see ``raw-output``, below).

The transform is fed a single JSON object containing everything pScheduler knows about the task and the run.  A fully-populated example can be found below.


If the script returns a JSON value of ``null``, pScheduler will discard the result and not pass it to the plugin.  Because the transformation happens within pScheduler before any plugin code is invoked, this mechanism is a very efficient way to filter results and is preferred over writing custom plugins.

If ``raw-output`` is present and ``true``, the output will be treated as plain text instead of JSON.

Note that some archiver plugins, notably ``esmond``, may expect the input to be in the un-transformed format produced by pScheduler.  Using a transform in this case is not recommended.

.. _pscheduler_ref_archivers-transforms-examples:

Example Transforms
-------------------------------------------

.. _pscheduler_ref_archivers-transforms-examples-text:

Convert to Plain Text
++++++++++++++++++++++++++++++++++++++++++++++
::

    "transform": {
        "script": "\"Ran \\(.test.type) with \\(.tool.name)\"",
        "output-raw": true
    }

.. _pscheduler_ref_archivers-transforms-examples-diffjson:

Generate Different JSON
++++++++++++++++++++++++++++++++++++++++++++++
::

    "transform": {
        "script": "{ \"foo\": 123456, \"type\": .test.type, \"tool\": .tool.name }"
    }

.. _pscheduler_ref_archivers-transforms-examples-onetest:

Archive Only One Test Type
++++++++++++++++++++++++++++++++++++++++++++++
::

    "transform": {
        "script": "if (.test.type == \"trace\") then . else null end"
    }

.. _pscheduler_ref_archivers-transforms-examples-onetestlog:

Archive One Test Type, Log Others
++++++++++++++++++++++++++++++++++++++++++++++
::

    "transform": {
        "script": "if (.test.type == \"trace\") then . else \"Discarded unwanted \\(.test.type) test.\" end"
    }


.. _pscheduler_ref_archivers-transforms-examples-drop:

Drop and Transform
++++++++++++++++++++++++++++++++++++++++++++++
::

    "transform": {
        "script": "if (.test.type == \"idle\") then null else { \"foo\": 123456, \"type\": .test.type, \"tool\": .tool.name } end"
    }

.. _pscheduler_ref_archivers-transforms-examples-summtrace:

Summarize Trace Results
++++++++++++++++++++++++++++++++++++++++++++++
::

    "transform": {
        "script": "if (.test.type == \"trace\") then \"Trace to \\(.test.spec.dest), \\(.result.paths[0] | length) hops\" else null end"
    }

.. _pscheduler_ref_archivers-transforms-examples-alttrace:

Alternate JSON with Trace Hop List
++++++++++++++++++++++++++++++++++++++++++++++
::

    "transform": {
        "script": "if (.test.type == \"trace\") then { \"test\": .test.type, \"from\": .participants[0], \"to\": .test.spec.dest,  \"id\": .id, \"start\": .schedule.start, \"ips\": [ .result.paths[0] | .[].ip ] } else null end"
    }


.. _pscheduler_ref_archivers-transforms-input-example:

Transform Input Example
-------------------------------------------

This is an example of a throughput test result as it would be passed to a transform::

    {
      "task": {
        "test": {
          "type": "throughput",
          "spec": {
            "dest": "ps2.example.net",
            "source": "ps1.example.net",
            "schema": 1
          }
        },
        "tool": "iperf3",
        "href": "https://ps1.example.net/pscheduler/tasks/07e0d165-c79f-4786-b382-15cf8438c5c0",
        "detail": {
          "exclusive": true,
          "runs": 1,
          "added": "2019-09-10T14:55:22Z",
          "participant": 0,
          "cli": [
            "--duration", "PT5S",
            "--source", "ps1.example.net",
            "--dest", "ps2.example.net",
            "--reverse"
          ],
          "start": null,
          "enabled": true,
          "anytime": false,
          "diags": " ... Deleted for brevity ... ",
          "participants": [ "ps1.example.net", "ps2.example.net" ],
          "spec-limits-passed": [],
          "slip": "PT5M",
          "multi-result": false,
          "duration": "PT14S",
          "post": "P0D",
          "runs-started": 1
        },
        "schedule": {
          "slip": "PT5M"
        }
      },
      "run": {
        "priority": 5,
        "added": "2019-09-10T14:55:26Z",
        "start-time": "2019-09-10T14:55:35Z",
        "href": "https://ps1.example.net/pscheduler/tasks/07e0d165-c79f-4786-b382-15cf8438c5c0/runs/a44e447a-4cd0-429c-8937-cdcef742cc82",
        "result-merged": {
          "diags": " ... Deleted for brevity ...",
          "intervals": [ ...
            {
              "streams": [
                {
                  "throughput-bytes": 150503672,
                  "tcp-window-size": 211408,
                  "end": 1.00015,
                  "stream-id": 5,
                  "omitted": false,
                  "rtt": 1044,
                  "retransmits": 93,
                  "throughput-bits": 1203848840.4640322,
                  "start": 0
                }
              ],
              "summary": {
                "throughput-bytes": 150503672,
                "end": 1.00015,
                "omitted": false,
                "start": 0,
                "retransmits": 93,
                "throughput-bits": 1203848840.4640322
              }
            },
            {
              "streams": [
                {
                  "throughput-bytes": 170774448,
                  "tcp-window-size": 238920,
                  "end": 2.000195,
                  "stream-id": 5,
                  "omitted": false,
                  "rtt": 856,
                  "retransmits": 196,
                  "throughput-bits": 1366134187.3310146,
                  "start": 1.00015
                }
              ],
              "summary": {
                "throughput-bytes": 170774448,
                "end": 2.000195,
                "omitted": false,
                "start": 1.00015,
                "retransmits": 196,
                "throughput-bits": 1366134187.3310146
              }
            },
            {
              "streams": [
                {
                  "throughput-bytes": 202712760,
                  "tcp-window-size": 282360,
                  "end": 3.00016,
                  "stream-id": 5,
                  "omitted": false,
                  "rtt": 1045,
                  "retransmits": 217,
                  "throughput-bits": 1621758821.9784367,
                  "start": 2.000195
                }
              ],
              "summary": {
                "throughput-bytes": 202712760,
                "end": 3.00016,
                "omitted": false,
                "start": 2.000195,
                "retransmits": 217,
                "throughput-bits": 1621758821.9784367
              }
            },
            {
              "streams": [
                {
                  "throughput-bytes": 198281880,
                  "tcp-window-size": 246160,
                  "end": 4.000345,
                  "stream-id": 5,
                  "omitted": false,
                  "rtt": 994,
                  "retransmits": 229,
                  "throughput-bits": 1585961616.7730198,
                  "start": 3.00016
                }
              ],
              "summary": {
                "throughput-bytes": 198281880,
                "end": 4.000345,
                "omitted": false,
                "start": 3.00016,
                "retransmits": 229,
                "throughput-bits": 1585961616.7730198
              }
            },
            {
              "streams": [
                {
                  "throughput-bytes": 195038920,
                  "tcp-window-size": 282360,
                  "end": 5.002724,
                  "stream-id": 5,
                  "omitted": false,
                  "rtt": 1084,
                  "retransmits": 239,
                  "throughput-bits": 1556608281.3886986,
                  "start": 4.000345
                }
              ],
              "summary": {
                "throughput-bytes": 195038920,
                "end": 5.002724,
                "omitted": false,
                "start": 4.000345,
                "retransmits": 239,
                "throughput-bits": 1556608281.3886986
              }
            },
            {
              "streams": [
                {
                  "throughput-bytes": 9628640,
                  "tcp-window-size": 309872,
                  "end": 5.040158,
                  "stream-id": 5,
                  "omitted": false,
                  "rtt": 1276,
                  "retransmits": 0,
                  "throughput-bits": 2057731445.3724828,
                  "start": 5.002724
                }
              ],
              "summary": {
                "throughput-bytes": 9628640,
                "end": 5.040158,
                "omitted": false,
                "start": 5.002724,
                "retransmits": 0,
                "throughput-bits": 2057731445.3724828
              }
            }
          ],
          "succeeded": true,
          "summary": {
            "streams": [
              {
                "end": 5.040158,
                "stream-id": 5,
                "throughput-bytes": 926940320,
                "rtt": 1049,
                "retransmits": 974,
                "throughput-bits": 1471287717.5675843,
                "start": 0
              }
            ],
            "summary": {
              "throughput-bits": 1471287717.5675843,
              "start": 0,
              "end": 5.040158,
              "throughput-bytes": 926940320,
              "retransmits": 974
            }
          }
        },
        "participants": [ "ps1.example.net", "ps2.example.net" ],
        "state-display": "Finished",
        "result-full": [
          {
            "diags": " ... Deleted for brevity ... ",
            "intervals": [
              {
                "streams": [
                  {
                    "throughput-bytes": 155000464,
                    "end": 1.000821,
                    "stream-id": 5,
                    "omitted": false,
                    "start": 0,
                    "throughput-bits": 1238986511.0410876
                  }
                ],
                "summary": {
                  "throughput-bits": 1238986511.0410876,
                  "start": 0,
                  "end": 1.000821,
                  "throughput-bytes": 155000464,
                  "omitted": false
                }
              },
              {
                "streams": [
                  {
                    "throughput-bytes": 171620776,
                    "end": 2.000132,
                    "stream-id": 5,
                    "omitted": false,
                    "start": 1.000821,
                    "throughput-bits": 1373912874.7671387
                  }
                ],
                "summary": {
                  "throughput-bits": 1373912874.7671387,
                  "start": 1.000821,
                  "end": 2.000132,
                  "throughput-bytes": 171620776,
                  "omitted": false
                }
              },
              {
                "streams": [
                  {
                    "throughput-bytes": 204081120,
                    "end": 3.000043,
                    "stream-id": 5,
                    "omitted": false,
                    "start": 2.000132,
                    "throughput-bits": 1632794261.9281065
                  }
                ],
                "summary": {
                  "throughput-bits": 1632794261.9281065,
                  "start": 2.000132,
                  "end": 3.000043,
                  "throughput-bytes": 204081120,
                  "omitted": false
                }
              },
              {
                "streams": [
                  {
                    "throughput-bytes": 197905400,
                    "end": 4.000156,
                    "stream-id": 5,
                    "omitted": false,
                    "start": 3.000043,
                    "throughput-bits": 1583064297.2602603
                  }
                ],
                "summary": {
                  "throughput-bits": 1583064297.2602603,
                  "start": 3.000043,
                  "end": 4.000156,
                  "throughput-bytes": 197905400,
                  "omitted": false
                }
              },
              {
                "streams": [
                  {
                    "throughput-bytes": 196106984,
                    "end": 5.000101,
                    "stream-id": 5,
                    "omitted": false,
                    "start": 4.000156,
                    "throughput-bits": 1568942187.4911432
                  }
                ],
                "summary": {
                  "throughput-bits": 1568942187.4911432,
                  "start": 4.000156,
                  "end": 5.000101,
                  "throughput-bytes": 196106984,
                  "omitted": false
                }
              }
            ],
            "succeeded": true,
            "summary": {
              "streams": [
                {
                  "end": 5.040158,
                  "stream-id": 5,
                  "throughput-bytes": 926940320,
                  "rtt": 0,
                  "retransmits": 974,
                  "throughput-bits": 1471287717.5675843,
                  "start": 0
                }
              ],
              "summary": {
                "throughput-bits": 1471287717.5675843,
                "start": 0,
                "end": 5.040158,
                "throughput-bytes": 926940320,
                "retransmits": 974
              }
            }
          },
          {
            "diags": " ... Deleted for brevity ....",
            "intervals": [
              {
                "streams": [
                  {
                    "throughput-bytes": 150503672,
                    "tcp-window-size": 211408,
                    "end": 1.00015,
                    "stream-id": 5,
                    "omitted": false,
                    "rtt": 1044,
                    "retransmits": 93,
                    "throughput-bits": 1203848840.4640322,
                    "start": 0
                  }
                ],
                "summary": {
                  "throughput-bytes": 150503672,
                  "end": 1.00015,
                  "omitted": false,
                  "start": 0,
                  "retransmits": 93,
                  "throughput-bits": 1203848840.4640322
                }
              },
              {
                "streams": [
                  {
                    "throughput-bytes": 170774448,
                    "tcp-window-size": 238920,
                    "end": 2.000195,
                    "stream-id": 5,
                    "omitted": false,
                    "rtt": 856,
                    "retransmits": 196,
                    "throughput-bits": 1366134187.3310146,
                    "start": 1.00015
                  }
                ],
                "summary": {
                  "throughput-bytes": 170774448,
                  "end": 2.000195,
                  "omitted": false,
                  "start": 1.00015,
                  "retransmits": 196,
                  "throughput-bits": 1366134187.3310146
                }
              },
              {
                "streams": [
                  {
                    "throughput-bytes": 202712760,
                    "tcp-window-size": 282360,
                    "end": 3.00016,
                    "stream-id": 5,
                    "omitted": false,
                    "rtt": 1045,
                    "retransmits": 217,
                    "throughput-bits": 1621758821.9784367,
                    "start": 2.000195
                  }
                ],
                "summary": {
                  "throughput-bytes": 202712760,
                  "end": 3.00016,
                  "omitted": false,
                  "start": 2.000195,
                  "retransmits": 217,
                  "throughput-bits": 1621758821.9784367
                }
              },
              {
                "streams": [
                  {
                    "throughput-bytes": 198281880,
                    "tcp-window-size": 246160,
                    "end": 4.000345,
                    "stream-id": 5,
                    "omitted": false,
                    "rtt": 994,
                    "retransmits": 229,
                    "throughput-bits": 1585961616.7730198,
                    "start": 3.00016
                  }
                ],
                "summary": {
                  "throughput-bytes": 198281880,
                  "end": 4.000345,
                  "omitted": false,
                  "start": 3.00016,
                  "retransmits": 229,
                  "throughput-bits": 1585961616.7730198
                }
              },
              {
                "streams": [
                  {
                    "throughput-bytes": 195038920,
                    "tcp-window-size": 282360,
                    "end": 5.002724,
                    "stream-id": 5,
                    "omitted": false,
                    "rtt": 1084,
                    "retransmits": 239,
                    "throughput-bits": 1556608281.3886986,
                    "start": 4.000345
                  }
                ],
                "summary": {
                  "throughput-bytes": 195038920,
                  "end": 5.002724,
                  "omitted": false,
                  "start": 4.000345,
                  "retransmits": 239,
                  "throughput-bits": 1556608281.3886986
                }
              },
              {
                "streams": [
                  {
                    "throughput-bytes": 9628640,
                    "tcp-window-size": 309872,
                    "end": 5.040158,
                    "stream-id": 5,
                    "omitted": false,
                    "rtt": 1276,
                    "retransmits": 0,
                    "throughput-bits": 2057731445.3724828,
                    "start": 5.002724
                  }
                ],
                "summary": {
                  "throughput-bytes": 9628640,
                  "end": 5.040158,
                  "omitted": false,
                  "start": 5.002724,
                  "retransmits": 0,
                  "throughput-bits": 2057731445.3724828
                }
              }
            ],
            "succeeded": true,
            "summary": {
              "streams": [
                {
                  "end": 5.040158,
                  "stream-id": 5,
                  "throughput-bytes": 926940320,
                  "rtt": 1049,
                  "retransmits": 974,
                  "throughput-bits": 1471287717.5675843,
                  "start": 0
                }
              ],
              "summary": {
                "throughput-bits": 1471287717.5675843,
                "start": 0,
                "end": 5.040158,
                "throughput-bytes": 926940320,
                "retransmits": 974
              }
            }
          }
        ],
        "state": "finished",
        "errors": null,
        "limit-diags": " ... Deleted for brevity ...",
        "task-href": "https://ps1.example.net/pscheduler/tasks/07e0d165-c79f-4786-b382-15cf8438c5c0",
        "duration": "PT14S",
        "participant": 0,
        "end-time": "2019-09-10T14:55:49Z"
      },
      "reference": null,
      "schedule": {
        "duration": "PT14S",
        "start": "2019-09-10T14:55:35Z"
      },
      "tool": {
        "version": "1.0",
        "name": "iperf3"
      },
      "participants": [ "ps1.example.net", "ps2.example.net" ],
      "result": {
        "diags": " ... Deleted for brevity ...",
        "intervals": [
          {
            "streams": [
              {
                "throughput-bytes": 150503672,
                "tcp-window-size": 211408,
                "end": 1.00015,
                "stream-id": 5,
                "omitted": false,
                "rtt": 1044,
                "retransmits": 93,
                "throughput-bits": 1203848840.4640322,
                "start": 0
              }
            ],
            "summary": {
              "throughput-bytes": 150503672,
              "end": 1.00015,
              "omitted": false,
              "start": 0,
              "retransmits": 93,
              "throughput-bits": 1203848840.4640322
            }
          },
          {
            "streams": [
              {
                "throughput-bytes": 170774448,
                "tcp-window-size": 238920,
                "end": 2.000195,
                "stream-id": 5,
                "omitted": false,
                "rtt": 856,
                "retransmits": 196,
                "throughput-bits": 1366134187.3310146,
                "start": 1.00015
              }
            ],
            "summary": {
              "throughput-bytes": 170774448,
              "end": 2.000195,
              "omitted": false,
              "start": 1.00015,
              "retransmits": 196,
              "throughput-bits": 1366134187.3310146
            }
          },
          {
            "streams": [
              {
                "throughput-bytes": 202712760,
                "tcp-window-size": 282360,
                "end": 3.00016,
                "stream-id": 5,
                "omitted": false,
                "rtt": 1045,
                "retransmits": 217,
                "throughput-bits": 1621758821.9784367,
                "start": 2.000195
              }
            ],
            "summary": {
              "throughput-bytes": 202712760,
              "end": 3.00016,
              "omitted": false,
              "start": 2.000195,
              "retransmits": 217,
              "throughput-bits": 1621758821.9784367
            }
          },
          {
            "streams": [
              {
                "throughput-bytes": 198281880,
                "tcp-window-size": 246160,
                "end": 4.000345,
                "stream-id": 5,
                "omitted": false,
                "rtt": 994,
                "retransmits": 229,
                "throughput-bits": 1585961616.7730198,
                "start": 3.00016
              }
            ],
            "summary": {
              "throughput-bytes": 198281880,
              "end": 4.000345,
              "omitted": false,
              "start": 3.00016,
              "retransmits": 229,
              "throughput-bits": 1585961616.7730198
            }
          },
          {
            "streams": [
              {
                "throughput-bytes": 195038920,
                "tcp-window-size": 282360,
                "end": 5.002724,
                "stream-id": 5,
                "omitted": false,
                "rtt": 1084,
                "retransmits": 239,
                "throughput-bits": 1556608281.3886986,
                "start": 4.000345
              }
            ],
            "summary": {
              "throughput-bytes": 195038920,
              "end": 5.002724,
              "omitted": false,
              "start": 4.000345,
              "retransmits": 239,
              "throughput-bits": 1556608281.3886986
            }
          },
          {
            "streams": [
              {
                "throughput-bytes": 9628640,
                "tcp-window-size": 309872,
                "end": 5.040158,
                "stream-id": 5,
                "omitted": false,
                "rtt": 1276,
                "retransmits": 0,
                "throughput-bits": 2057731445.3724828,
                "start": 5.002724
              }
            ],
            "summary": {
              "throughput-bytes": 9628640,
              "end": 5.040158,
              "omitted": false,
              "start": 5.002724,
              "retransmits": 0,
              "throughput-bits": 2057731445.3724828
            }
          }
        ],
        "succeeded": true,
        "summary": {
          "streams": [
            {
              "end": 5.040158,
              "stream-id": 5,
              "throughput-bytes": 926940320,
              "rtt": 1049,
              "retransmits": 974,
              "throughput-bits": 1471287717.5675843,
              "start": 0
            }
          ],
          "summary": {
            "throughput-bits": 1471287717.5675843,
            "start": 0,
            "end": 5.040158,
            "throughput-bytes": 926940320,
            "retransmits": 974
          }
        }
      },
      "test": {
        "type": "throughput",
        "spec": {
          "dest": "ps2.example.net",
          "source": "ps1.example.net",
          "duration": "PT5S",
          "reverse": true,
          "schema": 1
        }
      },
      "id": "a44e447a-4cd0-429c-8937-cdcef742cc82"
    }
