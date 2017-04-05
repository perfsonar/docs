******************************
What is pScheduler?
******************************

Introduction
============

pScheduler is the perfSONAR Scheduler, a new system for the scheduling and supervision of automated measurements and sending the results off for storage.  It is a complete replacement for the Bandwidth Test Controller (BWCTL), which has been part of perfSONAR since its early days.  
 
Among the features of the new software are:

* Significantly-improved visibility into prior, current and scheduled future activities
* Easy availability of diagnostic information
* Full-featured, repeating testing for all measurement types baked into the core of the system
* A more-powerful system for imposing policy-based limits on users
* A REST API to make the software-based interfacing to perfSONAR easier
* Standardized, documented data formats based on JavaScript Object Notation (JSON)
* Hooks for supporting unusual use cases, such as measurements on GÉANT’s MD-VPN platform

The most significant of pScheduler’s new features is extensibility.  A standard API has been defined for interfacing with implementations of tests (types of measurements), tools (programs which make the measurements) and archivers (programs to transfer measurement results to various kinds long-term storage).  There have been many users wanting to integrate less-than-mainstream applications with perfSONAR but have been stymied by a lack of core development team resources.  This architecture will allow members of the community to participate in development of new tests, tools and archivers with minimal assistance from the core team.  The larger ecosystem of available tools will help drive adoption perfSONAR in areas where it would not have been possible previously.

Usage
=====

The full User Guide is available at: https://github.com/perfsonar/pscheduler/wiki/CLI-User's-Guide

bwctl -> pscheduler conversion help can be found at: http://fasterdata.es.net/performance-testing/network-troubleshooting-tools/pscheduler

Reference link to "Cheatsheet": https://www.cheatography.com/mfeit-internet2/cheat-sheets/perfsonar-pscheduler/


More Information
================

Additional information on on pscheduler can be found on the pscheduler project wiki:

- Archiver: https://github.com/perfsonar/pscheduler/wiki/Archivers
- Rest API: https://github.com/perfsonar/pscheduler/wiki/REST-API


What is left to discuss? Page should contain at least the following:

    * Brief description of pscheduler and architecture
    * Overview of important terminology (tasks, tests, tools, archiver, etc)
    * The intro to the basic pscheduler command structure here: https://github.com/perfsonar/pscheduler/wiki/CLI-User's-Guide#introduction
    * Section on backward compatibility with BWCTL    

