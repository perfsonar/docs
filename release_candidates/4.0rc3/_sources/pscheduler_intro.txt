******************************
What is pScheduler?
******************************

Introduction
============

pScheduler is responsible for managing the execution of network measurements, or more generally :term:`tasks<task>`, in perfSONAR. When you want to run a network measurement on perfSONAR you ask a pScheduler server, either through the ``pscheduler`` command-line client or through the pScheduler API. 

Terminology
===========

.. glossary::
    :sorted:

    Test
        A set of the parameters required to perform a unit of work. A unit of work is usually a network measurement in perfSONAR, but could be any type of operation. Tests are generally named in terms of what is being produced, not what does the producing. As an example, if what is being produced is a report of the speed of a data transfer, then the test name is *throughput* NOT a :term:`tool` name like *iperf*.

    Participant
        A node that runs pScheduler and handles some facet of conducting a :term:`test`.

    Tool
        A program executed during a :term:`run` of a :term:`task` to carry out a :term:`test`. For example, the *iperf3* tool conducts throughput tests and the *traceroute* and *tracepath* tools conduct trace tests.

    Result
        The observation produced by a :term:`tool` conducting a :term:`test`. For example, after conducting a throughput test, the iperf3 tool might generate a result that says "throughput from A to B was 3.4 Gb/s."

    Task
        A job for pScheduler to do, consisting of a :term:`test` to be carried out, scheduling information and other options.

    Run
        The act of conducting a :term:`task` one time and producing a :term:`result`.

    Archiver
        Software that transfers :term:`results<result>` to long-term storage or elsewhere for further processing.

Basic Command-Line Usage
==========================
Everything in the pScheduler command-line interface (CLI) begins by running the `pscheduler` program and specifying a *command* and, optionally, *arguments*::

    pscheduler COMMAND [ ARGUMENTS ]

At all points along the command line, using the `--help` switch will cause pScheduler to display a synopsis of the command so far, available options and, where appropriate, examples.

For more information on specific commands and their arguments see:
    
    - :doc:`pscheduler_client_tasks`
    - :doc:`pscheduler_client_schedule`
    - :doc:`pscheduler_client_utils`
    

Benefits
============

The pScheduler server will handle the coordination, execution and optionally storage of the task requested. Many of the :term:`tools <tool>` pScheduler executes could be run independently of pScheduler, but the added value provide by pScheduler is significant to perfSONAR hosts for the following reasons:

    * **Measurement Integrity** - pScheduler maintains a schedule of all measurements to be run and will not allow any measurements it knowns about to run simultaneously if doing so would adversely affect the result in a significant way. For example, it will not run two throughput tests at the same time as the competition for resources could affect the results of each. In contrast it will run latency tests in the background as the low resource consumption does not significantly affect results of parallel tests.
    * **Simplified Coordination** - pScheduler not only simplifies coordination during task execution, but also after you have the result. pScheduler will contact each end and handle bringing up any daemons as required. It also has a plug-in architecture that allows you to send the result elsewhere, such as a long-erm storage system, when the measurement completes. 
    * **Access Control** - pScheduler has a limits system that allows the definition of rules about who can run what type of measurements. 
    * **Diagnostics** - pScheduler gives you visibility into the schedule it maintains meaning you can determine when a task ran, runs or will run. It also keeps for some amount of time information about the outcome, including if the result was a failure, which can be useful for diagnosing issues with your test infrastructure. 
    
In addition to these foundational features, perhaps pScheduler greatest asset is it's extensibility. It allows allows plug-ins for new tests, tools and archivers to be written. This means that pScheduler is not limited by what it can do today, and it's possible to extend it to perform new type of measurements or other functions as well as to have their results sent to new types of storage and/or analysis tools. 
    
The remainder of this document provides some basic information on pScheduler and pointers to more detailed information where applicable. 


BWCTL Backward Compatibility
============================

**Still working on this**

pScheduler was introduced in perfSONAR version 4.0 and replaces a component called BWCTL. pScheduler is a completely new codebase and protocol. It does NOT speak the BWCTL protocol natively but it does provide a backward compatibility strategy with BWCTL. **More importantly, pScheduler has no visibility into the BWCTL schedule, so running both simultaneously does bring with it the risk of colliding tests, in particular for throughput**. Depending on how many remote sites initiates tests to you via BWCTL, the risk of this may be relatively low but is worth noting.  

With this limitation in mind, the software attempts to handle BWCTL compatibility as transparently as possible. This means that when you upgrade your host to a version running pScheduler, there should be no special steps required to continue testing to those running BWCTL and vice versa. The process for communicating between the host works as follows:

    * **For tests from a host running pScheduler to a host with only BWCTL** - For *throughput*, *rtt* and *trace* tests, pScheduler will automatically detect the lack of pScheduler on the remote-end and the presence of BWCTL. It will then choose a pScheduler :term:`tool` that  executes the *bwctl*, *bwping* or *bwctraceroute* command instead of the underlying tool directly.
    * **For tests from a host running BWCTL to a host with only pScheduler** -
     
