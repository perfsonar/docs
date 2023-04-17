=============================
Configuring pScheduler Limits
=============================

************
Introduction
************

pScheduler offers the ability to control what tasks may be run, by
whom and with what parameters.  This is achieved by writing and
installing a *limit configuration file*.


A number of commented samples may be found in
``/usr/share/doc/pscheduler/limit-examples`` on systems with the
pScheduler bundle installed.  The limit configuration that ships with
the perfSONAR toolkit may be found `in the toolkit sources
<https://github.com/perfsonar/toolkit/blob/master/etc/default_service_configs/pscheduler_limits.conf>`_.


****************************
The Limit Configuration File
****************************

--------------------------------
Installing a Limit Configuration
--------------------------------

The limit configuration is installed in ``/etc/pscheduler/limits.conf`` and must be readable by the ``pscheduler`` user.  The recommended file attributes are owner ``root``, group ``pscheduler`` and permissions `0644`.

pScheduler server automatically detect changes to the limit configuration and put them into effect upon the arrival of the first request that requires checking limits or 15 seconds, whichever is longer.  Changes to the limit file are noted in the pScheduler log (usually ``/var/log/pscheduler/pscheduler.log``), as are notifications of problems.

.. warning:: If the configuration file does not exist, is removed or fails to load, pScheduler will enforce no limits and grant every task request it receives.  For this reason, it is strongly recommended that configurations be verified as described in :ref:`config_pscheduler_limits-check-validity` before they are installed.

-------
Content
-------

The file is `JavaScript Object Notation <http://www.json.org>`_ (JSON)
containing a single object with the pairs shown here::

    {
        "#": "Skeletal pScheduler limit configuration",

        "identifiers": [ ... ],
        "classifications": [ ... ],
        "rewrite": [ ... ],
        "limits": [ ... ],
        "applications": [ ... ],
        "priority": { ... }
    }

Each pair is described in the sections below.

--------
Comments
--------

