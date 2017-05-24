******************************
perfSONAR on Mac OSX
******************************

perfSONAR's pscheduler tool is not yet supported on OSX, so currently the best way to run perfSONAR tools is via a Linux container on OSX.
This is easy to do using tools such as Docker or Vagrant.

Docker
======

Install Docker for Mac, as described at:
   https://docs.docker.com/docker-for-mac/install/ 
 
First, start docker.
Then, open a terminal window and type::

  docker pull perfsonar/tools
  docker run -d -P --net=host -v /var/run perfsonar/tools
 
Next, get the container ID:: 

  docker ps -a
 
Then attach to the container::

  docker exec -it ID bash
 
Now you can run pscheduler commands from your Mac, such as::

  pscheduler task --assist remoteHost1 throughput --source remoteHost1 --dest remoteHost2


Note that you must use the --assist flag to tell pScheduler to use one of the remote systems to manage the scheduling of the test.

When done, type 'exit' to leave the container.
 
 

Vagrant
=======

Vagrant containers are another option. See 
https://www.vagrantup.com/intro/getting-started/index.html
for more information.





