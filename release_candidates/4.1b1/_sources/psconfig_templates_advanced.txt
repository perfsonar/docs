***************************************
Advanced pSConfig Templates
***************************************


.. _psconfig_templates_advanced-addresses:

Advanced ``addresses`` Options
=================================

.. _psconfig_templates_advanced-addresses-noagent:

Testing to Addresses without an Agent Reading Your Template
------------------------------------------------------------
If a particular *address* object is not controlled by a :doc:`pscheduler-agent <psconfig_pscheduler_agent>` that reads your template, then you should enable the ``no-agent`` property. An example is below::

    {
        "address": "thr1.perfsonar.net",
        "no-agent": true
    }

Keep in mind this property specifically refers to the :doc:`pscheduler-agent <psconfig_pscheduler_agent>`, not pScheduler itself. Whether or not pScheduler is required on both ends of a test is dependent on the test type and specification. For example, a multi-participant *throughput* test always requires pScheduler on both ends, even if one end does not have an agent reading the template. The same is true for most reverse tests. In some cases you can get around the reverse test issues if it is of a type such as *latencybg* that has an option that supports the :ref:`flip template variable <psconfig_templates_vars-flip>`.

.. note:: In general, when building groups it is recommended you use type *disjoint* and keep all the hosts with ``no-agent`` enabled in either the ``a-addresses`` or ``b-addresses``. While not strictly required, not only will an address pair where all the *address* objects have ``no-agent`` enabled be skipped, but mixing *address* objects with ``no-agent`` enabled and disabled in a *mesh* or the same side of a *disjoint* group can further complicate issues if you do not have detailed understanding of how a test works.

.. _psconfig_templates_advanced-addresses-disabled:

Disabling an Address
------------------------
If you want to temporarily suspend usage of an *address* object, you can set the ``disabled`` property::

    {
        "address": "thr1.perfsonar.net",
        "disabled": true
    }

If a disabled address is included in any *group* objects, the group will skip any generated pairs involving that address. You can think of this property as a way to "comment-out" all references to an *address* object since JSON does not natively support comments. It is most useful when you don't want to entirely delete an *address* but need to remove it from testing for some amount of time.

.. _psconfig_templates_advanced-addresses-pscheduler_address:

Using Non-Standard pScheduler Ports and Addresses
--------------------------------------------------
If you want to run a pScheduler server associated with a particular *address* object on a different port and/or an address different than the one indicated by the ``address`` property, there are two things you must do:

#. Set the ``pscheduler-address`` property of your *address* object
#. Include the :ref:`pscheduler_address template variable <psconfig_templates_vars-pscheduler_address>` in your test specification

The ``pscheduler-address`` property is an IP or hostname with an optional port specification. Examples below::

    "addresses": {
        "thr1": {
            "address": "thr1.perfsonar.net",
            "pscheduler-address": "thr1-mgt.perfsonar.net"
        },
        "thr2": {
            "address": "thr2.perfsonar.net",
            "pscheduler-address": "thr2.perfsonar.net:8080"
        },
        "thr3": {
            "address": "fd89:b4d9:341a:8465::1",
            "pscheduler-address": "[fd89:b4d9:341a:8465::1]:9090"
        }
    }

Generally, many test specifications have a ``source-node`` and/or ``dest-node`` property where you can use this value. Since it is dependent on the test type (of which pSConfig has no knowledge), explicitly setting these fields using the :ref:`pscheduler_address template variable <psconfig_templates_vars-pscheduler_address>` is required. The template variable has the convenient feature of falling back to the value of the ``address`` property if ``pscheduler-address`` is not set. This means that it is not required to set ``pscheduler-address`` for all *address* objects. An example test specification is shown below::

    {
      "type":"throughput",
      "spec":{
         "source":"{% address[0] %}",
         "dest":"{% address[1] %}",
         "source-node":"{% pscheduler_address[0] %}",
         "dest-node":"{% pscheduler_address[1] %}"
      }
   }

.. note:: If a test specification supports ``source-node``, ``dest-node`` or an equivalent option it is recommended you always set it and use the :ref:`pscheduler_address template variable <psconfig_templates_vars-pscheduler_address>` as the value. Given the ability to fallback, there is no harm in doing so and future-proofs your test definitions if an *address* object needs to set ``pscheduler-address`` in the future.

.. _psconfig_templates_advanced-addresses-lead_bind_address:

Controlling pScheduler Server Binding
--------------------------------------
For pScheduler servers running on a host with an advanced routing configuration, you may need to tell pScheduler to bind to a particular address when sending control traffic to another pScheduler server. pSConfig allows you to set this value with the ``lead-bind-address`` property of an *address* object. This property must be an IP or hostname. An example is below::

    {
        "address": "thr1.perfsonar.net",
        "lead-bind-address": "thr1-mgt.perfsonar.net"
    }

There are no further steps required to use this property. The :doc:`pscheduler-agent <psconfig_pscheduler_agent>` will automatically detect this value and pass it to pScheduler. 

.. note:: Often you only want to set this value when you are testing to a particular address. See :ref:`psconfig_templates_advanced-addresses-remote_addresses` for more information on this use case.

.. note:: There is also a :ref:`lead_bind_address template variable <psconfig_templates_vars-lead_bind_address>` but it is NOT required you use this anywhere for the ``lead-bind-address`` to be passed to pScheduler. The ``lead-bind-address`` is not part of the test specification but instead is a separate pScheduler field that the :doc:`pscheduler-agent <psconfig_pscheduler_agent>` knows how to interpret.