All JSON read by pScheduler supports in-line commenting by ignoring
any pair whose key begins with a pound sign (``#``)::

    {
        "#": "This is a comment.",
        "#This": "is also a comment.",
        "This": "#is not a comment.",
    }

Note that this behavior is not part of ECMA 404, the JSON standard.


*****************************
Identifiers:  *Who's Asking?*
*****************************

The first phase of vetting a task or run is *identification*, where
attributes of the arriving request are used to create a list of narrow
categories into which the requester fits.  Note that _requester_ means
the system making the request, identified by its IP address, and can
be either the system that submitted the task to pScheduler or one
pScheduler node setting up the task with another.

The ``identifiers`` section of the limit configuration contains an
array of *identifier objects*, each containing the following pairs:

- ``name`` - A string which gives the identifier a name which must be
  unique among all identifiers.
- ``description`` - A human-readable string describing the identifier.
- ``type`` - A string indicating what the method to be used in
  determining whether or not the requester should be identified in
  this category.  (See *Identifier Types*.)
- ``data`` - A JSON object containing ``type``-specific data used in
  determining whether the requester should be identified in this
  category.  (See *Identifier Types*.)
- ``invert`` - An optional boolean value indicating whether or not
  the identification should be inverted after evaluation (i.e.,
  ``true`` would make a requester identify in this category when it
  otherwise would not have done so and ``false`` would do the
  opposite).

For example::

    {
        "identifiers": [
            {
                "name": "partners-bio",
                "description": "Research Partners in biology",
                "type": "ip-cidr-list",
                "data": {
                    "cidrs": [ "192.0.2.0/24", "198.51.100.0/24" ]
                },
                "invert": false
            },
            {
                "name": "local",
                "description": "Requesters on the local system",
                "type": "localif",
                "data": { }
            },
            {
                "name": "everyone",
                "description": "All requesters",
                "type": "always",
                "data": { }
            },
        ],
        ...
    }


----------------
Identifier Types
----------------

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``always`` - Identify Everyone
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``always`` identifier unconditionally identifies every requester,
useful in catch-alls.

Its ``data`` is an empty object::

    {
        "data": { }
    }

There are exactly two useful configurations of this identifier::

        {
            "name": "everybody",
            "description": "An identifier that identifies every requester",
            "type": "always",
            "data": { }
        }

        {
            "name": "nobody",
            "description": "An identifier that identifies no requesters",
            "type": "always",
            "data": { },
            "invert": true
        }



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``hint`` - Identify Using Server-Provided Hints
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``hint`` identifier matches information about the requester to
make identifications.

Its ``data`` is an object containing the following pairs:

- ``hint`` - The name of the hint to be checked.  Valid hints are
    ``requester``, a string containing the IP address of the host
    making the request, and ``server``, a string containing the IP
    address of the interface on the local system where the request
    arrived.
- ``match`` - A ``StringMatch`` object.  (See *Standard Objects*.)

For example::

    {
        "name": "internal",
        "description": "Requests arriving on our internal-facing interface",
        "type": "hint",
        "data": {
            "hint": "server",
            "match": {
                "style": "exact",
                "match": "198.51.100.23"
            }
        }
    }


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``ip-cidr-list`` - Identify By Requesting IP Address
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``ip-cidr-list`` identifier determines whether or not the IP
address of the host making a request falls into any of a list of
`Classless Inter-Domain Routing
<https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing>`_`
(CIDR) blocks.

Its ``data`` is an object containing the following pairs:

- ``cidrs`` - A list of IPv4 or IPv6 CIDR blocks.

For example::

    {
        "name": "partners",
        "description": "Networks used by research partners",
        "type": "ip-cidr-list",
        "data": {
            "cidrs": [
                "203.0.113.62",
                "192.168.19.0/24",
                "192.168.84.0/24",
                "2001:db8::1234",
                "fc00:1bad:cafe::/48",
                "fc00:dead:beef::/48"
                ]
        }
    }


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``ip-cidr-list-url`` - Identify By Requesting IP Address with Downloaded List
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``ip-cidr-list-url`` identifier serves the same purpose as
``ip-cidr-list`` but downloads the list of CIDRs from a URL and
periodically updates it.

Its ``data`` is an object containing the following pairs:

- ``source`` - A string containing a URL from which the list should
  be downloaded.  The format of the downloaded data is a plain text
  list of individual IPs or CIDRs separated by newlines.  Empty lines
  or those beginning with a pound sign (``#``) are treated as
  comments and ignored.
- ``update`` - An ISO 8601 duration indicating how often the limit
  processor should attempt to retrieve a new copy of the list from
  the ``source``.
- ``retry`` - An ISO 8601 duration indicating how often the limit
  processor should attempt to retrieve a new copy of the list should
  the initial download or an update result in a failure.
- ``fail-state`` - A boolean value indicating whether or not the
  identifer should identify all requesters when the CIDR list is not
  been successfully retrieved.

Note that this identifier will continue to use the list it last
successfully downloaded until an update can be successfully retrieved.

**Examples**

This identifier downloads ESNet's list of CIDRs for research and
education networks, updates it daily with four-hour retries on failure
and excludes the private networks defined by RFC 1918::

    {
        "name": "r-and-e",
        "description": "Requests from research and education networks",
        "type": "ip-cidr-list-url",
        "data": {
            "source": "http://stats.es.net/sample_configs/pscheduler/ren",
            "update": "P1D",
            "retry": "PT4H",
            "exclude": [
                "10.0.0.0/8",
                "172.16.0.0/12",
                "192.168.0.0/16"
            ],
            "fail-state": false
        }
    }


This identifier downloads the `Amazon Web Services CIDR block list <https://docs.aws.amazon.com/general/latest/gr/aws-ip-ranges.html>`_ and uses jq to translate it into the expected format::

    {
        "name": "aws",
        "description": "Requests from Amazon Web Services hosts",
        "type": "ip-cidr-list-url",
        "data": {
            "source": "https://ip-ranges.amazonaws.com/ip-ranges.json",
            "transform": {
                "script": ".prefixes[].ip_prefix, .ipv6_prefixes[].ipv6_prefix",
                "output-raw": true
            },
            "update": "P1D",
            "retry": "PT4H",
            "fail-state": false
        }
    }


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``ip-cymru-bogon`` - Identify Bogon Addresses
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``ip-cymru-bogon`` identifier determines whether or not the
requester's address is in Team Cymru's `Bogon Refernce List
<http://www.team-cymru.org/bogon-reference.html>`_.

Its ``data`` is an object containing the following pairs:

- ``exclude`` - A list of IP addresses and CIDR blocks that should
  not be treated as bogons even if they are on Team Cymru's list.
- ``timeout`` - An ISO 8601 duration indicating how long the
  identifier should try to get an answer before giving up.
- ``fail-result`` - A boolean value indicating whether or not the
  identifer should identify all requesters as bogons when a
  definitive answer cannot be found.


Note that this identifier uses the `Domain Name Service
<http://www.team-cymru.org/bogon-reference-dns.html>`_ to check
whether or not an address is in the list, and therefore its use
requires that the host be able to resolve hosts on the public
Internet.  This system works with caching DNS servers, so direct
access to the internet is not required.

For example, this identifier checks incoming request addresses,
excludes three of the RFC1918 blocks, gives up after one second and
does not identify the requester as a bogon if a definitive answer
cannot be found::

    {
        "name": "bogons",
        "description": "Requests arriving from bogon/martian addresses",
        "type": "ip-cymru-bogon",
        "data": {
            "exclude": [
                "10.10.0.0/16",
                "192.168.86.0/24",
                "192.168.99.0/24"
            ],
            "timeout": "PT1S",
            "fail-result": false
        }
    }



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``ip-cymru-asn`` - Identify Requesters by ASN
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``ip-cymru-asn`` identifier uses `Team Cymru's IP to ASN service
<https://team-cymru.com/community-services/ip-asn-mapping/#dns>`_ to
determine whether or not the requester's address is part of an
autonomous system number (ASN) or is peered with one in a provided
list.

Its ``data`` is an object containing the following pairs:

- ``asns`` - A list containing the ASNs to be checked, each as an
  integer.
- ``peers`` - A boolean indicating whether the list of peers for the
  IP's AS should be checked.  Note that the nature of routing makes
  this is an inexact science, so this option should be used with care.
- ``timeout`` - An ISO 8601 duration indicating how long the
  identifier should try to get an answer before giving up.
- ``fail-result`` - A boolean value indicating whether or not the
  identifer should identify all requesters as bogons when a
  definitive answer cannot be found.


Note that this identifier uses the `Domain Name Service
<http://www.team-cymru.org/asn-reference-dns.html>`_ to check
whether or not an address is in the list, and therefore its use
requires that the host be able to resolve hosts on the public
Internet.  This system works with caching DNS servers, so direct
access to the internet is not required.

For example, this identifier checks that the requester's address is
within ANs 123, 456 or 789::

    {
        "name": "friendly-asns",
        "description": "ASNs we like"
        "type": "ip-cymru-asn",
        "data": {
            "asns": [ 123, 456, 789 ],
            "timeout": "PT3S",
            "fail-result": false
        }
    }



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``ip-reverse-dns`` - Identify Requesters By Host Name
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``ip-reverse-dns`` identifier attempts to reverse-resolve the
requester's IP address to a fully-qualified domain name and matches
it against a pattern.


Its ``data`` is an object containing the following pairs:

- ``match`` - A ``StringMatch`` object.  (See *Standard Objects*.)
- ``timeout`` - An ISO 8601 duration indicating how long the
  identifier should try to get an answer before giving up.

As a security measure, the fully-qualified domain name found during
reverse resolution will be forward-resolved to an IP which must match
that of the requester.

For example, this identifier determines whether or not the incoming
requester's fully-qualified domain name falls within ``example.org``,
giving up after two seconds::

    {
        "name": "example-dot-org",
        "description": "Requests arriving from example.org IPs",
        "type": "ip-reverse-dns",
        "data": {
            "match": {
                "style": "regex",
                "match": "\\.example\\.org$"
            },
            "timeout": "PT2S"
        }
    }




^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``jq`` - Use a jq Script to Identify Requesters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``jq`` identifier allows decisions to be made based on hints about
the requester provided by the system using a `jq <https://stedolan.github.io/jq>`_
script.

Input to the script is a JSON object containing pairs for each of the
hints that pScheduler provides.  For example::

    {
        "requester": "198.51.100.19",    IP making the request
        "server": "192.0.2.202"          IP on which the request arrived
    }

The script should return a single Boolean value, ``true`` to indicate
that an identification was made, ``false`` otherwise.  Return of any
other type will be treated the same as a value ``false``.


**Examples**

**Note:  Both of these examples would be better carried out using the ``ip-cidr-list`` identifier** but are also good examples of jq scripting in this context.

Check to see if the requesting IP is a single IP that should not be
allowed to use the system. (Note that the ``ip-cidr-list`` identifier
is a better choice for this example.) ::

    {
        "name": "do-not-want",
        "description": "One IP we really, really dislike.",
        "type": "jq",
        "data": {
            "script": ".requester == \"198.51.100.86\"",
        }
    }

Identify requests not being made to an address that's not considered
one of the management interfaces: ::

    {
        "name": "non-management-if",
        "description": "Requests not arriving on a management interface(s)",
        "type": "jq",
        "data": {
            "script": "[.server == $management_ips[]] | any | not",
            "args": {
                "management_ips": ["127.0.0.1", "198.51.100.46"]
            }
        }
    }



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``localif`` - Identify Requesters On Local Interfaces
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``localif`` identifier determines whether or not the requester's
IP address is bound to an interface on the local system.


Its ``data`` is an empty object::

    {
        "data": { }
    }

For example::

    {
        "name": "local-requester",
        "description": "Requests arriving from local interfaces",
        "type": "localif",
        "data": { }
    }





************************************************
Classifiers:  *How Do We Group the Identifiers?*
************************************************

Once a list of identifiers is determined, the second phase is grouping
them into broader categories called *classifiers*.  Classifiers are
simple groups containing a list of one or more identifiers.

The ``classifiers`` section of the limit configuration contains an
array of *classifier objects*, each containing the following pairs:

- ``name`` - A string which gives the identifier a name which must be
  unique among all classifiers.  To avoid confusion, it is
  recommended, but not required, that classifier names and identifier
  names do not overlap.
- ``description`` - A human-readable string describing the classifier.
- ``identifiers`` - An array of strings indicating what identifiers
  should be part of the classifier.
- ``require`` - A string specifying how many of the listed identifiers
  must be present for the requester to meet the requested
  classification.  Valid values are ``none``, ``one``, ``any`` and
  ``all``.  If not provided, the default behavior will be ``any``.
  (Use of this parameter requires a ``schema`` of ``4`` or higher.)


For example::

    {
        ...
        "classifiers": [
            {
                "name": "friendlies",
                "description": "Requesters we like",
                "identifiers": [ "local", "partners", "r-and-e" ]
            },
            {
                "name": "hostiles",
                "description": "Requesters we don't want using the system",
                "identifiers": [ "bogons", "example-dot-org" ]
            },
            {
                "name": "neutrals",
                "description": "Requesters we neither like nor dislike",
                "identifiers": [ "everybody" ]
            },
            {
                "name": "r-and-e-partners",
                "description": "Partners from research and education"
                "identifiers": [ "partners", "r-and-e" ],
		"require": "all"
            },
        ...
    }


Note that the ``neutrals`` classification will include all requesters,
which makes it overlap with ``friendlies`` and ``hostiles``.  As will
be illustrated later, the narrower classifications can be used to
allow or deny tasks before the wider ones.


******************************************
Task Rewriting:  *What Should Be Changed?*
******************************************

Before applying limits to an incoming task, the pScheduler limit
system can apply a `jq <https://stedolan.github.io/jq>`_ script to the
task to make changes on the fly.

If a `rewrite` pair is present in a limit configuration where the
`schema` is `2` or later and the submission is on a system that is the
lead participant, it specifies a jq transform applied to the task
immediately after initial validation and prior to limit enforcement
and tool selection.  Note that because the rewriter provides a set of
functions that are inserted into the script, all `import` and
`include` statements are extracted and relocated in order to the top
to maintain correct jq syntax.

Input to the transform's script is a JSON object containing the
contents of the task as it was submitted to the server.  The rewriter
adds a private pair for its own internal use (currently named
`__REWRITER_PRIVATE__`) which should not be examined or modified.

Changes to the task are made by modifying the JSON in place (e.g.,
`.test.spec.bandwidth = 100000000`) and must be followed by a call to
the `change()` function (described below) with a message that will be
meaningful to the end user (e.g., `Limited bandwidth to 100 Mb/s`).

Conditions that would require that the incoming task be rejected may
be dealt with by calling the `reject()` function (described below)
with a message that will be meaningful to the end user (e.g., `Cannot
use tools whose names contain the letter T`).  Tasks rejected in this
way will _not_ be screened by other limits that might have allowed it
to proceed, so use this feature carefully.  Also note that rewriting
takes place only on the node which is the lead participant, so other
nodes should not rely on this mechanism as a way of enforcing limits.

Should the script fail when it is run, the incoming task will be
rejected with a suitable diagnostic message.


**Rewriter Built-In Functions**

The following functions will be made available to rewriting scripts:

`change(message)` - Signals that a change has been made to the task
and adds the string `message` to the set of diagnostics added to the
task's details.  This function must be called at least once if the
script modifies the JSON in any way.  Any non-string value for
`message` will be passed through jq's `tostring` function.  A value of
`null` will result in no message being appended to the diagnostics,
although this is strongly discouraged.

`classifiers` - Returns an array of the classifiers into which the
node requesting the task were grouped (e.g., `[ "friendlies",
"partners" ]`).

`classifiers_has(value)` - Returns a boolean indicating whether or not
the string `value` is one of the classifiers.

`reject(message)` - Signals that the task should be rejected for the
reason described by `message`.  Any non-string value for `message`
will be passed through jq's `tostring` function.


**Examples**

Force certain tests to operate from a specific interface::

    {
        ...
        "rewrite": {
            "script": [
                "import \"pscheduler/iso8601\" as iso;",

                "# Recommended so the pipeline statements all begin with |.",
                ".",

                "# Hold this in a variable for use where it's not in-context",
                "| .task.type as $tasktype",

                "# Force latency onto a specific interface",
                "| if ( [\"latency\", \"latencybg\" ] | contains([$tasktype]) )",
                "  then",
                "    .task.spec.source = \"ps7-latency.example.org\"",
                "    | change(\"Forced use of interface reserved for latency\")",
                "  else",
                "    .",
                "  end",

                "# The end.  (This takes care of the no-comma-at-end problem)"
            ]
        },
        ...
    }



Throttle the `bandwidth` parameter of `throughput` tests for all but
certain groups to 50 Mb/s::

    {
        ...
        "rewrite": {
            "script": [
                ".",

                "# Throttle non-friendlies to 50 Mb/s for throughput",
                "| if .task.type == \"throughput\"",
                "    and (",
                "      (.task.spec.bandwidth == null)",
                "      or (.task.spec.bandwidth > 50000000)",
                "    )",
                "    and (.classifiers | contains([\"friendlies\"]) | not)",
                "  then",
                "    .task.spec.bandwidth = 50000000",
                "    | change(\"Throttled bandwidth to 50 Mb/s\")",
                "  else",
                "    .",
                "  end",

                "# The end."
            ]
        },
        ...
    }


Force the minimum duration for certain tests that specify one to 5 seconds::

    {
        ...
        "rewrite": {
            "script": [
                "import \"pscheduler/iso8601\" as iso;",

                ".",

                "# Hold this in a variable for use where it's not in-context",
                "| .task.type as $tasktype",

                "# Make some tests run a minimum of 5 seconds",
                "| if ( [\"idle\", \"idlebgm\", \"idleex\", \"latency\", \"latencybg\", \"throughput\" ]",
                "       | contains([$tasktype]) )",
                "    and iso::duration_as_seconds(.task.spec.duration) < 5",
                "  then",
                "    .task.spec.duration = \"PT5S\"",
                "    | change(\"Bumped duration to 5-second minimum\")",
                "  else",
                "    .",
                "  end",

                "# The end."
            ]
        },
        ...
    }



Force the repeat interval, if specified, to a minimum of one minute::

    {
        ...
        "rewrite": {
            "script": [
                "import \"pscheduler/iso8601\" as iso;",

                ".",
                "| if .schedule.repeat != null"
                "    and iso::duration_as_seconds(.schedule.repeat) < 60",
                "  then",
                "    .schedule.repeat = \"PT1M\"",
                "    | change(\"Bumped repeat to one-minute minimum\")",
                "  else",
                "    .",
                "  end",

                "# The end."
            ]
        },
        ...
    }






*************************************
Limits:  *What Are the Restrictions?*
*************************************

The third phase of vetting a task is determining whether or not its
parameters fall within acceptable values.  Each limit is evaluated and
either *passes* (i.e., the task parameters fell within the limit's
restrictions) or *fails* (i.e., it did not).

The ``limits`` section of the limit configuration is nearly identical
to the ``identifiers`` section and contains the following pairs:

- ``name`` - A string which gives the limit a name which must be
  unique among all limits.
- ``description`` - A human-readable string describing the limit.
- ``clone`` - A string naming another limit that should be used as a
  starting point for this one.
- ``type`` - If the limit was not cloned from another, a string
  indicating what the type of limit to be checked.  (See *Limit
  Parameter Types*.)
- ``data`` - A JSON object containing ``type``-specific data used in
  determining whether the task meets this limit.  (See *Limit
  Parameter Types*.)
- ``invert`` - An optional boolean value indicating whether or not
  the result should be inverted after evaluation (i.e., ``true``
  would pass a limit that would otherwise have failed and ``false``
  would do the opposite).

For example::

    {
        ...
        "limits": [
            {
                "name": "always",
                "description": "Always passes",
                "type": "pass-fail",
                "data": {
                    "pass": true
                }
            },
            {
                "name": "innocuous-tests",
                "description": "Tests that are harmless",
                "type": "test-type",
                "data": {
                    "types": [ "idle", "latency", "rtt", "trace" ]
                }
            },
            {
                "name": "throughput-default-template",
                "description": "Template for throughput defaults",
                "type": "test",
                "data": {
                    "test": "throughput",
                    "limit": {
                    "duration": {
                        "range": { "lower": "PT5S", "upper": "PT60S" }
                    }
                }
            },
            {
                "name": "throughput-default-udp",
                "description": "UDP throughput for all requesters",
                "clone": "throughput-default-template",
                "data": {
	            "limit": {
                        "bandwidth": {
                            "range": { "lower": "1", "upper": "800K" },
                        }
                        "udp": { "match": true }
                    }
                }
            },
            {
                "name": "throughput-default-tcp",
                "description": "TCP throughput for all requesters",
                "clone": "throughput-default-template",
                "data": {
	            "limit": {
                        "bandwidth": {
                            "range": { "lower": "1", "upper": "50M" },
                        }
                        "udp": { "match": false }
                    }
                }
            }
        ],
        ...
    }



-----------
Limit Types
-----------


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``jq`` - Use a jq Script to Make a Pass/Fail Decision
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``jq`` limit hands the proposed task to a
`jq <https://stedolan.github.io/jq>`_ script and passes or fails based
on the script's return value.

Input to the script is a single JSON object containing the following
pairs:

 * ``test`` - A JSON object containing the proposed test with a
   ``type`` (a string) and ``spec`` (a JSON object containing the test
   specification).
 * ``tool`` - A string that names the tool that was selected.
 * ``schedule`` - A JSON object containing all schedule paramaters
   submitted with the test (any of ``start``, ``repeat``, ``repeat-cron``,
   ``max-runs``, ``until``, ``slip``, and ``sliprand``)

 * ``run_schedule`` - An optional JSON object containing an ISO8601
   timestamp (`start`) and ISO8601 duration (`duration`) specifying
   when the run is proposed to start and how much time it will spend
   running.  (Note that the latter is usually greater than the test's
   `duration` parameter if it has one.)  This object will not be
   present if a new task is being evaluated but will be for evaluation
   of runs.

For example::

    {
        "test": {
            "type": "throughput",
            "spec": {
                "dest": "ps.example.com",
                "bandwidth": "200M",
                "duration": "PT1M"
            },
        },
        "tool": "iperf3",
        "schedule": {
            "repeat": "PT10M",
            "max-runs": 10,
        },
        "run_schedule": {
            "start": "2018-06-19T12:34:56",
            "duration": "PT1M8S"
        }
    }

The script should produce one of the following values:

 * Boolean (``true`` or ``false``) - Signifies that the proposed task passes or does not pass the limit.  If the value is ``false``, the limit system's diagnostic output will indicate an unspecified reason for the failure.
 * String - Signifies that the proposed task  does not pass the limit and uses the contents of the string as the reason for the failure in diagnostic output.

Non-boolean or non-string output will be treated as if the limit did not pass and a suitable diagnostic message will be provided.

**Examples**

(Note that whitespace has been added to some strings for clarity.)

Limit the `length` parameter of any test to 256::

    {
        "name": "big-packets",
        "description": "Limit packet size for all tests",
        "type": "jq",
        "data": {
            "script": "256 as $max_length
                       | if .spec.length > $max_length
                         then \"Packets are limited to \\($max_length) bytes\"
                         else true
                         end"
        }
    }


Limit any the number of hops in a `trace` test to 20::

    {
        "name": "trace-hops",
        "description": "Limit trace hops",
        "type": "jq",
        "data": {
            "script": "20 as $max_hops
                       | if .type == \"trace\" and .spec.hops > $max_hops
                         then \"No more than \\($max_hops) hops allowed.\"
                         else true
                         end"
        }
    }

Limit the bandwidth of `throughput` tests to 500 Mb/s::

    {
        "name": "throughput-low-bandwidth",
        "description": "Limit throughput test bandwidth",
        "type": "jq",
        "data": {
            "script": "import \"pscheduler/si\" as si;
                       "500M" as $max_bandwidth
                       | if .type == \"throughput\"
                             and si::as_integer(.spec.bandwidth) > si::as_integer($max_bandwidth)
                         then \"Bandwidth is limited to \\($max_bandwidth)\"
                         else true
                         end"
        }
    }



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``pass-fail`` - Explicitly Pass or Fail
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``pass-fail`` limit will either pass or fail depending on a value
in its ``data``.

Its ``data`` is an object containing the following pair:

- ``pass`` - A boolean indicating whether or not the limit will pass
  or fail.


For example::

    {
        "name": "never",
        "description": "Fail to pass",
        "type": "pass-fail",
        "data": {
            "pass": false
        }
    }



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``run-daterange`` - Check Run Times Against a Range
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``run-daterange`` limit tests to see whether the time range for a
run falls within a specified range.

Its ``data`` is an object containing the following pairs:

- ``start`` - An ISO 8601 timestamp specifying the start of the range.
- ``end`` - An ISO 8601 timestamp specifying the end of the range.
- ``overlap`` - A boolean which, if ``true``, will let the limit pass
  if the run's time range overlaps the specified range but does not
  fall completely within it.

Note that limits of this type are not evaluated and will be
considered to have passed when determining whether a task will be
allowed on the system.

For example::

    {
        "name": "summer-2017",
        "description": "The summer of 2017",
        "type": "run-daterange",
        "data": {
            "start": "2017-06-21T00:00:00",
            "end": "2017-09-22T23:59:59"
        }
    }


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``run-schedule`` - Check Attributes of the Run Time
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``run-daterange`` limit tests to see whether attributes the time
range for a run matches those specified.

Its ``data`` is an object containing the following pairs.  The format
of the pairs is described below.

- ``year`` - The years in which the run will happen.
- ``month`` - The months in which the run will happen, numbered from ``1`` to ``12``.
- ``day`` - The days of the month in which the run will happen, numbered from ``1`` to ``31``.
- ``weekday`` - The days of the week in which the run will happen,
  numbered from ``1`` (Monday) to ``7`` (Sunday) according to
  ISO 8601.
- ``hour`` - The hours in which the run will happen, numbered from ``0`` to ``23``
- ``minute`` - The minutes in which the run will happen, numbered from ``0`` to ``59``.
- ``minute`` - The seconds in which the run will happen, numbered from ``0`` to ``59``.

All pairs are optional.

Each pair consists of a key (e.g., ``month``) and an array of
individual numbers or ranges.  Each range is an object containing the
following pairs:

- ``lower`` - An integer specifying the lower end of the range.
- ``upper`` - An integer specifying the upper end of the range.

Note that this limits of this type are not evaluated and will be
considered to have passed when determining whether a task will be
allowed on the system.

For example::

    {
        "name": "not-in-maint-window",
        "description": "Outside weekly maintenance windows (Wed & Sun, 2 and 4-8 a.m.)",
        "type": "run-schedule",
        "data": {
            "weekday": [ 3, 7 ],
            "hour": [ 2, { "lower": 4, "upper": 7 } ],
            "overlap": true
            "invert": true
        }
    }



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``test`` - Check Test Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**NOTE:  This limit type is considered deprecated and will be removed
in a future release.  Use the ``jq`` limit instead.** 

The ``test`` limit compares the parameters of a proposed test against
a template containing acceptable values.

Its ``data`` is an object containing the following pairs:

- ``test`` - A string specifying the test type.  Proposed tests not
  of this type will fail this limit.
- ``limit`` - A JSON object consisting of pairs for each test
  parameter.  The key used for each pair will match one of the test's
  parameters, which match the names of the command-line interface's
  long-form option switches.  (A list for a given test can be
  retrieved by running ``pscheduler task TEST-NAME --help``, where
  ``TEST-NAME`` is the name of the test.)  The value and the value is
  a limit of the appropriate type for that parameter.  See *Limit
  Types* for further details.

For example::

    {
        "name": "throughput-udp",
        "description": "Limits for UDP throughput tests",
        "type": "test",
        "data": {
        "test": "throughput",
        "limit": {
            "duration": { "range": { "lower": "PT5S", "upper": "PT60S" } },
            "bandwidth": { "range": { "lower": "1", "upper": "50M" } },
            "udp": { "match": true }
        }
    }




^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``test-type`` - Check Test Type
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``test-type`` limit compares the type of the proposed test to a
list of test types.

Its ``data`` is an object containing the following pair:

- ``types`` - An array of strings to be compared in deciding whether
  or not the limit passes.

For example::

    {
        "name": "inoccuous-tests",
        "description": "Tests that are harmless",
        "type": "test-type",
        "data": {
            "types": [ "idle", "latency", "rtt", "trace" ]
        }
    }




^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``url-fetch`` - Get a decision by fetching a URL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``url-fetch`` limit asks an external HTTP(S) server for a
pass/fail decision based on information passed in as parameters or
part of the URL.

If the ``success-only`` parameter is ``false``, the server must return
an HTTP status of ``200`` and a document of type ``applicastion/json``
containing an object with the following pairs:

- ``passed`` - A boolean indicating whether or not this limit should
  pass.
- ``message`` - An string containing a message that the server thinks
  is relevant about the transaction.  A simple ``OK`` is sufficient if
  ``passed`` is ``true``.

Any other HTTP status will be treated as an error.

The limit's ``data`` is an object containing the following pairs:

- ``url`` - The URL to be queried.  Note that this value is required
  even if ``url-transform`` (below) is being used to produce the URL.
  (An empty string is acceptable.)
- ``url-transform`` - An optional jq transform to alter the contents
  of the ``url`` parameter.  The returned value must be a string.  The
  proposed task may be accessed with ``.task`` and server hints are
  available by calling the ``hint($value)`` function.  The original
  URL can be accessed as ``.url``.
- ``bind`` - An optional string indicating the hostname or address to
  which the system should bind when connecting.
- ``verify-keys`` - An optional boolean indicating whether or not
  HTTPS protocol should verify the server's keys as part of the
  connection process.  If not provided, the default is ``true``.
- ``follow-redirects`` - An optional boolean indicating whether or not
  server-provided redirects should be followed.  If ``false``, a
  redirection will be treated as an error.  If not provided, the
  default is ``true``.
- ``headers`` - An optional JSON object containing headers to be sent
  to the server during the fetch.  If not provided, no headers will be
  added.
- ``headers-transform`` - An optional jq transform to alter the
  contents of the ``headers`` parameter by modifying ``.headers`` in
  place.  The transform should return everything provided as input.
  The proposed task may be accessed in ``.task`` and server hints
  are available by calling the ``hint($value)`` function.
- ``params`` - An optional JSON object containing parameters to be added to the 
- ``params-transform`` - An optional jq transform to alter the
  contents of the ``params`` parameter by modifying ``.params`` in
  place.  The transform should return everything provided as input.
  The proposed task may be accessed in ``.task`` and server hints
  are available by calling the ``hint($value)`` function.
- ``timeout`` - An optional ISO 8601 duration that determines how much
  time can elapse before the fetch is considered a failure and
  aborted.  The default is ``PT3S``.
- ``success-only`` - An optional boolean that, if ``true``, disregards
  any content returned by the server and treats the limit as having
  passed if the HTTP status is ``200`` or failed if it is ``404``.
  Any other error is treated as a failure and will be handled
  according to the state of ``fail-result``, described below.  If not
  provided, the default is ``false``.
- ``fail-result`` - An optional boolean that determines whether the
  limit passes or fails when the fetch returns any HTTP status other
  than ``200``.  If not provided, the default is ``false``.

For example::

    {
        "name": "server-says-ok",
        "description": "An external server approves of this task",
        "type": "url-fetch",
        "data": {
            "url": "https://decider.example.org/is-okay",
            "params": {
                "check-type": "whatever"
            },
            "params-transform": {
                "script": [
                    "  .params.requester = hint(\"requester\")",
                    "| .params.test  = .test.type"
                ]
            },
            "headers": {
                "Cache-Control": "no-cache"
            },
            "headers-transform": {
                "script": [
                    ".Authorizatiion = \"Basic \\($auth)\""
                ],
                "args": {
                    "auth": "bXVtYmxlbXVtYmxlbXVtYmxlCg=="
                }
            }

        }
    }





***********************************************
Applications: *To Whom do We Apply the Limits?*
***********************************************

The final phase of vetting a task or run is determining whether or not
its parameters make it permissible.  This is accomplished by
evaluating a series of *limit applications*, each of which ties a
classifier to a series of conditions which must be met before approval
can happen.

Each limit application is a JSON object consisting of the following:

- ``description`` - A human-readable string describing what the application does.
- ``classifier`` - A string naming a classifier to which the
  application should be applied.
- ``apply`` - An array of *limit requirements* (described in detail
  in *Applying Limit Requirements*, below), all of which must be
  satisfied for the application to have passed.
- ``invert`` - A boolean indicating that the application's result
  should be inverted (i.e., an application that passes should be
  treated as if it failed and one that fails should be treated as if
  it passed).
- ``stop-on-failure`` - A boolean indicating that if an application
  does not pass, the task or run should be denied without evaluating
  any further applications in the list.  This us useful for
  short-circuiting the process of denying requests you do not wish to
  service.

The system will evaluate each application in sequence.  (This process
is described in detail in *Applying Limit Requirements*, below.)  If
an application *passes* (i.e., its conditions will allow the task or
run to happen), the task or run is permitted.  If it *fails* and
``stop-on-failure`` is ``true``, it is denied.  If if fails and
``stop-on-failure`` is ``false``, the next application in the list is
evaluated.  If the end of the list is reached with no application
having passed, the task or run is denied.

For example::

    {
        ...
        "applications": [
            {
                "description": "Allow users on the local system to do anything",
                "classifier": "local-requester",
                "apply": [
                    {
                        "require": "all",
                        "limits": [ "always" ]
                    }
                ]
            },
            {
                "description": "What we allow guests to do",
                "classifier": "guests",
                "apply": [
                    {
                        "require": "any",
                        "limits": [
                            "innocuous-tests",
                            "guest-throughput",
                            "guest-rtt"
                        ]
                    }
                ],
                "stop-on-failure": true
            }
        ]
    }

The first application allows any requester in the ``local-requester``
classification to run anything because it applies the ``always``
limit, which always passes.  The second application alows requesters
in the ``guests`` classifier be runing any of the harmless tests or a
throughput or round-trip time test that meets predefined limits for
guests.  Failing both of those will result in denial because the
policy is to deny unless explicitly allowed.


---------------------------
Applying Limit Requirements
---------------------------

Each limit requirement is a JSON object containing the following:

- ``limits`` - An array of strings naming one or more limits to be
  considered when deciding if this limit requirement passes.
- ``require`` - A string specifying how many of the requirement's
  limits must pass for the requirement to be considered met.  Valid
  values are:

 - ``none`` - Consider the requirement met if none of the limits
   passes.
 - ``one`` - Consider the requirement met if exactly one of the
   limits passes.
 - ``any`` - Consider the requirement met if at least one of the
   limits passes.
 - ``all`` - Consider the requirement met only if all of the limits
   pass.



.. _config_pscheduler_limits-priorities:

*************************************************
Priorities: *Which Runs Happen and Which Do Not?*
*************************************************

Once a run has been vetted by the limit system, it can be assigned a
priority used in resolving conflicts with other runs scheduled at the
same time.  This applies to tests like ``throughput``, which are given
exclusive use of the system.  Tests which run in the background may be
given priorities but will be unaffected.

The priority value is an integer.  When comparing two or more runs,
the one wit the highest priority value will be run.  Nominally, the
dafault priority is ``0``, but any initial value can be configured.

During scheduling, pScheduler will make two attempts to schedule each
run within the allowed slip time.  The first is without regard to
priority as a way to avoid conflicts by adjusting the start time
within the allowed slip range.  If that fails, the second will be made
with the priority and disregarding the presence of lower-priority
runs, effectively preempting them.  If neither attempt succeeds, the
run will be posted as a non-starter.

Once a run is posted to the schedule, it remains there even if one
with a higher priority is scheduled.  At the scheduled start time, the
run will happen if there are no overlapping runs of higher priority.
Otherwise, the lower-priority run will be considered preempted in
favor of the higher-priority run.

-------------------
The Priority Script
-------------------

If the limit configuration contains a ``priority`` object, its
contents will be a standard jq transform as used elsewhere in
pScheduler.  If it does not, the priority system will be disabled and
the default of ``0`` will be assigned to all runs scheduled.  Note
that participants in multi-participant tests having a priority
configuration may still prioritize runs.

Input to the transform's script is a JSON object containing the
contents of the task as it was submitted to the server.  The
prioritizer adds a private pair for its own internal use (currently
named `__PRIOIRITIZER_PRIVATE__`) which should not be examined or
modified.

The jq script is passed the task in the same format as other jq
scripts used in the limit system.

Scripts will have the following functions available to get additional
information and make changes:

 - ``classifiers`` - Returns an array of the classifiers into which the node requesting the task were grouped (e.g., `[ "friendlies", "partners" ]`).
 - ``classifiers_has(value)`` - Returns a boolean indicating whether or not the string `value` is one of the classifiers.
 - ``default`` - Returns the default priority, normally ``0``.
 - ``requested`` - Returns the requested priority or ``null`` if no priority was requested.

The following functions can be used to make changes to the 

 - ``note(message)`` - Adds ``message`` to the diagnostics.
 - ``set(value; message)`` - Sets the priority to ``value`` and adds
   ``message`` to the diagnostics.
 - ``adjust(value; message)`` - Adjusts the priority by ``value``, which can be positive or negative, and adds ``message`` to the diagnostics.

The priority in effect at the end of the script will be assigned to
the run and any diagnostics produced will be stored.




.. _config_pscheduler_limits-check-validity:

***********************************************
Checking Limit Configuration Files for Validity
***********************************************

pScheduler includes a ``validate-limits`` command which can be used to
verify that a limit configuration is valid during development and
prior to installation on the system.

To validate limits in a file::

    % pscheduler validate-limits valid-limits.conf
    Limit configuration is valid.

    % pscheduler validate-limits invalid-limits.conf
    Invalid limit file: At /: Additional properties are not allowed (u'notvalid' were unexpected)

To validate the installed configuration, become ``root`` and execute::

    # pscheduler validate-limits
    Limit configuration is valid.

The command will exit with a status of ``0`` if the limit file was
valid or nonzero if it was not.  Errors will be sent to the standard
error and a message indicating that the configuration is valid will be
sent to the standard output if it is a TTY or the ``--quiet`` switch
is not in effect.

Details on command-line switches and sample invocations can be
obtained by running the command ``pscheduler validate-limits --help``.


****************
Standard Objects
****************

This section describes standard JSON objects used in the limit configuration.

Content in this section is forthcoming.

-----------------------------------------------
``StringMatch`` - String Matching Specification
-----------------------------------------------

``StringMatch`` is a JSON object containing the following pairs:


- ``style`` - A string specifying what type of matching should be
  done with the ``match`` string (see below).  Valid values are:

 - ``exact`` - The compared string must be exactly equal to ``match``.
 - ``contains`` - The ``match`` string must be contained somewhere
   within the compared string.
 - ``regex`` - The compared string must match the `Python 2 regular
   expression
   <https://docs.python.org/2/library/re.html#regular-expression-syntax>`_
   specified in ``match``.

- ``match`` - The string to be matched, subject to the specified ``style``.

For example, this ``StringMatch`` looks for an empty string or one
containing a vowel::

    {
        "style": "regex",
        "match": "(^$|[aeiou])"
    }





*********************
Limit Parameter Types
*********************

This section describes standard types of objects used by the ``test``
limit.

.. TODO: These need to be alphabetized.


-------------------------------------
``Boolean`` - Compares Boolean Values
-------------------------------------

- ``description`` - An optional human-readable description.
- ``match`` - A boolean value (``true`` or ``false``) to be matched

For example::

    {
        "match": false
    }


------------------------------------------
``Cardinal`` - Compares One-Based Integers
------------------------------------------

- ``description`` - An optional human-readable description.
- ``range`` - A range of ``Cardinal`` values to be matched.
- ``invert`` - An optional Boolean indicating that the result should
  be negated.

For example::

    {
        "range": { "lower": 5, "upper": 8 }
    }

--------------------------------------------------------
``CardinalList`` - Compares a List of One-Based Integers
--------------------------------------------------------

- ``description`` - An optional human-readable description.
- ``match`` - A list of ``Cardinal`` values to be matched.
- ``invert`` - An optional Boolean indicating that the result should
  be negated.

For example::

    {
        "match": [ 2, 4, 6, 8 ]
    }


-----------------------------------------------
``CardinalZero`` - Compares Zero-Based Integers
-----------------------------------------------

- ``description`` - An optional human-readable description.
- ``range`` - A range of ``CardinalZero`` values to be matched.
- ``invert`` - An optional Boolean indicating that the result should
  be negated.

For example::

    {
        "range": { "lower": 0, "upper": 19 }
    }

-------------------------------------------------------------
``CardinalZeroList`` - Compares a List of Zero-Based Integers
-------------------------------------------------------------

- ``description`` - An optional human-readable description.
- ``match`` - A list of ``CardinalZero`` values to be matched.
- ``invert`` - An optional Boolean indicating that the result should
  be negated.

For example::

    {
        "match": [ 0, 2, 4, 6, 8 ]
    }


------------------------------------------
``Duration`` - Compares ISO 8601 Durations
------------------------------------------

- ``description`` - An optional human-readable description.
- ``range`` - A range of ``Duration`` values to be matched.
- ``invert`` - An optional Boolean indicating that the result should
  be negated.

For example::

    {
        "range": { "lower": "PT15S", "upper": "PT1M" }
    }


--------------------------------------------------------
``SINumber`` - Compares Ranges of Integers with SI Units
--------------------------------------------------------

- ``description`` - An optional human-readable description.
- ``range`` - A range of ``SINumber`` values to be matched.
- ``invert`` - An optional Boolean indicating that the result should
  be negated.

For example::

    {
        "range": { "lower": "600K", "upper": "5G" }
    }


---------------------------------------------------
``IPVersion`` - Compares Internet Protocol Versions
---------------------------------------------------

- ``description`` - An optional human-readable description.
- ``match`` - An IP version to be matched
- ``invert`` - An optional Boolean indicating that the result should
  be negated.

For example::

    {
        "match": 6
    }


-----------------------------------------------------------
``IPVersionList`` - Compares a List of IP Protocol Versions
-----------------------------------------------------------

- ``description`` - An optional human-readable description.
- ``enumeration`` - A list of ``IPVersion`` values to be matched.
- ``invert`` - An optional Boolean indicating that the result should
  be negated.

For example::

    {
        "enumeration": [ 4, 6 ]
    }


----------------------------------------------------------
``Probability`` - Compares Ranges of Decimal Probabilities
----------------------------------------------------------

- ``description`` - An optional human-readable description.
- ``range`` - A range of ``Probability`` values to be matched.
- ``invert`` - An optional Boolean indicating that the result should
  be negated.

For example::

    {
        "range": { "lower": 0.25, "upper": 1.0 }
    }


-----------------------------
``String`` - Compares Strings
-----------------------------

- ``description`` - An optional human-readable description.
- ``match`` - A ``StringMatch`` object.  (See *Standard Objects*, above.)
- ``invert`` - An optional Boolean indicating that the result should
  be negated.

For example::

    {
        "match": {
            style": "regex",
            "match": "platypus",
            "invert": true
        }
    }

Note that it is possible to have ``invert`` in both the limit and the
``match`` ``StringMatch`` object.
