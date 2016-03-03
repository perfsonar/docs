************************************************************
Lookup Service Registration Daemon Configuration File
************************************************************

Overview
========

The file *lsregistrationdaemon.conf* is used to define what gets registered into the lookup service. The file allows a degree of flexibility in what is manually defined versus what is automatically discovered. In most cases, the defaults of this file will be suitable and you should not need to make any changes. Some situations where you might want to edit this file though are (this is not an exhaustive list):

* You have a private lookup service and would like to only register to that service. See :ref:`config_ls_registration-ls_instance`
* You have a host with multiple network interfaces and would like to choose the interface on which a particular service or set of services run
* You are not running a Toolkit (and thus don't have the web UI) and would like to set location information, community tags or other values
* You wish to override the auto-discovered defaults for one reason or another (e.g. maybe they are not correct or you would like to provide more detail)

The basic structure of the file is as follows:

* A collection of top-level directives to control things like :ref:`lookup service communication <config_ls_registration-ls_comm>` and :ref:`how the daemon process runs <config_ls_registration-daemon>`
* A list of :ref:`site <config_ls_registration-site>` directives that group together elements with a common set of parameters
* A list of :ref:`host <config_ls_registration-host>` directives within those sites that represent the host to be registered. If the host in question is the host on which the LS Registration Daemon is running, than many of the values can be auto-discovered. 
* A list of :ref:`service <config_ls_registration-service>` directives within those hosts that represent the services to be registered. 

The *lsregistrationdaemon.conf* has the feature that almost any directive can be defined at a higher level in the configuration hierarchy and be inherited by all the descendents. For example, one can define the :ref:`latitude <config_ls_registration-latitude>` and :ref:`longitude <config_ls_registration-longitude>` directives at the top-level of the file. All registered hosts and services will in turn inherit these properties. In contrast, you can define them directly in each host directive if you want each individual host to have different values. You can even define both and have the more specific values in the host directive override the ones defined at a higher level in the hierarchy. 

With these items in mind the remainder of this section contains a full reference of the options available in the *lsregistrationdaemon.conf* file. 




.. _config_ls_registration-ls_comm:

Lookup Service Communication
============================

.. _config_ls_registration-check_interval:

check_interval Directive
------------------------
:Description: The number of seconds in between checking and renewing a record in the lookup service
:Syntax: ``check_interval SECONDS``
:Contexts: top level
:Occurrences:  Exactly one
:Default: 3600
:Compatibility: 3.3 and later

.. _config_ls_registration-ls_instance:

ls_instance Directive
----------------------
:Description: The URL of the lookup service with which to register. If you are using a  private lookup service, you must set the URL here.
:Syntax: ``ls_instance URL``
:Contexts: top level
:Occurrences:  Exactly one
:Default: Chooses closest server in terms of round-trip time from the `bootstrap file <http://ps-west.es.net:8096/lookup/activehosts.json>`_
:Compatibility: 3.3 and later

.. _config_ls_registration-server_flap_threshold:

server_flap_threshold Directive
--------------------------------
:Description: If no :ref:`ls_instance <config_ls_registration-ls_instance>` is set, the the default behavior is to use the lookup service that is a) reachable and b) has the shortest round-trip-time. It's possible due to outages, network changes, new lookup services in the bootstrap, etc the chosen lookup service will change over time. The daemon checks to see which lookup service to use every :ref:`check interval <config_ls_registration-check_interval>`. Rather than immediately changing, this value sets how many times a new lookup service must be returned before your daemon will switch to using it. This prevents frequent *flapping* between lookup services. 
:Syntax: ``server_flap_threshold NUMBER``
:Contexts: top level
:Occurrences:  Exactly one
:Default: 3
:Compatibility: 3.4 and later


.. _config_ls_registration-autodiscovery:

Auto-discovery
====================

.. _config_ls_registration-autodiscover:

autodiscover Directive
----------------------
:Description: Indicates whether we want to automatically determine the value of any property not manually set in this file. If set to 1, it will try to determine as many fields as possible. If set to 0, all fields must be manually set. Manually set properties take precedence over any auto-discovered values.
:Syntax: ``autodiscover 0|1``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.4 and later

.. _config_ls_registration-allow_internal_addresses:

allow_internal_addresses Directive
----------------------------------
:Description: If :ref:`autodiscover <config_ls_registration-autodiscover>` is enabled, indicates whether private IP addresses (`RFC 1918 <https://tools.ietf.org/html/rfc1918>`_ and `RFC 4193 <https://tools.ietf.org/html/rfc4193>`_) can be used if discovered. Generally you will only want to set this if you are using a private lookup service.
:Syntax: ``allow_internal_addresses 0|1``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 and later

