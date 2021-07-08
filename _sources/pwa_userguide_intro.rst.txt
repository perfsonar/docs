****************************************
Introduction
****************************************

PWA Overview
-----------------------

The pSConfig Web Admin (PWA) is a web-based application for managing pSConfig configurations (formerly known as MeshConfig).

A few terms:

* `Host Group <pwa_userguide_hostgroup>`_ - A group of hosts that are user-selected that all can perform a certain type of test
* `Testspec <pwa_userguide_testspec>`_ - test configuration for a test to run; this can include tool and test parameters, scheduling configuration, etc. 
* `Config <pwa_userguide_config>`_ - in the context of PWA, a Config is an actual test configuration that brings together Host Groups and Testspecs to generate Meshconfig and/or pSConfig output. You can use this to configure your meshes or other topologies.

PWA also allows you to edit details for hosts; you can set descriptions, measurement archives, addresses, services, etc. The host listing is populated from the Global Lookup Service by default, but you can also add other hosts (these are called "Ad Hoc" hosts).

