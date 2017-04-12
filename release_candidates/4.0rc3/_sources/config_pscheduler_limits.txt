=============================
Configuring pScheduler Limits
=============================

************
Introduction
************

pScheduler offers the ability to control what tasks may be run, by
whom and with what parameters.  This is achieved by writing and
installing a *limit configuration file*.

.. TODO: Write more.

Commented samples may be found in
``/usr/share/doc/pscheduler/limit-examples`` on systems with the
pScheduler bundle installed.



****************************
The Limit Configuration File
****************************

The limit configuration is stored in ``/etc/pscheduler/limits.conf``.

The file is `JavaScript Object Notation <http://www.json.org>`_ (JSON)
containing a single object with the four pairs shown here::

    {
        "#": "Skeletal pScheduler limit configuration",

        "identifiers": [ ... ],
        "classifications": [ ... ],
        "limits": [ ... ],
        "applications": [ ... ]
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

The first phase of vetting a task request is *idenification*, where
attributes of the arriving request are used to create a list of narrow
categories into which the requester fits.

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

For example, this identifier downloads ESNet's list of CIDRs for
research and education networks, updates it daily with four-hour
retries on failure and excludes the private networks defined by RFC
1918::

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



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``ip-reverse-dns`` - Identify Requesters By Host Name
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``ip-reverse-dns`` identifier attmpts to reverse-resolve the
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
        ...
    }


Note that the ``neutrals`` classification will include all requesters,
which makes it overlap with ``friendlies`` and ``hostiles``.  As will
be illustrated later, the narrower classifications can be used to
allow or deny tasks before the wider ones.



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
   Types*.)
 - ``data`` - A JSON object containing ``type``-specific data used in
   determining whether the task meets this limit.  (See *Limit
   Types*.)
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

The ``test`` limit compares the parameters of a proposed test against
a template containing acceptable values.

Its ``data`` is an object containing the following pairs:

 - ``test`` - A string specifying the test type.  Proposed tests not
   of this type will fail this limit.
 - ``limit`` - A JSON object consisting of pairs for each test
   parameter.  The key used for each pair will match one of the test's
   parameters.  The value and the value is a limit of the appropriate
   type for that parameter.  See *Limit Types* for further details.

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





************
Applications
************

.. TODO: Write this.

This section is forthcoming.





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




********************************
Installing a Limit Configuration
********************************

The limit configration is installed in ``/etc/pscheduler/limits.conf``
and must be readable by the ``pscheduler`` user.  The recommended file
attributes are owner ``root``, group ``pscheduler`` and permissions
`0644`.

The pScheduler server will automatically detect changes to the limit
configuration and put them into effect upon the arrival of the first
request that requires checking limits or 15 seconds, whichever is
longer.  Changes to the limit file are noted in the pScheduler log
(usually ``/var/log/pscheduler/pscheduler.log``), as are notifications
of problems.

If the configuration file does not exist, is removed or fails to load,
pScheduler will enforce no limits and grant every task request it
receives.  **For this reason, it is strongly recommended that
configurations be verified as described above before they are
installed.**


****************
Standard Objects
****************

This section describes standard JSON objects used in the limit configuration.

Content in this section is forthcoming.

.. TODO: StringMatch



***********
Limit Types
***********

This section describes standard types used objects used by the
``test`` limit.

Content in this section is forthcoming.

.. TODO: Write this.  See jsonval.py.