.. _config_ls_registration-disable_ipv4_reverse_lookup:

disable_ipv4_reverse_lookup Directive
--------------------------------------
:Description: If :ref:`autodiscover <config_ls_registration-autodiscover>` is enabled, any IPv4 address found will lead to an attempt to discover a DNS name via a reverse DNS query. This disables that reverse lookup and any value that would have used the discovered hostname will use the raw IPv4 address instead. 
:Syntax: ``disable_ipv4_reverse_lookup 0|1``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 and later


.. _config_ls_registration-disable_ipv6_reverse_lookup:

disable_ipv6_reverse_lookup Directive
--------------------------------------
:Description: If :ref:`autodiscover <config_ls_registration-autodiscover>` is enabled, any IPv6 address found will lead to an attempt to discover a DNS name via a reverse DNS query. This disables that reverse lookup and any value that would have used the discovered hostname will use the raw IPv6 address instead. 
:Syntax: ``disable_ipv6_reverse_lookup 0|1``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 and later

disabled Directive
------------------
:Description: Disables registration of the enclosing block and any sub-blocks.
:Syntax: ``disabled 0|1``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 and later

force_up_status Directive
-------------------------
:Description: Skips any automatic checks to see if a service is running and registers the record to the lookup service regardless of whether the item being registered is actually running or not.
:Syntax: ``force_up_status 0|1``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 and later


is_local Directive
-------------------------
:Description: Indicates that the service runs on the same machine as the LS registration Daemon. This must be set for most autodiscover functionality to work, especially as pertains to hosts. 
:Syntax: ``is_local 0|1``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or one
:Default: 0
:Compatibility: 3.3 and later

primary_interface Directive
----------------------------
:Description: Indicates the primary interface to use. When set, autodiscover will only register information for this interface when determining a :ref:`service <config_ls_registration-service>` address 
:Syntax: ``primary_interface IFNAME``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or one
:Default: First interface encountered with an address
:Compatibility: 3.4 and later

.. _config_ls_registration-service_template:

service_template Directive
--------------------------
:Description: A set of common parameters to be used by any :ref:`service <config_ls_registration-service>` that :ref:`inherits <config_ls_registration-inherits>` this template
:Syntax: ``<service_template TEMPLATENAME>...</service_template>``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or More
:Default: N/A
:Compatibility: 3.4 and later


.. _config_ls_registration-location:

Location and Contact Information
================================

.. _config_ls_registration-administrator:

administrator Directive
--------------------------
:Description: A person responsible for managing the  entity to be registered. See :ref:`config_ls_registration-administrators` for more information.
:Syntax: ``<administrator>...</administrator>``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or More
:Default: N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-city:

city Directive
--------------------------
:Description: The city in which the entity to be registered resides
:Syntax: ``city CITY``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-country:

country Directive
--------------------------
:Description: The `ISO 3166 <http://www.iso.org/iso/home/standards/country_codes.htm#2012_iso3166-2>`_ two-letter country code for the country in which the entity to be registered resides
:Syntax: ``country COUNTRY``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-domain:

domain Directive
--------------------------
:Description: The administrative domain in which the entity to be registered resides. Usually expressed as a DNS name (e.g. perfsonar.net).
:Syntax: ``domain DOMAIN``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-latitude:

latitude Directive
--------------------------
:Description: The latitude of the entity to be registered. Specified as a positive (north of the equator) or negative (south of the equator) decimal.
:Syntax: ``latitude LATITUDE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-longitude:

longitude Directive
--------------------------
:Description: The longitude of the entity to be registered. Specified as a positive (east of the prime meridian) or negative (west of the prime meridian) decimal.
:Syntax: ``longitude LONGITUDE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-region:

region Directive
--------------------------
:Description: The country specific region. For example, in the U.S. this value corresponds to the state. It should be the two-letter abbreviation if applicable. 
:Syntax: ``region REGION``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later


.. _config_ls_registration-site:

site Directive
------------------------
:Description: A grouping of elements that have similar configured properties, be it location, autodiscover settings or otherwise. See :ref:`config_ls_registration-sites` for more information.
:Syntax: ``<site>...</site>``
:Contexts: top level
:Occurrences:  Zero or More
:Default: N/A
:Default (Autodiscover): N/A

.. _config_ls_registration-zip_code:

zip_code Directive
--------------------------
:Description: The country specific postal code of the location where the entity to be registered resides.
:Syntax: ``zip_code ZIPCODE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-administrators:

Administrators
==============

.. _config_ls_registration-admin_name:

name Directive
--------------------------
:Description: The full name of the administrator. Either this field or :ref:`email <config_ls_registration-email>` is required.
:Syntax: ``name NAME``
:Contexts: :ref:`administrator <config_ls_registration-administrator>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-email:

email Directive
--------------------------
:Description: The email address of the administrator. Either this field or :ref:`name <config_ls_registration-admin_name>` is required.
:Syntax: ``email EMAIL``
:Contexts: :ref:`administrator <config_ls_registration-administrator>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-organization:

organization Directive
--------------------------
:Description: The organization to which the administrator belongs
:Syntax: ``organization ORGANIZATION``
:Contexts: :ref:`administrator <config_ls_registration-administrator>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-phone:

phone Directive
--------------------------
:Description: The phone number of the administrator
:Syntax: ``phone PHONE``
:Contexts: :ref:`administrator <config_ls_registration-administrator>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-sites:

Sites
======

.. _config_ls_registration-host:

host Directive
------------------------
:Description: A host to be registered. See :ref:`config_ls_registration-hosts` for more details.
:Syntax: ``<host>...</host>``
:Contexts: :ref:`site <config_ls_registration-site>`
:Occurrences:  Zero or More
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-site_name:

site_name Directive
------------------------
:Description: The name of the site
:Syntax: ``site_name NAME``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-site_project:

site_project Directive
------------------------
:Description: A community string or project string to be registered. Often used as a way to define custom tags for registered entities. 
:Syntax: ``site_name NAME``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or More
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-hosts:

Hosts
=====

.. _config_ls_registration-access_policy:

access_policy Directive
------------------------
:Description: Indicates who may access this host to run tests. Valid values are **public** (anyone can access), **private** (only the owner's local network can access), **research-education** (only those coming from R&E networks may access) or **limited** (some combination of the others, you should provide more detail in :ref:`access_policy_notes <config_ls_registration-access_policy_notes>`).
:Syntax: ``access_policy POLICY``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.5 and later

.. _config_ls_registration-access_policy_notes:

access_policy_notes Directive
-----------------------------
:Description: A human-readable description of the :ref:`access_policy <config_ls_registration-access_policy>`. For example "Authenticate using username and password". There is no defined form for this field and is intended as a way to provide additional information to those looking at the record. 
:Syntax: ``access_policy_notes NOTES``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.5 and later

.. _config_ls_registration-autodiscover_interfaces:

autodiscover_interfaces Directive
---------------------------------
:Description: Indicates whether you want to autodiscover the list of interfaces on the host. Enabled if :ref:`config_ls_registration-autodiscover` is set. Disabling this with :ref:`config_ls_registration-autodiscover` enabled will turn-off interface discover but still allow other fields to be discovered. 
:Syntax: ``autodiscover_interfaces 0|1``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: The value of :ref:`config_ls_registration-autodiscover`
:Default (Autodiscover): N/A
:Compatibility: 3.4 and later

.. _config_ls_registration-bundle_type:

bundle_type Directive
-----------------------------
:Description: The type of perfSONAR install. Examples include *test-point*, *perfsonar-core*, *perfsonar-complete*, and *perfsonar-toolkit*
:Syntax: ``bundle_type TYPE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The contents of */var/lib/perfsonar/bundles/bundle_type*
:Compatibility: 3.5 and later

.. _config_ls_registration-bundle_version:

bundle_version Directive
-----------------------------
:Description: The version of the :ref:`bundle <config_ls_registration-bundle_type>` installed
:Syntax: ``bundle_version VERSION``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The contents of */var/lib/perfsonar/bundles/bundle_version*
:Compatibility: 3.5 and later

.. _config_ls_registration-host_name:

host_name Directive
-----------------------------
:Description: A DNS name (preferably) or IP that identifies the host
:Syntax: ``host_name NAME``
:Contexts: :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The DNS hostname that matches a reverse lookup of the auto-discovered address of the host.
:Compatibility: 3.4 and later

.. _config_ls_registration-interface:

interface Directive
-----------------------------
:Description: Represents a manually defined interface on the host. See :ref:`config_ls_registration-interfaces` for more details.
:Syntax: ``<interface>...<interface>``
:Contexts: :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or More
:Default: N/A
:Default (Autodiscover): The list of interfaces on the host as reported by *ifconfig*
:Compatibility: 3.4 and later

.. _config_ls_registration-is_virtual_machine:

is_virtual_machine Directive
-----------------------------
:Description: Indicates if this host is a virtual machine (VM) as opposed to a physical host 
:Syntax: ``is_virtual_machine 0|1``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.5 and later

.. _config_ls_registration-memory:

memory Directive
-----------------------------
:Description: The amount of memory on the host appended with the units (e.g. 1024MB, 1GB)
:Syntax: ``memory MEMORY``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The total system memory in MB
:Compatibility: 3.4 and later

.. _config_ls_registration-os_kernel:

os_kernel Directive
-----------------------------
:Description: The kernel and version running on the host.
:Syntax: ``os_kernel KERNEL``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The OS name and version output separated by a space from */etc/redhat-release*, */etc/os_version* or */etc/debian_version* depending on the OS.
:Compatibility: 3.4 and later

.. _config_ls_registration-os_name:

os_name Directive
-----------------------------
:Description: The name of the operating system (e.g. CentOS, Debian, etc).
:Syntax: ``os_name NAME``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The OS name from */etc/redhat-release*, */etc/os_version* or */etc/debian_version* depending on the OS.
:Compatibility: 3.4 and later

.. _config_ls_registration-os_version:

os_version Directive
-----------------------------
:Description: The version of the operating system.
:Syntax: ``os_version VERSION``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The OS version from */etc/redhat-release*, */etc/os_version* or */etc/debian_version* depending on the OS.
:Compatibility: 3.4 and later

.. _config_ls_registration-processor_cores:

processor_cores Directive
-----------------------------
:Description: The number of cores on the machine's processor(s)
:Syntax: ``processor_cores CORES``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The *CPU(s)* as reported by lscpu
:Compatibility: 3.4 and later

.. _config_ls_registration-processor_count:

processor_count Directive
-----------------------------
:Description: The number processors
:Syntax: ``processor_count COUNT``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The *Socket(s)* as reported by lscpu
:Compatibility: 3.4 and later

.. _config_ls_registration-processor_speed:

processor_speed Directive
-----------------------------
:Description: The processor speed with units at the end of value (e.g. 2400MHz, 2.4 GHz)
:Syntax: ``processor_speed SPEED``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The *CPU MHz* as reported by lscpu
:Compatibility: 3.4 and later

.. _config_ls_registration-processor_cpuid:

processor_cpuid Directive
-----------------------------
:Description: A human readable name and description of your processor
:Syntax: ``processor_cpuid DESCRIPTION``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The *model name* from */proc/cpuinfo*
:Compatibility: 3.5 and later

.. _config_ls_registration-role:

role Directive
-----------------------------
:Description: The type of host. Valid values are zero or more of the following *nren*, *regional*, *site-border*, *site-internal*, *science-dmz*, *exchange-point*, *test-host*, *default-path*, *backup-path*
:Syntax: ``role ROLE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or More
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.5 and later

.. _config_ls_registration-service:

service Directive
------------------------
:Description: A service running on the host. See :ref:`config_ls_registration-services` for more details. 
:Syntax: ``<service>...</service>``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or More
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-tcp_autotune_max_buffer_recv:

tcp_autotune_max_buffer_recv Directive
--------------------------------------
:Description: The maximum receive buffer autotuning will calculate 
:Syntax: ``tcp_autotune_max_buffer_recv SIZE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): *net.ipv4.tcp_rmem* as reported by sysctl
:Compatibility: 3.4 and later

.. _config_ls_registration-tcp_autotune_max_buffer_send:

tcp_autotune_max_buffer_send Directive
--------------------------------------
:Description: The maximum send buffer autotuning will calculate 
:Syntax: ``tcp_autotune_max_buffer_send SIZE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): *net.ipv4.tcp_wmem* as reported by sysctl
:Compatibility: 3.4 and later

.. _config_ls_registration-tcp_cc_algorithm:

tcp_cc_algorithm Directive
--------------------------------------
:Description: The TCP congestion control algorithm configured for the host
:Syntax: ``tcp_cc_algorithm SIZE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): *net.ipv4.tcp_congestion_control* as reported by sysctl
:Compatibility: 3.4 and later

.. _config_ls_registration-tcp_max_backlog:

tcp_max_backlog Directive
--------------------------------------
:Description: The length of the processor input queue
:Syntax: ``tcp_max_backlog SIZE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): *net.core.netdev_max_backlog* as reported by sysctl
:Compatibility: 3.4 and later

