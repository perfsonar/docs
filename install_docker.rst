*********************************
Using perfSONAR with Docker
*********************************

Using perfSONAR with Docker provides a non-intrusive way to run the perfSONAR software on a variety of platforms including Linux, Mac and Windows. This document focuses on setting-up an instance of the perfsonar-testpoint bundle, described in :doc:`install_options`.

Geting Docker
=================
Docker must be installed and the Docker daemon running in order to use perfSONAR in a container. Detailed instructions for installing docker are beyond the scope of this document. Docker is available on all major platforms at https://docs.docker.com/engine/install/ and may also be available via your operating system's native package manager, such as yum or apt.

.. note:: The perfSONAR container has been tested with **recent** versions of Docker CE and Podman.  Older versions of Docker (specifically 1.x) are known to cause problems.

Considerations
==============
#. This Docker image is intended to provide an isolated environment for bringing-up a quick testing client than can easily be removed when complete. It can also be used as a more permenent tester but requires additional considerations such as how to persist and manage configurations.
#. Performance of Docker containers may vary depending on the environment. In general, the network measurements in Docker will perform better than a virtual machine (VM) but not as well as a bare metal host. This is a broad generalization though as non-Linux OSes such as Windows and Mac actually run containers in a virtual machine.
#. Networking configuration is one of the biggest considerations when running perfSONAR in a container. Docker provides a number of different modes each with tradeoffs. This choice is made more complicated by the fact that implementations can vary between underlying operating systems. Running with *host* networking provides an experience closest to a traditional non-containerized perfSONAR installation. There is no NAT with which to contend and IPv6 support is inherited from the base system. The downside is that you may not have external software like httpd, postgres or other applications that use the same ports as perfSONAR running on the host system. Other modes such as those that use port forwarding do not have this limitation, but can be significantly more challenging to get working with protocols such as IPv6. 
#. Currently perfSONAR does NOT provide a container image that supports ARM.

QuickStart using the `docker` command
=======================================

These instructions are good for those that want to get a container running quickly using the `docker` command directly. The following assumes that Docker has been successfully installed and is running on the host system. It also assumes that the base host is running a time keeping system such as NTP and is NOT running httpd, postgres, or anything else listening on the list of ports below. The Docker image will share the network stack with the host and so expects to be able to bind to all of the ports as if it were being run natively. 

.. note:: See https://www.perfsonar.net/deployment_security.html for a full listing of ports.

Docker does support the concept of remapping network ports to guests, but is beyond the scope of this model.

We recommend using the `systemd <https://systemd.io/>`_-based version of the Docker container due to its better stability. However, as this version requires the host to support `cgroups v2 <https://docs.kernel.org/admin-guide/cgroup-v2.html>`_, a `supervisord <http://supervisord.org/>`_-based version is also provided (See `Running the Supervisord Image`_). 

As systemd is the system and service manager adopted by most Linux distributions, both installation and management of services are done in the same way inside the container as in a bare metal host. This facilitates the container maintenance and automation. Also, in scenarios where the testpoint container is expected to run for long periods without stopping, systemd guarantees better stability.

First, pull down the latest Docker image::

  # docker pull perfsonar/testpoint:systemd 

This will download the latest built image of the perfsonar testpoint bundle. It includes a base Ubuntu 22.04 install and the perfsonar-testpoint packages. Once the image is downloaded and extracted, start up the container in the background by doing::

  # docker run -td --name perfsonar-testpoint --net=host --tmpfs /run --tmpfs /run/lock --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns host --cap-add CAP_NET_RAW perfsonar/testpoint:systemd

Verify that the container is running::

  # docker ps
  CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS         PORTS     NAMES
  0f98315235ac   perfsonar/testpoint:systemd   "/lib/systemd/systemd"   2 minutes ago   Up 2 minutes             perfsonar-testpoint

.. note:: Your container ID will likely be different than the above. These are generated randomly each time a container is started.

Now you can connect to the running Docker image::

  # docker exec -it <container ID from above> bash

At this point you will be at a bash prompt inside of the container, and may start running tests::

  # pscheduler troubleshoot
  # pscheduler task throughput --dest hostname

Congratulations, you're running perfSONAR in Docker!

Running the container with the `psdocker` script
################################################
If you are attempting the steps in the previous section on a Mac OS X system then the `pscheduler task` command may fail with an error such as `Unable to locate pscheduler server`. This is usually due to the way hostnames are assigned in Docker on Mac. With that in mind the perfSONAR team provides a script that helps setup the container properly (this works on non-Mac systems as well). You can use the script by following the steps below.

Download the *perfsonar-testpoint-docker* git reposiory::

  # git clone https://github.com/perfsonar/perfsonar-testpoint-docker

Start and enter the container with the *psdocker* script::

  # ./perfsonar-testpoint-docker/utils/psdocker

You can leave the container with `exit` command and re-enter it by running the *psdocker* command at anytime.

You can stop the container with the following::

  # ./perfsonar-testpoint-docker/utils/psdocker stop

.. note:: You may also give the start and stop commands an additional parameter that points at a tag representing a specific version of perfSONAR. Example: `psdocker start v4.3.0` to run release 4.3.0 or `psdocker start staging` to run the latest beta.

.. note:: If you find this script useful you may decide to put it in your path. Example: `sudo cp ./perfsonar-testpoint-docker/utils/psdocker /usr/local/bin/psdocker`