.. _psconfig_templates_advanced-addresses-remote_addresses:

Dynamic Address Properties with ``remote-addresses``
----------------------------------------------------------
As described in :doc:`psconfig_templates_intro`, *groups* combine addresses based on the type that (in the case of *mesh* and *disjoint* group types) leads to a pairing of addresses. In some cases we may want the properties of an address object to change based on the other address with which it has been paired. Examples include:

* **Environments where hosts communicate on private address space.** In particular if they communicate on an IPv4 /30 subnet where no other addresses are configured. This is common in software defined networks and certain VPN environments. In this case we may want to change the ``address`` property based on the remote address with which we are testing.

* **Environments where individual host pairs have special binding requirements due to routing restrictions.** In this case we can change the :ref:`lead-bind-address <psconfig_templates_advanced-addresses-lead_bind_address>` or :ref:`pscheduler-address <psconfig_templates_advanced-addresses-pscheduler_address>` properties based on the pairing.

We can use the ``remote-addresses`` property of an *address* object to build a map of properties to be used when paired with a given address object. Let's look at the example network below:

.. figure:: images/psconfig_templates_advanced_remote-network.png
    :align: center
    
    *A network of four hosts where host1 uses private addresses to communicate with each*

In the diagram, *host1* communicates with the other three hosts using a different private address with each. Below we define a *disjoint* group where *host1* tests to the other three and defines a ``remote-addresses`` definition in each *address* object::
    
   "addresses": {
        "host1": {
            "address": "host1.perfsonar.net",
            "remote-addresses": {
                "host2": {
                    "address": "10.1.1.1"
                },
                "host3": {
                    "address": "10.0.0.1"
                },
                "host4": {
                    "address": "10.2.2.1"
                }
            }
        },
        "host2": {
            "address": "host2.perfsonar.net",
            "remote-addresses": {
                "host1": {
                    "address": "10.1.1.2"
                }
            }
        },
        "host3": {
            "address": "host3.perfsonar.net",
            "remote-addresses": {
                "host1": {
                    "address": "10.0.0.2"
                }
            }
        },
        "host4": {
            "address": "host4.perfsonar.net",
            "remote-addresses": {
                "host1": {
                    "address": "10.2.2.2"
                }
            }
        }
    },
    
    "groups": {
        "example-group": {
            "type": "disjoint",
            "a-addresses": [
                { "name": "host1" }
            ],
            "b-addresses": [
                { "name": "host2" },
                { "name": "host3" },
                { "name": "host4" }
            ]
        }
    }

The ``remote-addresses`` is a JSON object where the properties are the names of other *address* objects. The value is a new *address* object where you can redefine the properties of an address. In the example, we simply define ``address`` but we could also define ``pscheduler-address``, ``lead-bind-address``, ``contexts``, ``_meta`` or most of the other *address* properties. That being said, this new address object has a few special features worth noting:

* An ``address`` property OR a ``labels`` property are required. This means that unlike the parent *address* object, an ``address`` property is not strictly required. See :ref:`psconfig_templates_advanced-addresses-labels` for a discussion on labels.
* If ``disabled`` or ``no-agent`` are set to ``true`` in the parent *address* object, then the address objects in ``remote-addresses`` will inherit these values and they cannot be overriden. If they are ``false`` or unspecified in the parent, a ``remote-addresses`` entry can set them to ``true`` to enable them for just that remote pairing. 
* You can not define the ``host`` property in a ``remote-addresses`` object. This object is considered to belong to the same host as the parent.
* Unless otherwise noted above, the objects in ``remote-addresses`` do not inherit values from the parent. For example, if you have ``pscheduler-address`` defined in parent and you want an object in ``remote-addresses`` to use the same ``pscheduler-address``, then you need to define it again it in the new object. 

When addresses are paired together by a group, agents will first look in the ``remote-addresses`` object for the name of the other address in the pair. If it finds one, it will use that address object instead of the default. If it does not find one, it will instead use the top-level address object and ignore ``remote-addresses``. Looking back at our example, the table below details the pairings generated and the values of the :ref:`address template variable <psconfig_templates_vars-address>`:

+--------------------+------------------+------------------+
| Address Pair Names | {% address[0] %} | {% address[1] %} |
+====================+==================+==================+
| host1, host2       | 10.1.1.1         | 10.1.1.2         |
+--------------------+------------------+------------------+
| host1, host3       | 10.0.0.1         | 10.0.0.2         |
+--------------------+------------------+------------------+
| host1, host4       | 10.2.2.1         | 10.2.2.2         |
+--------------------+------------------+------------------+
| host2, host1       | 10.1.1.2         | 10.1.1.1         |
+--------------------+------------------+------------------+
| host3, host1       | 10.0.0.2         | 10.0.0.1         |
+--------------------+------------------+------------------+
| host4, host1       | 10.2.2.2         | 10.2.2.1         |
+--------------------+------------------+------------------+

This introduces the basics of ``remote-addresses``, but there are still more cases to consider such as:

* What if we want an address pair to use different properties dependent on not just the other member in the pair but also the group it is in?
* What if we want a group to only include pairs that have entries in ``remote-addresses`` and automatically skip other pairs?

For these cases we need another construct called ``labels`` introduced in the :ref:`next section <psconfig_templates_advanced-addresses-labels>`.

.. _psconfig_templates_advanced-addresses-labels:

Labeling Address Properties
------------------------------
When building templates, there are advanced use cases where we want an *address* object to express a certain set of properties depending on how it is being used. Often times we can do this by creating separate *address* objects and including the one with the properties we want in the corresponding group. Unfortunately that's not always as clear or still sometimes doesn't capture the goal (particularly if :ref:`remote-addresses <psconfig_templates_advanced-addresses-remote_addresses>` are involved).  Furthermore, we sometimes want our task topology to be *sparse*, meaning each member in the group only tests to a few others and ignores the rest. This can be accomplished with structures such as the *group* :ref:`excludes <psconfig_templates_advanced-groups-excludes>` property, but those can also get difficult to maintain overtime. To assist with these cases, *address* objects have the ``labels`` property.

The ``labels`` property of an *address* object gives an additional criteria on which we can choose the properties expressed by an *address*. Let's take a look at an example where we have a set of *address* objects representing a server with the following characteristics:
 
 * All the servers have 1Gbps interfaces
 * Only some have 10Gbps interfaces
 * One of the servers has two 10Gbps interfaces
 
 .. note:: Using separate address objects and optionally combining them with :doc:`address classes <psconfig_autoconfig>` is probably the cleanest way to build a template to meet this goal. The example that follows is a useful learning tool for demonstrating how ``labels`` work in pSConfig even if it is not the most efficient solution.
 
 We could do the following where the 1Gbps interfaces is represented by the top-level ``address`` property and the 10Gbps interfaces are in labels::

    {
        "addresses": {
            "thr1": {
                "address": "thr1.perfsonar.net",
                "labels": {
                    "10gbps": {
                        "address": "thr1-10g.perfsonar.net"
                    }
                }
            },
            "thr2": {
                "address": "thr2.perfsonar.net"
            },
            "thr3": {
                "address": "thr3.perfsonar.net",
                "labels": {
                    "10gbps": {
                        "address": "thr3-10g.perfsonar.net"
                    },
                    "10gbps-secondary": {
                        "address": "thr3-10g-2.perfsonar.net"
                    }
                }
            }
        },
        "groups": {
            "10gbps_group": {
                "type": "mesh",
                "default-address-label": "10gbps",
                "addresses": [
                     {"name": "thr1"},
                     {"name": "thr2"},
                     {"name": "thr3"},
                     {"name": "thr3", "label": "10gbps-secondary"}
                 ]  
            }
        }
    }
    
First let's breakdown the JSON above:

* The addresses ``thr1`` and ``thr3`` both have a label named ``10gbps`` defined.
* ``thr2`` has no labels defined.
* ``thr3`` has a second label defined named ``10gbps-secondary``.
* The group defines a ``default-address-label`` of ``10gbps``. This includes any address referenced that has a label of ``10gbps``. Any address without this label and that doesn't specify an alternative label will be ignored as if it were not in the list at all. In other words, ``thr2`` will be skipped.
* The final address selector in the group specifies a label of ``10gbps-secondary`` in addition to a name. This overrides the ``default-address-label`` and chooses the address specified by the name and label combination.

The table below illustrates the generated address pairings and the values of the :ref:`address template variable <psconfig_templates_vars-address>`:

+--------------------------+--------------------------+
| {% address[0] %}         | {% address[1] %}         |
+==========================+==========================+
| thr1-10g.perfsonar.net   | thr3-10g.perfsonar.net   |
+--------------------------+--------------------------+
| thr1-10g.perfsonar.net   | thr3-10g-2.perfsonar.net |
+--------------------------+--------------------------+
| thr3-10g.perfsonar.net   | thr1-10g.perfsonar.net   |
+--------------------------+--------------------------+
| thr3-10g-2.perfsonar.net | thr1-10g.perfsonar.net   |
+--------------------------+--------------------------+

.. note:: If you are wondering why thr3-10g.perfsonar.net and thr3-10g-2.perfsonar.net are not a generated pair, see the discusion on ``excludes-self`` in :ref:`psconfig_templates_advanced-groups-excludes`

Where labels are generally more practical is when combined with the ``remote-addresses`` property. Consider the diagram below:

.. figure:: images/psconfig_templates_advanced_labels-network.png
    :align: center
    
    *A network of four hosts where hosts communicate on private subnets and only between certain host pairs*

A breakdown of the task topology in the diagram is as follows:

* *host1* only tests to *host3*
* *host2* tests to *host3* and *host4* - in fact it has two sets of addresses it can use to test with *host4*