.. _config_ls_registration-tcp_max_buffer_recv:

tcp_max_buffer_recv Directive
--------------------------------------
:Description: The maximum size of TCP buffers for receiving
:Syntax: ``tcp_max_buffer_recv SIZE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): *net.core.rmem_max* as reported by sysctl
:Compatibility: 3.4 and later

.. _config_ls_registration-tcp_max_buffer_send:

tcp_max_buffer_send Directive
--------------------------------------
:Description: The maximum size of TCP buffers for sending
:Syntax: ``tcp_max_buffer_send SIZE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): *net.core.wmem_max* as reported by sysctl
:Compatibility: 3.4 and later

.. _config_ls_registration-tcp_max_achievable:

tcp_max_achievable Directive
--------------------------------------
:Description: The known maximum achievable throughput on this host. This is a manually set value based on experience with the hardware. For example, some low cost hosts may have a 1Gbps network interface, but processor  limitations prevent it from ever achieving more than 500Mbps. Should be value followed by units (e.g. 1024Mbps, 1Gbps)
:Syntax: ``tcp_max_achievable BANDWIDTH``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.5 and later
        
        
.. _config_ls_registration-interfaces:

Interfaces
==========

.. _config_ls_registration-address:

address Directive
------------------------
:Description: The IP address or DNS name of the interface. 
:Syntax: ``address ADDRESS``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`
:Occurrences:  Zero or More
:Default: N/A
:Default (Autodiscover): The IP address(es) as reported by *ifconfig*
:Compatibility: 3.3 and later

.. _config_ls_registration-capacity:

capacity Directive
------------------------
:Description: The maximum throughput of the interface in bps.
:Syntax: ``capacity CAPACITY``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The speed as reported by */sys/class/net/IF_NAME/speed*. If not available, the speed as reported by *ethtool*. 
:Compatibility: 3.3 and later

.. _config_ls_registration-if_name:

if_name Directive
------------------------
:Description: The interface name (e.g. eth1, em0)
:Syntax: ``if_name NAME``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The interface name as reported by *ifconfig*
:Compatibility: 3.3 and later

.. _config_ls_registration-if_type:

if_type Directive
------------------------
:Description: The type of interface (e.g. Ethernet)
:Syntax: ``if_type TYPE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-mac_address:

mac_address Directive
------------------------
:Description: The MAC address of the interface
:Syntax: ``mac_address ADDRESS``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The MAC address as reported by the *Net::Interface* perl module
:Compatibility: 3.3 and later

.. _config_ls_registration-mtu:

mtu Directive
------------------------
:Description: The MTU of the interface in bytes
:Syntax: ``mtu MTU``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): The MTU as reported by the *Net::Interface* perl module
:Compatibility: 3.3 and later

.. _config_ls_registration-subnet:

subnet Directive
------------------------
:Description: The IP subnet mask of the interface.
:Syntax: ``subnet MASK``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

urn Directive
------------------------
:Description: A URN used to identify his interface in an external topology description format
:Syntax: ``urn URN``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`interface <config_ls_registration-interface>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-services:

Services
========

.. _config_ls_registration-service-address:

address Directive
------------------------
:Description: The IP address or DNS name on which the service listens
:Syntax: ``address ADDRESS``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or More
:Default: N/A
:Default (Autodiscover): The auto-discovered primary address
:Compatibility: 3.3 and later

.. _config_ls_registration-authentication_type:

authentication_type Directive
------------------------------
:Description: The method with which one may authenticate to this service. 
:Syntax: ``authentication_type TYPE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or More
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-autodiscover_addresses:

autodiscover_addresses Directive
---------------------------------
:Description: Indicates whether you want to autodiscover the address on which the service listens. Enabled if :ref:`config_ls_registration-autodiscover` is set. Disabling this with :ref:`config_ls_registration-autodiscover` enabled will turn-off address discovery but still allow other fields to be discovered. 
:Syntax: ``autodiscover_addresses 0|1``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or One
:Default: The value of :ref:`config_ls_registration-autodiscover`
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-inherits:

inherits Directive
---------------------------------
:Description: Indicates the :ref:`service template <config_ls_registration-service_template>` from which to inherit properties
:Syntax: ``inherits TEMPLATENAME``
:Contexts: :ref:`service <config_ls_registration-service>`
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-port:

port Directive
---------------------------------
:Description: The port on which the service listens
:Syntax: ``port NUMBER``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or One
:Default: Depends on the service :ref:`type <config_ls_registration-service-type>`
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-service_locator:

service_locator Directive
---------------------------------
:Description: The URL where the service can be contacted
:Syntax: ``service_locator URL``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or One
:Default: Built from the :ref:`address <config_ls_registration-service-address>` and :ref:`port <config_ls_registration-port>`
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-service_name:

service_name Directive
---------------------------------
:Description: The name of the service as a human-readable description
:Syntax: ``service_name NAME``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or One
:Default: The :ref:`site name <config_ls_registration-site_name>` and service :ref:`type <config_ls_registration-service-type>` separated by a space
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-service_version:

service_version Directive
---------------------------------
:Description: The version of the service
:Syntax: ``service_version VERSION``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`, :ref:`service_template <config_ls_registration-service_template>`
:Occurrences:  Zero or One
:Default: Service dependent
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

.. _config_ls_registration-service-type:

type Directive
---------------------------------
:Description: The type of the service. See description below for valid types.
:Syntax: ``type TYPE``
:Contexts: top level, :ref:`site <config_ls_registration-site>`, :ref:`host <config_ls_registration-host>`, :ref:`service <config_ls_registration-service>`
:Occurrences:  Zero or One
:Default: Service dependent
:Default (Autodiscover): N/A
:Compatibility: 3.3 and later

Valid values for this field are currently:

* bwctl
* dashboard
* gridftp
* ma
* meshconfig
* mp-bwctl
* mp-owamp
* ndt
* npad
* owamp
* phoebus
* ping
* reddnet
* traceroute

.. _config_ls_registration-service_type:

Service Type-Specific Parameters
================================

.. _config_ls_registration-autodiscover_ca_file:

autodiscover_ca_file Directive
---------------------------------
:Description: For autodiscovery of information that requires contacting an HTTPS service, this is the path to the CA file that can be used to verify the identity of the server
:Syntax: ``autodiscover_ca_file FILE``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *ma* or *meshconfig*
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.4 and later

.. _config_ls_registration-autodiscover_ca_path:

autodiscover_ca_path Directive
---------------------------------
:Description: For autodiscovery of information that requires contacting an HTTPS service, this is the path to a directory of CA files that can be used to verify the identity of the server when using HTTPS
:Syntax: ``autodiscover_ca_path DIR``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *ma* or *meshconfig*
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.4 and later

.. _config_ls_registration-autodiscover_fields:

autodiscover_fields Directive
----------------------------------------
:Description: Indicates that a mesh should be queried and the administrators and test members should be automatically detected
:Syntax: ``autodiscover_fields 0|1``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *meshconfig*
:Occurrences:  Zero or One
:Default: 0
:Default (Autodiscover): N/A

.. _config_ls_registration-autodiscover_indices:

autodiscover_indices Directive
---------------------------------
:Description: Indicates whether or not to try to index results. Currently only traceroute data is supported. This will look at traceroute results in  :ref:`autodiscover_index_time_range <config_ls_registration-autodiscover_index_time_range>` and report unique hops.
:Syntax: ``autodiscover_indices 0|1``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *ma*
:Occurrences:  Zero or One
:Default: The value of :ref:`autodiscover_tests <config_ls_registration-autodiscover_tests>`
:Default (Autodiscover): N/A
:Compatibility: 3.4 and later


.. _config_ls_registration-autodiscover_index_time_range:

autodiscover_index_time_range Directive
----------------------------------------
:Description: If :ref:`autodiscover_indices <config_ls_registration-autodiscover_indices>` is enabled, the time range to query the MA for results to index in seconds.
:Syntax: ``autodiscover_index_time_range 0|1``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *ma*
:Occurrences:  Zero or One
:Default: 604800
:Default (Autodiscover): N/A
:Compatibility: 3.4 and later

.. _config_ls_registration-autodiscover_tests:

autodiscover_tests Directive
----------------------------------------
:Description: If enabled, contacts the MA service to be registered and automatically generates a list of tests to register based on the metadata returned.
:Syntax: ``autodiscover_tests 0|1``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *ma*
:Occurrences:  Zero or One
:Default: 0
:Default (Autodiscover): N/A

.. _config_ls_registration-autodiscover_timeout:

autodiscover_timeout Directive
----------------------------------------
:Description: If :ref:`autodiscover_fields <config_ls_registration-autodiscover_fields>` is enabled, the time to wait in seconds for results when querying the mesh before giving an error.
:Syntax: ``autodiscover_timeout TIMEOUT``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *meshconfig*
:Occurrences:  Zero or One
:Default: 60
:Default (Autodiscover): N/A

.. _config_ls_registration-autodiscover_url:

autodiscover_url Directive
----------------------------------------
:Description: The URL to contact to autodiscover details about an HTTP service
:Syntax: ``autodiscover_url URL``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *ma* or *meshconfig*
:Occurrences:  Zero or One
:Default: The value of :ref:`config_ls_registration-service_locator`
:Default (Autodiscover): N/A

.. _config_ls_registration-autodiscover_verify_hostname:

autodiscover_verify_hostname Directive
---------------------------------------
:Description: For autodiscovery of information that requires contacting an HTTPS service, indicates whether the hostname must match the certificate common name
:Syntax: ``autodiscover_verify_hostname 0|1``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *ma* or *meshconfig*
:Occurrences:  Zero or One
:Default: 0
:Default (Autodiscover): N/A
:Compatibility: 3.4 and later

.. _config_ls_registration-autodiscover_webui_url:

autodiscover_webui_url Directive
---------------------------------
:Description: Indicates whether the dashboard web interface URL should be auto-discovered
:Syntax: ``autodiscover_webui_url 0|1``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *dashboard*
:Occurrences:  Zero or One
:Default: 0
:Default (Autodiscover): N/A
:Compatibility: 3.4 and later

.. _config_ls_registration-http_port:

http_port Directive
---------------------------------
:Description: The port where a web service listens for HTTP connections 
:Syntax: ``http_port PORT``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *dashboard*, *ma*, *meshconfig*, *mp-bwctl*, *mp-owamp*
:Occurrences:  Zero or One
:Default: 80 (unless :ref:`config_ls_registration-https_port` set, then this is left unset if no manual value provided)
:Default (Autodiscover): N/A
:Compatibility: 3.4 and later

.. _config_ls_registration-https_port:

https_port Directive
---------------------------------
:Description: The port where a web service listens for HTTPS connections 
:Syntax: ``https_port PORT``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *dashboard*, *ma*, *meshconfig*, *mp-bwctl*, *mp-owamp*
:Occurrences:  Zero or One
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.4 and later

.. _config_ls_registration-url_path:

url_path Directive
---------------------------------
:Description: The path portion of the URL where a web service runs
:Syntax: ``url_path PATH``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *dashboard*, *ma*, *meshconfig*, *mp-bwctl*, *mp-owamp*
:Occurrences: Exactly one
:Default: N/A
:Default (Autodiscover): N/A
:Compatibility: 3.4 and later

.. _config_ls_registration-webui_url:

webui_url Directive
---------------------------------
:Description: The URL of a web interface associated with a service
:Syntax: ``webui_url URL``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *dashboard*
:Occurrences:  Zero or One
:Default: The manually set address and port with path */maddash-webui*
:Default (Autodiscover): The auto-detected address and port with path */maddash-webui*
:Compatibility: 3.4 and later

.. _config_ls_registration-skip_autodiscover_admins:

skip_autodiscover_admins Directive
-----------------------------------
:Description: If enabled, does not automatically register administrators found in the mesh file
:Syntax: ``skip_autodiscover_admins 0|1``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *meshconfig*
:Occurrences:  Zero or One
:Default: 0
:Default (Autodiscover): N/A
:Compatibility: 3.4 and later

.. _config_ls_registration-test:

test Directive
-----------------------------------
:Description: Represents a measurement stored in an archive. See :ref:`config_ls_registration-tests` for more details.
:Syntax: ``<test>...</test>``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *ma*
:Occurrences:  Zero or More
:Default: N/A
:Default (Autodiscover): The tests found by querying the MA metadata

.. _config_ls_registration-test_member:

test_member Directive
-----------------------------------
:Description: An IP address or hostname that is included in a mesh
:Syntax: ``test_member ADDRESS``
:Contexts: :ref:`service <config_ls_registration-service>` where :ref:`type <config_ls_registration-service-type>` is *meshconfig*
:Occurrences:  Zero or More
:Default: N/A
:Default (Autodiscover): The members found by querying the MeshConfig file

.. _config_ls_registration-tests:

Measurement Archive Tests
=========================

.. _config_ls_registration-event_type:

event_type Directive
-----------------------------------
:Description: The type of test as defined `here <http://software.es.net/esmond/perfsonar_client_rest.html#full-list-of-event-types>`_.
:Syntax: ``event_type EVENTTYPE``
:Contexts: :ref:`test <config_ls_registration-test>`
:Occurrences:  One or More
:Default: N/A
:Default (Autodiscover): The list of event-types for a given test as reported by the queried MA

