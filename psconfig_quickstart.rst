******************************
pSConfig Quickstart Guide
******************************

.. note:: This page contains a quick set of commands for publishing a pSConfig template and configuring the pScheduler and Grafana agents to use them. As the *Quickstart* in the title implies, this is not intended to be a comprehensive guid, for that see the rest of the :doc:`pSConfig documentation<psconfig_intro>`.


On the host where the template is to be published...
==========================================================
#. Make sure the ``perfsonar-psconfig-publisher`` package is installed:

    *CentOS*::
    
        yum install perfsonar-psconfig-publisher

    *Debian/Ubuntu*::
    
        DEBIAN_FRONTEND=noninteractive apt-get install perfsonar-psconfig-publisher
#. Create a pSConfig template.
#. Publish the template::

    psconfig publish template.json
    
    
On each host running measurements...
==========================================================
#. Make sure the ``perfsonar-psconfig-pscheduler`` package is installed:

    *CentOS*::
    
        yum install perfsonar-psconfig-pscheduler

    *Debian/Ubuntu*::
    
        DEBIAN_FRONTEND=noninteractive apt-get install perfsonar-psconfig-pscheduler
#. Run the following command to point the agent at the template::

    psconfig remote add https://MYHOST/psconfig/template.json
    
On your Grafana host...
==========================================================
#. Make sure the ``perfsonar-psconfig-grafana`` package is installed:

    *RedHat*::
    
        dnf install perfsonar-psconfig-grafana

    *Debian/Ubuntu*::
    
        DEBIAN_FRONTEND=noninteractive apt-get install perfsonar-psconfig-grafana
#. Run the following command to point the agent at the template::

    psconfig remote add https://MYHOST/psconfig/template.json
