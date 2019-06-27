******************************
pScheduler Disk-to-Disk Tests
******************************

Overview
---------
This document describes how to install the plug-in for perfSONAR disk-to-disk tests. This includes tools for standard curl tool as well as GridFTP using Globus. The sections below walk-through the following:
 
 #. How to setup your yum repositories to use the *nightly* perfSONAR repo that contains the disk-to-disk test plugin and associated tools.
 #. Installing perfSONAR and the new plugins using yum
 #. Configuring Globus using provided Ansible roles
 #. Commands for performing disk-to-disk transfers with pScheduler
 #. Adding tests to pSConfig and MaDDash

Configuring Yum Repositories
------------------------------------
You need to use the perfSONAR nightly yum repository to get the plug-ins. **It is NOT recommended you do this on a production host** as the nightly repository contains software still under active development. You can setup the repository with the commands below::
 
    yum install epel-release
    yum install https://perfsonar-dev3.grnoc.iu.edu/nightly/el/7/x86_64/perfsonar/minor/packages/perfSONAR-repo-nightly-minor-0.9-1.noarch.rpm
    yum clean all

Installing perfSONAR
------------------------------------
Once the nightly repository is configured you can install perfSONAR and the associated plug-ins using the commands below::

    yum install perfsonar-testpoint pscheduler-test-disk-to-disk pscheduler-tool-curl pscheduler-tool-globus

Configuring Globus
---------------------------

The perfSONAR project has a set of Ansible rules that help you install and configure `Globus <https://www.globus.org/>`_. It will handle pointing at the Globus yum repos, install required RPMs and make necessary edits to the Globus configuration. First, make sure you have git and ansible installed on your system::

    yum install ansible git

Next clone the ansible rules and run the playbook::


    git clone https://github.com/nathanShepherd/Playbook-setup-globus-server.git
    cd Playbook-setup-globus-server
    ansible-playbook main.yml --user root --ask-pass

The last command will ask for three inputs:

  #. At the first prompt requesting an SSH password, just hit enter.
  #. Enter a name for your Globus endpoint. It is just an identifier used by Globus, the hostname is good choice if you need an idea for a name.
  #. Enter whether you want the host to be published publicly by Globus. Your answer will not affect your ability to test with pScheduler.

After the prompts you will need to wait for the playbook to finish setup. 

Next, you will need to get a Globus ID if you do not already have one. You can get one by visiting http://globusid.org. After you have a Globus ID run the following commands and enter your Globus ID when prompted (NOTE: you do not need to include the *@globusid.org* portion of the username at the prompt)::

    globus-connect-server-setup

After the command completes, you can verify Globus is running by looking at the process list and verifying you see at least one Globus process::

    ps auxw | grep globus

Next you can verify that you can perform a simple transfer with the `globus-url-copy` command directly with the following command::

    globus-url-copy -vb -fast ftp://sunn-dtn.es.net:2811/data1/10M.dat file:///tmp/manual-test.out

Assuming all of the above work as expected, you are now ready to try transfers with pScheduler.

Running Disk-to-Disk Transfers with pScheduler
-------------------------------------------------

GridFTP Test
============
::
    
    pscheduler task --tool globus disk-to-disk --source ftp://sunn-dtn.es.net:2811/data1/10M.dat --dest file:///tmp/test.out --timeout PT10S

.. note:: See https://fasterdata.es.net/performance-testing/DTNs/ for a list of GridFtp servers that can be used for testing*

Standard Curl Test
===================
::
    
    pscheduler task --tool curl disk-to-disk --source ftp://speedtest.tele2.net/1KB.zip --dest /tmp/test.out --timeout PT5S

.. note:: See `pscheduler task disk-to-disk --help` for a full list of options

Configuring pSConfig and MaDDash
------------------------------------

You can add `disk-to-disk` tests to a pSConfig template. There is a lot of flexibility in how you define your tests, but one example can be found here: https://raw.githubusercontent.com/perfsonar/perfsonar-dev-mesh/master/psconfig/gridftp.json

Once you have the test added to the pSConfig template and assuming you are storing them in esmond, then the MaDDash agent will automatically create a dashboard for you that alarms on throughput. For more information on setting up MaDDash see the MaDDash :maddash_quick_install:`quick install guide`.