.. _config_ls_registration-destination:

destination Directive
-----------------------------------
:Description: The destination of the test as an IP address
:Syntax: ``destination IP``
:Contexts: :ref:`test <config_ls_registration-test>`
:Occurrences:  Exactly One
:Default: N/A
:Default (Autodiscover): The destination of a given test as reported by the queried MA

.. _config_ls_registration-ma_locator:

ma_locator Directive
-----------------------------------
:Description: The URL of the MA storing this test
:Syntax: ``ma_locator URL``
:Contexts: :ref:`test <config_ls_registration-test>`
:Occurrences:  One or More
:Default: N/A
:Default (Autodiscover): The URL of the queried MA

.. _config_ls_registration-measurement_agent:

measurement_agent Directive
-----------------------------------
:Description: The IP address of the test initiator
:Syntax: ``measurement_agent IP``
:Contexts: :ref:`test <config_ls_registration-test>`
:Occurrences:  Exactly one
:Default: N/A
:Default (Autodiscover): The measurement-agent of a given test as reported by the queried MA

.. _config_ls_registration-metadata_uri:

metadata_uri Directive
-----------------------------------
:Description: The URI used to access a particular test
:Syntax: ``metadata_uri URI``
:Contexts: :ref:`test <config_ls_registration-test>`
:Occurrences:  Exactly one
:Default: N/A
:Default (Autodiscover): The uri of a given test as reported by the queried MA