If we want to define this task topology using a single *group* object, we can't simply use ``remote-addresses``. The reason for this is that we want a sparse task topology where a number of the pairs are ignored. We could potentially get around that with an :ref:`excludes <psconfig_templates_advanced-groups-excludes>` property in a *group* but not only is that more verbose than we need, but it doesn't help us with the fact that *host2* and *host4* test to each other twice. The answer to solving all these issues is to define ``remote-addresses`` that contain ``labels``. An example ``addresses`` and ``groups`` section of the required template is as follows::

    {
        "addresses": {
            "host1": { 
                "address": "host1.perfsonar.net",
                "remote-addresses": {
                    "host3": {
                        "labels": {
                            "private": {
                                "address": "10.0.0.1"
                            }
                        }
                    }
                }
            },
            "host2": { 
                "address": "host2.perfsonar.net",
                "remote-addresses": {
                    "host3": {
                        "labels": {
                            "private": {
                                "address": "10.1.1.1"
                            }
                        }
                    },
                    "host4": {
                        "labels": {
                            "private": {
                                "address": "10.2.2.1"
                            },
                            "private-secondary": {
                                "address": "10.3.3.1"
                            }
                        }
                    }
                }
            },
            "host3": { 
                "address": "host3.perfsonar.net",
                "remote-addresses": {
                    "host1": {
                        "labels": {
                            "private": {
                                "address": "10.0.0.2"
                            }
                        }
                    },
                    "host2": {
                        "labels": {
                            "private": {
                                "address": "10.1.1.2"
                            }
                        }
                    }
                }
            },
            "host4": { 
                "address": "host4.perfsonar.net",
                "remote-addresses": {
                    "host2": {
                        "labels": {
                            "private": {
                                "address": "10.2.2.2"
                            },
                            "private-secondary": {
                                "address": "10.3.3.2"
                            }
                        }
                    }
                }
            }
        },
    
        "groups": {
            "labels_example": {
                "type": "mesh",
                "default-address-label": "private",
                "addresses": [
                    { "name": "host1" },
                    { "name": "host2" },
                    { "name": "host2", "label": "private-secondary" },
                    { "name": "host3" },
                    { "name": "host4" },
                    { "name": "host4", "label": "private-secondary"  }
                ]
            }
        }
    }

The table below illustrates the generated address pairings and the values of the :ref:`address template variable <psconfig_templates_vars-address>`:

+--------------------+-------------------+------------------+------------------+
| Address Pair Names | Label             |{% address[0] %}  | {% address[1] %} |
+====================+===================+==================+==================+
| host1, host3       | private           | 10.0.0.1         | 10.0.0.2         |
+--------------------+-------------------+------------------+------------------+
| host2, host3       | private           | 10.1.1.1         | 10.1.1.2         |
+--------------------+-------------------+------------------+------------------+
| host2, host4       | private           | 10.2.2.1         | 10.2.2.2         |
+--------------------+-------------------+------------------+------------------+
| host2, host4       | private-secondary | 10.3.3.1         | 10.3.3.2         |
+--------------------+-------------------+------------------+------------------+
| host3, host1       | private           | 10.0.0.2         | 10.0.0.1         |
+--------------------+-------------------+------------------+------------------+
| host3, host2       | private           | 10.1.1.2         | 10.1.1.1         |
+--------------------+-------------------+------------------+------------------+
| host4, host2       | private           | 10.2.2.2         | 10.2.2.1         |
+--------------------+-------------------+------------------+------------------+
| host4, host2       | private-secondary | 10.3.3.2         | 10.3.3.1         |
+--------------------+-------------------+------------------+------------------+

Note that it automatically skips combinations where there is no remote-address entry or no label matching either the ``label`` in the address selector if specified or the ``default-address-label`` if not specified. 

The usage of ``labels`` by themselves or within ``remote-addresses`` allow for a number of possibilities with regards to dynamically changing properties of addresses. The section showed a few of those and hopefully has provided a foundation for adapting to other use cases. 

.. _psconfig_templates_advanced-hosts:

Sharing Address Properties with ``hosts``
==========================================

.. _psconfig_templates_advanced-hosts-intro:

Introduction to ``hosts``
-------------------------
Often times, multiple *address* objects have a shared set of properties. For example, if you have two *address* objects representing network interfaces on the same physical system, and that system is not running an agent, then you want to set the :ref:`no-agent <psconfig_templates_advanced-addresses-noagent>` property. You could define it twice (once in each *address* object) or you could define a *host* object. 

In pSConfig, a **host** is an object containing properties shared between one or more addresses. A *host* object is defined in the ``hosts`` section of a template. For our ``no-agent`` use case, an example *host* object could be represented in the ``hosts`` section as follows::

    "hosts": {
        "thrlat2": {
            "no-agent": true
        }
    }

An *address* object can indicate it belongs to a particular *host* object using the ``host`` property. Below is an example ``addresses`` section using the *host* above::

    "addresses": {
        "thr2": {
            "address": "thr2.perfsonar.net",
            "host": "thrlat2"
        },
        "lat2": {
            "address": "lat2.perfsonar.net",
            "host": "thrlat2"
        }
    }
    
Each address can only belong to one *host* object. Also a *host* object has no required properties (i.e. an empty object ``{}`` is a valid *host*). You can see the following sections for some uses of *host* objects and their properties:

* For information on setting a archives to be used anytime an *address* object belonging to a *host* is the :ref:`scheduled_by_address <psconfig_templates_vars-scheduled_by_address>` see :ref:`psconfig_templates_advanced-hosts-archives`
* For information on disabling all the addresses belonging to a host, see :ref:`psconfig_templates_advanced-hosts-disabled`
* For information on using tags and other properties of hosts to dynamically build groups see :doc:`psconfig_autoconfig`


.. note:: See the `pSConfig Template JSON Schema <https://raw.githubusercontent.com/perfsonar/psconfig/master/doc/psconfig-schema.json>`_ for a full list of options supported by the *host* object.

.. _psconfig_templates_advanced-hosts-archives:

Setting Host Archives
-------------------------
A *host* object supports setting one or more archives to be used anytime an address belonging to that *host* is is the :ref:`scheduled_by_address <psconfig_templates_vars-scheduled_by_address>` of an individual task. It does this through the ``archives`` property which accepts a list of *archive* object names. 