Running with `docker-compose`
=============================
`Docker Compose <https://docs.docker.com/compose/>`_ is software that assists in running and managing one or more containers defined in a YAML file. For covenience, perfSONAR provides such a YAML file to assist in setting-up a single testpoint with a shared volume to persist test configurations. This setup can also be used for ad-hoc testers if you find the docker-compose method more convenient than the other options mentioned in previous sections.

.. note:: The following steps require Docker Compose version 2.16.0 or higher to be executed successfully

To obtain the docker-compose file, first download the *perfsonar-testpoint-docker* git repository::

  # git clone https://github.com/perfsonar/perfsonar-testpoint-docker

Next change your working directory to the downloaded directory::

  # cd perfsonar-testpoint-docker

Build the image locally::

  # docker compose -f docker-compose.systemd.yml build

Start the container in the background::

  # docker compose -f docker-compose.systemd.yml up -d

Your container is now running. You can enter the container, verify it is working and add a remote pSConfig file that will be persisted in the `./compose/psconfig` directory::

  # docker compose -f docker-compose.systemd.yml exec -it testpoint bash
  [docker-desktop /]# pscheduler troubleshoot
  [docker-desktop /]# psconfig remote add URL # replace URL with your pSConfig JSON file URL
  [docker-desktop /]# exit

You can stop your container at any time with the following::

  # docker compose -f docker-compose.systemd.yml down

If you bring the container back-up you should be able to see your pSConfig changes still::

  # docker compose -f docker-compose.systemd.yml up -d
  # docker compose -f docker-compose.systemd.yml exec testpoint psconfig remote list


Running the Supervisord Image
=============================

The container image adopted in the previous steps uses `systemd <https://systemd.io/>`_ for managing system processes, aligning with our recommendation for better stability. However, we also offer a version based on `supervisord <http://supervisord.org/>`_ for scenarios where the host does not support cgroups v2, which is required by the systemd-based version.

First, pull down the latest Docker image::

  # docker pull perfsonar/testpoint

Start the container in the background::

  # docker run -d --name perfsonar-testpoint --net=host --cap-add CAP_NET_RAW perfsonar/testpoint

Or you can use `docker Compose <https://docs.docker.com/compose/>`_ to assist in this process.

To obtain the docker-compose file, first download the *perfsonar-testpoint-docker* git repository::

  # git clone https://github.com/perfsonar/perfsonar-testpoint-docker

Next change your working directory to the downloaded directory::

  # cd perfsonar-testpoint-docker

Build the image locally::

  # docker compose build

Start the container in the background::

  # docker compose up -d

Your container is now running. You can enter the container, verify it is working and add a remote pSConfig file that will be persisted in the `./compose/psconfig` directory::

  # docker compose exec -it testpoint bash
  [docker-desktop /]# systemctl status
  [docker-desktop /]# pscheduler troubleshoot
  [docker-desktop /]# psconfig remote add URL # replace URL with your pSConfig JSON file URL
  [docker-desktop /]# exit

You can stop your container at any time with the following::

  # docker compose down

If you bring the container back-up you should be able to see your pSConfig changes still::

  # docker compose up -d
  # docker compose exec testpoint psconfig remote list


Troubleshooting
===============

The easiest way to troubleshoot issues with the Docker image are to connect to it while running. Find the container ID of the running container::

  # docker ps
  CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS         PORTS     NAMES
  0f98315235ac   perfsonar/testpoint:systemd   "/lib/systemd/systemd"   2 minutes ago   Up 2 minutes             perfsonar-testpoint

Connect to the container::

  # docker exec -it <container ID from above> bash

And then do troubleshooting as you would anywhere else in perfSONAR. You can look at various log files, run commands in debug mode, etc.

Managing Upgrades
=================

To upgrade your Docker container, from the parent do the following::

  # docker pull perfsonar/testpoint:systemd

If it reports a message about "Image is up to date" then you are already running the latest version.

You will need to stop the currently running container and start the new version. First figure out the container id of the currently running one::
    
  # docker ps -a
  CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS         PORTS     NAMES
  0f98315235ac   perfsonar/testpoint:systemd   "/lib/systemd/systemd"   2 minutes ago   Up 2 minutes             perfsonar-testpoint
    
Once the container ID is known, have docker shut it down::

  # docker stop <container ID from above>
  # docker rm <container ID from above>
 
.. warning:: Shutting down the container will cause it to lose all state. All scheduled tests will be forgotten and any configuration made that hasn't been committed back to the Docker image will be lost.

And now start up the new one. This process is the same as the first time it was started, but now with the newer image it will start up the new version::

  # docker run -td --name perfsonar-testpoint --net=host --tmpfs /run --tmpfs /run/lock --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns host --cap-add CAP_NET_RAW perfsonar/testpoint:systemd

Your Docker instance of perfsonar-testpoint has now been upgraded to the latest perfSONAR code. 

Advanced: Managing the Firewall
===============================
By default, the docker container does not touch the host firewall. The firewall (iptables) is managed by the Linux kernel and thus the container has to share the firewall with the host system. Additionally, the container does not have permission to run or manage iptables. Therefore, if you intend to configure the firewall, you should ensure to install the **perfsonar-toolkit-security** package on the host system (i.e. outside the container). 