.. _config_ls_registration-result_index:

result_index Directive
-----------------------------------
:Description: In general, you will not manually set this value. A summarized value derived from the results of the test that can be searched by LS clients.
:Syntax: ``result_index VALUE``
:Contexts: :ref:`test <config_ls_registration-test>`
:Occurrences:  Zero or More
:Default: N/A
:Default (Autodiscover): Type dependent. For traceroute tests, a unique hop found in the results.

.. _config_ls_registration-source:

source Directive
-----------------------------------
:Description: The source of the test as an IP address
:Syntax: ``source IP``
:Contexts: :ref:`test <config_ls_registration-test>`
:Occurrences:  Exactly One
:Default: N/A
:Default (Autodiscover): The source of a given test as reported by the queried MA

.. _config_ls_registration-tool_name:

tool_name Directive
-----------------------------------
:Description: The name of the tool used to perform a measurement
:Syntax: ``tool_name TOOL``
:Contexts: :ref:`test <config_ls_registration-test>`
:Occurrences:  Exactly One
:Default: N/A
:Default (Autodiscover): The tool-name of a given test as reported by the queried MA


.. _config_ls_registration-daemon:

Misc. Daemon Settings
=====================

.. _config_ls_registration-client_uuid_file:

client_uuid_file Directive
-----------------------------------
:Description: The location of the file containing a UUID to be registered with each record in the *client-uuid* field. If the file does not exist it will be created and populated with a random UUID.
:Syntax: ``client_uuid_file FILE``
:Contexts: top level
:Occurrences:  Zero or One
:Default: */var/lib/perfsonar/lsregistrationdaemon/client_uuid*

.. _config_ls_registration-group:

group Directive
-----------------------------------
:Description: The group to run the daemon as. Overridden by the *--group* command-line switch. 
:Syntax: ``group GID``
:Contexts: top level
:Occurrences:  Zero or One
:Default: N/A

.. _config_ls_registration-ls_key_db:

ls_key_db Directive
-----------------------------------
:Description: The location of the `SQLite <https://www.sqlite.org>`_ database where registration keys are kept. Registration keys are assigned by the lookup service when a record is first created and are used for subsequent renewals.
:Syntax: ``ls_key_db DB``
:Contexts: top level
:Occurrences:  Zero or One
:Default: */var/lib/perfsonar/lsregistrationdaemon/lsKey.db*

.. _config_ls_registration-pidfile:

pidfile Directive
-----------------------------------
:Description: The PID file location. Overridden by the *--pidfile* command-line switch. 
:Syntax: ``pidfile FILE``
:Contexts: top level
:Occurrences:  Zero or One
:Default: */var/run/ls_registration_daemon.pid*

.. _config_ls_registration-user:

user Directive
-----------------------------------
:Description: The user to run the daemon as. Overridden by the *--user* command-line switch. 
:Syntax: ``user UID``
:Contexts: top level
:Occurrences:  Zero or One
:Default: N/A








