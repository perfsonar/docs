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
    
    Limits
        Rules that define who is allowed to run what type of tests
    
    Schedule Horizon
        The amount ahead of time that pScheduler puts a run on the schedule.
    
    Assist Server
        A pScheduler server that accepts a test specification and can return the :term:`lead participant`. The assist server may or may not be involved in the test specified, it's role is simply to tell you the lead where the task should be submitted. By default the assist server is always the local host.
    
    Lead Participant
        The pScheduler server where a task should be submitted. It will become responsible for contacting other participants, making scheduling decisions based on gathered information and archiving results. 
    
    

Benefits
============
The pScheduler server will handle the coordination, execution and optionally storage of the task requested. Many of the :term:`tools <tool>` pScheduler executes could be run independently of pScheduler, but the added value provide by pScheduler is significant to perfSONAR hosts for the following reasons:

    * **Measurement Integrity** - pScheduler maintains a schedule of all measurements to be run and will not allow any measurements it knowns about to run simultaneously if doing so would adversely affect the result in a significant way. For example, it will not run two throughput tests at the same time as the competition for resources could affect the results of each. In contrast it will run latency tests in the background as the low resource consumption does not significantly affect results of parallel tests.
    * **Simplified Coordination** - pScheduler not only simplifies coordination during task execution, but also after you have the result. pScheduler will contact each end and handle bringing up any daemons as required. It also has a plug-in architecture that allows you to send the result elsewhere, such as a long-erm storage system, when the measurement completes. 
    * **Access Control** - pScheduler has a limits system that allows the definition of rules about who can run what type of measurements. 
    * **Diagnostics** - pScheduler gives you visibility into the schedule it maintains meaning you can determine when a task ran, runs or will run. It also keeps for some amount of time information about the outcome, including if the result was a failure, which can be useful for diagnosing issues with your test infrastructure. 
    
In addition to these foundational features, perhaps pScheduler greatest asset is it's extensibility. It allows allows plug-ins for new tests, tools and archivers to be written. This means that pScheduler is not limited by what it can do today, and it's possible to extend it to perform new type of measurements or other functions as well as to have their results sent to new types of storage and/or analysis tools. 
    
The remainder of this document provides some basic information on pScheduler and pointers to more detailed information where applicable. 

..    NOTE: This is a section i would like to add but not sure there will be time. needs diagrams and fleshing of outline below/
..    How It Works
..    =============
..    Creating a task:
..        * Client send task to assist server to determine lead participant
..        * Client sends request to lead participant
..        * Lead participant determines other participants
..        * Lead submits tasks to other participants, they check against limits and find common tool
..        * Task created
..    Scheduling runs:
..        * After a task is created , run is scheduled. lead takes charge
..        * Lead determine run needs to be scheduled. Done by looking at task interval and comparing what's already scheduled to time horizon.
..        * Lead gathers schedule during time window (determined by slip option) and finds common time. Will choose earliest common time or randomly choose one if randslip is set
..        * Submits to participants for final approval
..        * Run created  
..    Executing Run:
..        * When time comes up pscheduler runs given tool
..        * Result reported and stored in pscheduler
..        * Client may poll result at this point
..        * May also be pushed to archiver where it can be sent somewhere else

Basic Command-Line Client Usage
================================
Everything in the pScheduler command-line interface (CLI) begins by running the `pscheduler` program and specifying a *command* and, optionally, *arguments*::

    pscheduler COMMAND [ ARGUMENTS ]

At all points along the command line, using the `--help` switch will cause pScheduler to display a synopsis of the command so far, available options and, where appropriate, examples.

For more information on specific commands and their arguments see:
    
    - :doc:`pscheduler_client_tasks`
    - :doc:`pscheduler_client_schedule`
    - :doc:`pscheduler_client_utils`
    
Running A pScheduler Server
===========================
If you want tp be able to schedule tasks on your host you will need to run a pScheduler server. For more information on running a pScheduler server and to configure it with limits that meet your needs, see the following documents:

    * :doc:`pscheduler_server_running`
    * :doc:`config_pscheduler_limits`
    

BWCTL Backward Compatibility
============================
pScheduler was introduced in perfSONAR version 4.0 and replaces a component called BWCTL. pScheduler is a completely new codebase and protocol. It does NOT speak the BWCTL protocol natively but it does provide a backward compatibility strategy with BWCTL. This strategy does have limitations though and works as follows: 

    * **For tests from a host running pScheduler to a host with only BWCTL** - For *throughput*, *rtt* and *trace* tests, pScheduler will automatically detect the lack of pScheduler on the remote-end and the presence of BWCTL. It will then choose a pScheduler :term:`tool` that  executes the *bwctl*, *bwping* or *bwctraceroute* command instead of the underlying tool directly. For *throughput* tests, this has the side effect of requiring more time on the pScheduler schedule since BWCTL may not run the test immediately. *If the BWCTL test does not start within 60 seconds of the start time assigned by pScheduler, the test will fail*.
    * **For tests from a host running BWCTL to a host with only pScheduler** - perfSONAR 4.0 still runs the BWCTL server to support this use case. The pScheduler server knows nothing about the BWCTL server's schedule and vice versa, *so it is possible tests could collide*. Depending on how many remote sites initiates tests to you via BWCTL, the risk of this collision may be relatively low.  
    
The software attempts to handle BWCTL compatibility as transparently as possible. This means that when you upgrade your host to a version running pScheduler, there should be no special steps required to initiate the processes outlined above. Your host should continue testing to those running BWCTL and vice versa.

If you also frequently use BWCTL at the command-line, we suggest you stop and start using the pScheduler command line. For a guide on how to convert your BWCTL commands to pScheduler see :doc:`pscheduler_ref_bwctl`.

More Information
================
For useful reference material about different pSchedule options, plug-ins and more see the following:

    * :doc:`pscheduler_ref_tests_tools`
    * :doc:`pscheduler_ref_archivers`

