*********************************
Using perfSONAR with Docker
*********************************

Using perfSONAR with Docker provides a non intrustive way to run the perfSONAR toolset on a variety of platforms with little in the way of setup. This is focused on setting up an instance of the perfsonar-testpoint bundle, described over here :doc:`install_options`.


Docker
======

Docker is a popular container management system designed to make it easy to run "applications in a box" without respect to operating system, package dependencies, etc. Each Docker image is designed to run in complete isolation from other applications and brings along with it everything needed to perform its job successfully.

Docker is available on all major platforms - https://www.docker.com/community-edition

On Linux distributions this may also be available via the distro's native package manager, such as yum.   

The Docker daemon must be running for any docker related activity to succeed.


Limitations
===========

Data on Docker images is not persistent. This means that restarting a container for any reason means that it will start up again in a fresh state. In some ways this is desireable as it means that it is pretty risk free to tinker with things, but it also means that any previously scheduled tests will be forgotten by the container. For this reason it is inadviseable to make changes such as package updates. For information on managing persistent perfSONAR configuration inside of Docker, see the section below.

When running Docker under Mac OSX or Windows, the Docker image is not able to natively share the host system's network stack. To work around this, the Docker image is effectively NAT'd to the host. This is a known limitation in Docker and has the following known implications to perfSONAR:

#. performance may not be as high or as consistent as when run natively

#. some tools, such as owping, may not function correctly in this environment as the IP addresses won't match and may get blocked as a DoS prevention mechanism inside of owamp

#. without doing port forwarding the host will not be able to be the receiver in throughput tests except when doing a reverse test

#. on OSX there is a known clock drift issue in Docker which may result in tests starting to fail after Docker has been running for enough time, or after the host goes to sleep and re-awakens. A future version should fix this, but for the time being it can be worked around by running in the docker image::

     hwclock -s     



QuickStart
==========

The following assumes that Docker has been successfully installed and is running on the host system. It also assumes that the base host is running a time keeping system such as NTP and is NOT running httpd, postgres, or anything else listening on the list of ports below. The Docker image will share the network stack with the host and so expects to be able to bind to all of the ports as if it were being run natively. 

pScheduler
############
:Port: 443

owamp
############
:Port: 861


.. note:: See Limitations section for more details on the network in OSX and Windows deployments.

.. note:: See http://www.perfsonar.net/deploy/security-considerations/ for a full listing of ports.

Docker does support the concept of remapping network ports to guests, but is beyond the scope of this model.

First, pull down the latest Docker image::

  # docker pull perfsonar/testpoint

This will download the latest built image of the perfsonar testpoint bundle. It includes a base CentOS7 install and the perfsonar-testpoint packages. Once the image is downloaded and extracted, start up the container by doing::

  # docker run --privileged -d -P --net=host -v "/var/run" perfsonar/testpoint

Verify that the container is running::

  # docker ps
  CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS               NAMES
  db89e1b5be3b        perfsonar/testpoint   "/bin/sh -c '/usr/..."   42 minutes ago      Up 42 minutes                           nifty_panini

.. note:: Your container ID and "names" will likely be different than the above. These are generated randomly each time a container is started.


Now you can connect to the running Docker image::

  # docker exec -it <container ID from above> bash

At this point you will be at a bash prompt inside of the container, and may start running tests::

  # pscheduler task throughput --dest hostname
  # pscheduler ping hostname


Congratulations, you're running perfSONAR in Docker!


TroubleShooting
===============

The easiest way to troubleshoot issues with the Docker image are to connect to it while running. Find the container ID of the running container::

  # docker ps
  CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS               NAMES
  db89e1b5be3b        perfsonar/testpoint   "/bin/sh -c '/usr/..."   42 minutes ago      Up 42 minutes                           nifty_panini

Connect to the container::

  # docker exec -it <container ID from above> bash

And then do troubleshooting as you would anywhere else in perfSONAR. You can look at various log files, run commands in debug mode, etc.



Managing Upgrades
=================

To upgrade your Docker container, from the parent do the following::

    # docker pull perfsonar/testpoint

If it reports a message about "Image is up to date" then you are already running the latest version.

You will need to stop the currently running container and start the new version. First figure out the container id of the currently running one::
    
    # docker ps -a
    CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS                           PORTS               NAMES
    b5e393edf7ad        perfsonar/testpoint   "/bin/sh -c '/usr/..."   57 minutes ago      Up 57 minutes                                        cocky_mirzakhani

Once the container ID is known, have docker shut it down::

  # docker kill b5e393edf7ad
 
.. warning:: Shutting down the container will cause it to lose all state. All scheduled tests will be forgotten and any configuration made that hasn't been committed back to the Docker image will be lost.

And now start up the new one. This process is the same as the first time it was started, but now with the newer image it will start up the new version::

  # docker run --privileged -d -P --net=host -v "/var/run" perfsonar/testpoint

Connect to the docker instance again and verify that you are running the version expected::

  # docker exec -it <new container's ID> bash
  # rpm -qa | grep perfsonar

Your Docker instance of perfsonar-testpoint has now been upgraded to the latest perfSONAR code. 


Updating LS Registration, pSConfig, etc. files
=================================================

In its stock deployment the perfsonar Docker image is not stateful. All changes made inside of the container are lost when it is stopped. Sometimes you want to make changes that persist through upgrades or restarts, such as being part of a pSConfig template or registering to the lookup service. 

Before starting, be sure that the container isn't running::
 
  # docker ps


Start the base container in interactive mode::

  # docker run -it perfsonar/testpoint /bin/bash

You will now be at a bash prompt inside of the container. Make the desired changes with the ``psconfig remote`` command or similar (see :ref:`psconfig_pscheduler_agent-templates`) and exit the container.

Find the container ID from the just modified container::

  # docker ps -a
  CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS                    PORTS               NAMES
  f3403177b25d        perfsonar/testpoint   "/bin/bash"         14 seconds ago      Exited (0) 1 second ago                       laughing_spence


and then use this to create the new layer for your perfsonar/testpoint Docker image::

  docker commit --change "CMD /usr/bin/supervisord -c /etc/supervisord.conf" -m "adding psconfig configuration" f3403177b25d perfsonar/testpoint

Now the next time that the perfsonar/testpoint Docker image is started, the changes made to the edited perfSONAR configuration will persist.

.. note:: This is only intended for editing of perfSONAR configuration files. Changing files outside of these may result in an unusable image or unpredictable behavior. Proceed at your own risk. In the event that something does go poorly, you can delete and re-pull the perfsonar/testpoint image.


Tested Platforms
================

#. CentOS7
#. Mac OSX High Sierra
#. Windows 10