For example, you can set a an archive that publishes results to an esmond instance running on ``thrlat2-archive.perfsonar.net`` anytime either ``thr2.perfsonar.net`` or ``lat2.perfsonar.net`` is responsible for scheduling a task::

    {
        "archives": { 
           "local_archive": {
                "archiver": "esmond",
                "data": {
                    "url": "https://thrlat2-archive.perfsonar.net/esmond/perfsonar/archive",
                    "measurement-agent": "{% scheduled_by_address %}"
                }
            }
        },
    
        "addresses": {
            "thr2": {
                "address": "thr2.perfsonar.net",
                "host": "thrlat2"
            },
            "lat2": {
                "address": "lat2.perfsonar.net",
                "host": "thrlat2"
            }
        },
    
        "hosts": {
            "thrlat2": {
                "archives": ["local_archive"]
            }
        }
    }

Archives defined in this way will only be used when the *address* objects belonging to a host are the :ref:`scheduled_by_address <psconfig_templates_vars-scheduled_by_address>`. This means that the archive will not be used for a host pair where they are not involved or where another address is responsible for scheduling.

Also, if the *task* ``archives`` property is defined and the *host* ``archives`` property applies, then the two lists will be merged. If a task ``archives`` property and a host ``archives`` property both point at the same *archive* object, that object will only be used once (i.e. results will not get published twice to the same archive).

.. _psconfig_templates_advanced-hosts-disabled:

Disabling a Host
----------------
If you want to temporarily suspend all tasks involving all addresses associated with a host, then you can use the *host* ``disabled`` property. This functions exactly the same as if you were to individually set the :ref:`address disabled property <psconfig_templates_advanced-addresses-disabled>` for each *address* belonging to a host. An example is below::

    {
        "hosts": {
            "thrlat2": {
                "disabled": true
            }
        },
        
        "addresses": {
            "thr2": {
                "address": "thr2.perfsonar.net",
                "host": "thrlat2"
            },
            "lat2": {
                "address": "lat2.perfsonar.net",
                "host": "thrlat2"
            }
        }
    }

.. _psconfig_templates_advanced-includes:

Including External Files
==========================
pSConfig templates support including external files through the use of the ``includes`` property. The ``includes`` property goes at the top-level of the template and is an array of URLs to *include files*. It is important to keep the following in mind when using ``includes`` in your template:

* Include files are processed in the order they are specified in the ``includes`` property
* An include file MUST be reachable by the agent(s) reading the template. For remote agents this means the URL must be available via http or https. If your template is one that will only be read by an agent on the local file system, then it is possible to use URLs pointing at local files by either specifying the full file path or using the ``file://`` prefix in the URL.
* A template with an ``includes`` section MUST validate against the `pSConfig Template JSON Schema <https://raw.githubusercontent.com/perfsonar/psconfig/master/doc/psconfig-schema.json>`_ both prior to including the file and after including the file. If, for example, all your ``addresses`` live in an include file, you still need to provide an empty object ``{}`` in the base template. 
* An include file does NOT need to validate against the `pSConfig Template JSON Schema <https://raw.githubusercontent.com/perfsonar/psconfig/master/doc/psconfig-schema.json>`_. Instead it can be a partial template containing one or more of the following sections: `addresses`, `address-classes`, `archives`, `contexts`, `groups`, `hosts`, `schedules`, `tasks`, and/or `tests`. 
* The sections from the include file will be merged into the corresponding section of the base template. If during a merge an object (e.g. an individual *address* object) has the same name as an object already in the template, the object from the include file will be ignored.


To better illustrate the points above, let's look at an example using includes to recreate the JSON template from the :ref:`template introduction <psconfig_templates_intro-example>` that can be downloaded :download:`here <psconfig_templates/psconfig_templates_intro-network.json>`. Let's define two template files, one that defines the latency ``addresses`` and ``groups`` and another that defines the throughput ``addresses`` and ``groups``.

The latency include file is below (we'll assume it lives at ``https://example.perfsonar.net/psconfig/includes/latency.json``)::

    {
        "addresses": {
            "lat1": {
                "address": "lat1.perfsonar.net"
            },
            "thrlat1": {
                "address": "thrlat1.perfsonar.net"
            },
            "lat2": {
                "address": "lat2.perfsonar.net"
            }
        },
        "groups": {
            "latency_group": {
                "type": "mesh",
                "addresses": [
                     {"name": "lat1"},
                     {"name": "thrlat1"},
                     {"name": "lat2"}
                 ]  
            }
        }
    }

The throughput include file is below (we'll assume it lives at ``https://example.perfsonar.net/psconfig/includes/throughput.json``)::

    {
        "addresses": {
            "thr1": {
                "address": "thr1.perfsonar.net"
            },
            "thrlat1": {
                "address": "thrlat1.perfsonar.net"
            },
            "thr2": {
                "address": "thr2.perfsonar.net"
            }
        },
        "groups": {
            "throughput_group": {
                "type": "mesh",
                "addresses": [
                     {"name": "thr1"},
                     {"name": "thrlat1"},
                     {"name": "thr2"}
                 ]  
            }
        }
    }

Finally we build our base template that includes the files::

    {
        "includes": [
            "https://example.perfsonar.net/psconfig/includes/latency.json",
            "https://example.perfsonar.net/psconfig/includes/throughput.json"
        ],
        "addresses": {},
        "groups": {},
        "tests": {
            "latency_test": {
                "type": "latencybg",
                "spec": {
                    "source": "{% address[0] %}",
                    "dest": "{% address[1] %}",
                    "packet-interval": 0.1,
                    "packet-count": 600
                }
            },
            "throughput_test": {
                "type": "throughput",
                "spec": {
                    "source": "{% address[0] %}",
                    "dest": "{% address[1] %}",
                    "duration": "PT30S"
                }
            }
        },
        "archives": { 
           "esmond_archive": {
                "archiver": "esmond",
                "data": {
                    "url": "https://esmond.archive.perfsonar.net/esmond/perfsonar/archive",
                    "measurement-agent": "{% scheduled_by_address %}"
                }
            }
        },
        "schedules": { 
           "every_4_hours": {
                "repeat": "PT4H",
                "slip": "PT4H",
                "sliprand": true
            }
        },
        "tasks": {
            "latency_task": {
                "group": "latency_group",
                "test": "latency_test",
                "archives": ["esmond_archive"]
            },
            "throughput_task": {
                "group": "throughput_group",
                "test": "throughput_test",
                "archives": ["esmond_archive"],
                "schedule": "every_4_hours"
            }
        }
    }

It is worth noting the following about the template above:

* The ``includes`` section points at two URLs accessible by remote agents using https
* The include files both contain only a ``groups`` and ``addresses`` section since there is no requirement they be a complete template
* The base template MUST validate prior to merging the include files, so there are empty ``addresses`` and ``groups`` since those are required by the schema. 
* Both include files contain an *address* object named ``thrlat1``. The address will only be included once. Since the latency include file is listed first in our ``includes`` section, that definition will be used.

Include files like the above can be useful for organizing templates making them more readable. For further information on advanced use cases where include files can be used to make your templates more dynamic see :doc:`psconfig_autoconfig`.

.. _psconfig_templates_advanced-contexts:

Using ``contexts``
==================
pSConfig allows for the use of a pScheduler supported construct called a context. Contexts are named as such because they allow certain user-specified changes to the execution context prior to execution of that tool running a test. Just like tests, tools and archives, contexts are defined by plug-ins of which pSConfig does not have detailed knowledge. As such, any context your pScheduler server can support, pSConfig can also support.

pSConfig allows you to define *context* objects in the ``contexts`` section of a template. These *context* objects are named and can be referenced by an *address* object. When a pScheduler agent is building a task, it will check the list of addresses generated by a group for context definitions. If it finds any, then it will pass them to pScheduler. The schema of a *context* in pSConfig matches that of pScheduler (with additional support for an optional ``_meta`` field). Each *context* has a ``context`` property indicating the type and a ``data`` property with type-specific options. An example of a ``linuxnns`` context and how to associate its address objects is shown in the example below::

    "contexts": {
        "linuxnns_ou812": {
            "context": "linuxnns",
            "data": {
                "namespace": "ou812"
            }
        }
    },
    
    "addresses": {
        "thr1": {
            "address": "thr1.perfsonar.net",
            "contexts": [ "linuxnns_ou812" ]
        },
        "thr2": {
            "address": "thr2.perfsonar.net",
            "contexts": [ "linuxnns_ou812" ]
        }
    }
    
In the current form of pSConfig's context usage, you need to be careful when using contexts not to unintentionally create invalid pScheduler tasks. In particular, since pSConfig does not know which tests are single participant tests vs. multi-participant in pScheduler terms, then it blindly creates context definitions for any *address* involved in a task. This can cause invalid pScheduler task specifications, particularly in single-participant tests. It also assumes the context of the first address in a pair is the first participant, that of the second is the second participant and so forth. If this is not how you arranged your test it can cause unexpected results. 

You need to be very selective where you use contexts and may consider using a construct such as :ref:`address labels <psconfig_templates_advanced-addresses-labels>` to allow explicit selection of a version of an *address* object with or without contexts. An example that defines the default version of an address with no ``contexts`` and a label that does have ``contexts`` is shown below::

    
        "addresses": {
            "thr1": {
                "address": "thr1.perfsonar.net",
                "labels": {
                    "with_context": {
                        "address": "thr1.perfsonar.net",
                        "contexts": [ "linuxnns_ou812" ]
                    }
                }
            },
            "thr2": {
                "address": "thr2.perfsonar.net",
                "labels": {
                    "with_context": {
                        "address": "thr2.perfsonar.net",
                        "contexts": [ "linuxnns_ou812" ]
                    }
                }
            }
        }


.. _psconfig_templates_advanced-groups:

Advanced ``groups`` Options
=============================

.. _psconfig_templates_advanced-groups-excludes:

Excluding Address Pairs
-----------------------
As described in the :ref:`introduction to groups <psconfig_templates_intro-concepts-groups>`,
both *mesh* and *disjoint* group types have a base set of address pairs they generate when building tasks. Both group types also allow you to modify this base set of address pairs using an optional ``excludes`` property. This property allows you to remove any address pair from the final list, giving you significant flexibility in defining your task topology. 

And example of the ``excludes`` property in a group is shown below::
    
    "latency_group": {
        "type": "mesh",
        "addresses": [
             {"name": "lat1"},
             {"name": "thrlat1"},
             {"name": "lat2"}
         ],
         "excludes": [
            {
                "local-address": { "name": "lat2" },
                "target-addresses": [
                    {"name": "lat1"}
                ]
            }
        ]
    }

In the example, a pair will be excluded where the address named ``lat2`` is the first address in the pair (as indicated by the ``local-address`` property) and ``lat1`` is the second address in the pair (as indicated by the ``target-addresses`` property). Notice that both properties accept *address selector* objects. The order of the addresses matter, so in the example above the pair where ``lat1`` is the first address and ``lat2`` is the second address will stil be included in the final task list. In other words, for each object in ``excludes``, the ``local-address`` will always be compared against the first address in the pair and if it matches, the ``target-addresses`` will be compared sequentially against the second address until one matches or the end of list is reached. If a match is not found then the test will be included.

Both *mesh* and *disjoint* support another exclusion property called ``excludes-self`` for use when a *group* includes two addresses from the same :ref:`host <psconfig_templates_advanced-hosts>` OR from different :ref:`labels <psconfig_templates_advanced-addresses-labels>` in the same *address* object. The ``excludes-self`` property is an enumerated string supporting the following values:

* ``host`` excludes any address pair where both addresses are from the same *host* object and/or from different labels in the same *address* object. **This is the default behavior.**
* ``address`` excludes any address pair where both addresses are from different labels in the same *address* object, but will include pairs where the addresses belong to the same *host*.
* ``disabled`` includes all address pairs.

An example showing the default behavior is below::

    "latency_group": {
        "type": "mesh",
        "addresses": [
             {"name": "lat1"},
             {"name": "thrlat1"},
             {"name": "lat2"}
         ],
         "excludes-self": "host"
    }


.. _psconfig_templates_advanced-groups-unidirectional:

Unidirectional Disjoint Groups
-------------------------------
The *disjoint* group type generates a list of address pairs where each *address* in ``a-addresses`` is paired with each address in ``b-addresses``. By default, for each combination this list will include both the following:

#. The pair where the object from ``a-addresses`` is listed first and the object from ``b-addresses`` is second
#. The pair where the object from ``b-addresses`` is listed first and the object from ``a-addresses`` is second.

If we only want the combination of addresses where the ``a-addresses`` object is first and the ``b-addresses`` is second (item #1 above) then we can use the boolean ``unidirectional`` property to indicate that fact. 

An example of ``unidirectional`` is shown below::

    "example-group": {
        "type": "disjoint",
        "unidirectional": true,
        "a-addresses": [
            { "name": "host1" }
        ],
        "b-addresses": [
            { "name": "host2" },
            { "name": "host3" },
            { "name": "host4" }
        ]
    }

The generated address pairs are as follows:

* ``host1``, ``host2``
* ``host1``, ``host3``
* ``host1``, ``host4``

Note that all pairs where ``host1`` would be the second address are excluded. 

.. note:: The ``unidirectional`` property is actually just a short-form of an :ref:`excludes <psconfig_templates_advanced-groups-excludes>` property containing an object for each address in ``b-addresses`` where the ``local-address`` is the ``b-addressess`` entry and the ``target-addresses`` is the full list of ``a-addresses``.

.. _psconfig_templates_advanced-groups-disabled:

Disabling an Address Selector
------------------------------
For all group types, if you would like to temporarily suspend use of a particular *address selector* object from that group without explicitly deleting it, you can use the ``disabled`` property.

An example of the ``disabled`` property in an *address selector* is shown below::

    "example-group": {
        "type": "disjoint",
        "a-addresses": [
            { "name": "host1" }
        ],
        "b-addresses": [
            { "name": "host2" },
            { "name": "host3", "disabled": true },
            { "name": "host4" }
        ]
    }

The generated address pairs are as follows:

* ``host1``, ``host2``
* ``host1``, ``host4``
* ``host2``, ``host1``
* ``host4``, ``host1``

You can think of this property as a way to "comment-out" an *address selector* object since JSON does not natively support comments. It is most useful when you don't want to entirely delete an *address selector* but need to remove it from a group's testing for some amount of time.

Advanced ``tasks`` Options
============================

.. _psconfig_templates_advanced-tasks-tools:

Setting Tools For a Task
---------------------------------------------
If you would like to specify a preference for a :term:`tool` to be used for a particular task, *task* objects support the ``tools`` property.

An example of a ``tools`` property is shown below::

    "tasks": {
        "throughput_task": {
            "tools": [
                "iperf3",
                "nuttcp"
            ],
            "group": "throughput_group",
            "test": "throughput_test",
            "archives": ["esmond_archive"],
            "schedule": "every_4_hours"
        }
    }

The example above states to ask pScheduler to use the ``iperf3`` tool if possible. If not possible, then check if the ``nuttcp`` tool is available. If neither is available, then the task will fail to be created. If ``tools`` is not specified then the tool selection will be determined by the default behavior of the pScheduler server.


.. _psconfig_templates_advanced-tasks-priority:

Setting Task Priority
---------------------------------------------
If you would like to set the priority with which a task will be scheduled by pScheduler with respect to other tasks, then the pSConfig *task* object supports a ``priority`` field.

An example of the ``priority`` field is shown in the following example::
    
    "tasks": {
        "throughput_task": {
            "priority": 10,
            "group": "throughput_group",
            "test": "throughput_test",
            "archives": ["esmond_archive"],
            "schedule": "every_4_hours"
        }
    }

This will pass the priority directly to pScheduler. If not set, then no explicit priority will be given to pScheduler and the pScheduler server will follow it's default behavior for determining priority.

.. _psconfig_templates_advanced-tasks-reference:

Setting the pScheduler ``reference`` field
---------------------------------------------
In pScheduler, tasks support a ``reference`` field that can be used to store extra information with a task. pScheduler nor its plugins make any use of the field, but it is there for clients querying the pScheduler schedule. It takes the form of an opaque JSON object that's structure is undefined.

pSConfig allows you to define a reference object to be passed to pScheduler as shown in the following example::

    "tasks": {
        "throughput_task": {
            "group": "throughput_group",
            "test": "throughput_test",
            "archives": ["esmond_archive"],
            "schedule": "every_4_hours",
            "reference": {
                "production-measurement": true,
                "source_ifspeed": "{% jq addresses[0]._meta.ifspeed %}",
                "dest_ifspeed": "{% jq addresses[1]._meta.ifspeed %}"
            }
        }
    }

In the above example we define three custom properties. Properties can use :doc:`template variables <psconfig_templates_vars>` and take whatever form you need as long as:

* The resulting ``reference`` object is valid JSON. This means that properties do not need to by primitive values, they can also be arrays or nested objects.
* You don't include a property named ``psconfig`` in the top-level of your ``reference`` object. This is reserved for use by pSConfig agents and your definition will be overwritten.

Let's take a closer look at our example:

* The ``production-measurement`` property is a fixed boolean value of ``true``. Presumably a client could interpret this to indicate the measurement is production grade and problems with the results should be handled accordingly. 
* The ``source_ifspeed`` and ``dest_ifspeed`` demonstrate the use of :ref:`jq template variables <psconfig_templates_vars-jq>` to grab a ``_meta`` property from the *address* objects involved in the tasks

That's all there is to it. The information above should allow you to tailor the ``reference`` object to your needs.

.. note:: The ``reference`` object is different from the ``_meta`` object in that the ``_meta`` object is NOT passed to pScheduler. If you want information from a ``_meta`` object in the ``reference`` object than you may use :ref:`jq template variables <psconfig_templates_vars-jq>`.

.. _psconfig_templates_advanced-tasks-scheduled_by:

Controlling the Agent That Schedules a Task
---------------------------------------------
The :doc:`pSConfig pScheduler agent <psconfig_pscheduler_agent>` running on a particular host will determine which tasks it is responsible for scheduling by looking at the generated *address* objects from a task's *group*. By default, the first address in the generated list where :ref:`no-agent <psconfig_templates_advanced-addresses-noagent>` is NOT enabled will be used. If you would like to change the behavior, then you can use the pSConfig *task* object's ``scheduled-by`` field. 

The ``scheduled-by`` field is an integer representing the index (starting at 0) of the *address* object in a generated list to try first. By default, the value is ``0``. The following rules are used when interpreting ``scheduled-by`` and determining responsibility for scheduling a task:

* If the address indicated by ``scheduled-by`` does NOT have ``no-agent`` enabled, then it is used and no further processing is required.
* If the address has ``no-agent`` enabled, then it will look for the first member of the list after the ``scheduled-by`` value that does NOT have ``no-agent`` enabled. It will wrap around to the start of the list if it does not find one before it reaches the end. 
* If all members are ``no-agent``, then the test will be skipped.

Let's look at the following example with two tasks only differing in their ``scheduled-by`` property::

    {
        "addresses": {
            "lat1": {
                "address": "lat1.perfsonar.net"
            },
           "thrlat1": {
                "address": "thrlat1.perfsonar.net"
            },
            "lat2": {
                "address": "lat2.perfsonar.net"
            }
        },
        "groups": {
            "latency_group": {
                "type": "mesh",
                "addresses": [
                     {"name": "lat1"},
                     {"name": "thrlat1"},
                     {"name": "lat2"}
                 ]  
            }
        },
        "tests": {
            "latency_test": {
                "type": "latencybg",
                "spec": {
                    "source": "{% address[0] %}",
                    "dest": "{% address[1] %}",
                    "flip": "{% flip %}",
                    "packet-interval": 0.1,
                    "packet-count": 600
                }
            }
        },
        "tasks": {
            "latency_task_sched_by_source": {
                "group": "latency_group",
                "test": "latency_test"
            },
            "latency_task_sched_by_dest": {
                "scheduled-by": 1,
                "group": "latency_group",
                "test": "latency_test"
            }
        }
    }

In the above examples, the first task ``latency_task_sched_by_source`` uses the default behavior which is the equivalent of ``scheduled-by`` being set to ``0``. Given the *test* object construction and the fact that all addresses run an agent, then the agent associated with the ``source`` will always be the one requesting the task. In the second example ``latency_task_sched_by_dest``, the ``scheduled-by`` property is explicitly set to ``1`` but otherwise the same as the first *task*. This mean the same task will be scheduled but the agent associated with the ``dest`` will be the one requesting the task's creation. This creates a duplicate task with the only difference being the agent that requested it.

.. note:: If you are familiar with the *force_birdirectional* field available in legacy perfSONAR tools, using ``scheduled-by`` and defining two tasks above is the way to accomplish the same goal as that option. Generally doing so is not recommended unless you have a very specific reason as it can lead to over-testing with little benefit.

.. note:: This value is closely linked to the :ref:`scheduled_by_address template variable <psconfig_templates_vars-scheduled_by_address>`. See the template variable :ref:`documentation <psconfig_templates_vars-scheduled_by_address>` for more details. 


.. _psconfig_templates_advanced-tasks-disabled:

Disabling a Task
--------------------
If you want to temporarily suspend usage of a *task* object by agents, then you can set the ``disabled`` property as shown in the example below::

    "latency_task": {
        "disabled": true,
        "group": "latency_group",
        "test": "latency_test"
    }

You can think of this property as a way to "comment-out" a *task* object since JSON does not natively support comments. It is most useful when you don't want to entirely delete a *task* but need to remove it from testing for some amount of time.

