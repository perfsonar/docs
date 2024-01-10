***************************************
Viewing Legacy Esmond Data
***************************************

Starting with perfSONAR 5.0, the data archive used to store measurements was replaced. On Toolkit installations, the data was left on disk but not imported into a new database. If you need to access the data, it is required you copy it to a new host running esmond.

This document will walk you through the process of copying legacy Esmond data from a Toolkit host to a new standalone Esmond instance.

Requirements
============================================
In order to complete this process there are a few requirements:

 - You have two hosts: 1) The Toolkit host with the old data you wih to migrate (host referred to as "Toolkit" for remainder of document) and 2) The new standalone Esmond host (host referred to as "Esmond" through remainder of this document)
 - Both the toolkit host and the esmond host have the same operating system, PostgreSQL, and Cassandra versions. Generally if both systems are up-to-date this should be the case.
 - The Toolkit host has SSH access to the Esmond host

Migration Process
===============================================
A summary of the migration process can be broken into three sections as follows:

1. You will setup the new Esmond host
2. You will use scp to copy the data from the toolkit host to the Esmond host
3. You will move the copied data to the correct locations on the Esmond host and restart relevant services

After that you have a new standalone esmond. The detailed steps are found in the sections below. 

Step 1: Preparing the new Esmond host
----------------------------------------------
1. Become sudo::

    sudo -s

2. Install perfSONAR RPM Repo key::

    curl http://linux.mirrors.es.net/perfsonar/RPM-GPG-KEY-perfSONAR -o /etc/pki/rpm-gpg/RPM-GPG-KEY-perfSONAR

3. You will need to point your system at an old perfSONAR package repository. In order to do so, run the following command::

    cat << EOF > /etc/yum.repos.d/perfsonar4.repo
    [perfSONAR4]
    name = perfSONAR 4.0 RPM Repository
    baseurl = http://linux.mirrors.es.net/perfsonar/el7/x86_64/4
    enabled = 1
    protect = 0
    gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-perfSONAR
    gpgcheck = 1
    EOF

4. Clear the yum cache to make sure it sees your new repository::

    yum clean all

5. Install the esmond package::

    yum install -y esmond

6. Check that esmond install properly. The below command should return `[]` if things are working::

    curl -k "https://localhost/esmond/perfsonar/archive/"



Step 2: Copying Data From Toolkit to Standalone Esmond Instance
------------------------------------------------------------------------------------
1. SSH into you Toolkit host and become sudo::

    sudo -s

2. Copy postgresql data to Esmond host (where USER and ESMOND_HOST are replaced with the username and address of the ESMOND host respectively)::

    scp -r /var/lib/pgsql/ USER@ESMOND_HOST:pgsql

3. Copy cassandra data to Esmond host::

    scp -r /var/lib/cassandra/ USER@ESMOND_HOST:cassandra

4. Copy old Esmond configuration to Esmond host::

    scp -r /etc/esmond/ USER@ESMOND_HOST:esmond


Step 3: Installing and Configuring Esmond
------------------------------------------

1. Log back into the Esmond host and make sure you are sudo::

    sudo -s

2. Install the copied postgresql data::

    systemctl stop postgresql-10
    rm -rf /var/lib/pgsql
    mv pgsql /var/lib/pgsql
    chown -R postgres:postgres /var/lib/pgsql
    systemctl start postgresql-10

3. Install the copied cassandra data::

    systemctl stop cassandra
    rm -rf /var/lib/cassandra
    mv cassandra /var/lib/cassandra
    chown -R cassandra:cassandra /var/lib/cassandra
    systemctl start cassandra

4. Install the esmond configuation::

    systemctl stop httpd
    rm -rf /etc/esmond
    mv esmond /etc/esmond
    chown -R root:root /etc/esmond
    restorecon /etc/esmond/esmond.conf
    systemctl start httpd

5. Verify the installation. The following command should return test results if the above worked correctly::

    curl -k "https://localhost/esmond/perfsonar/archive/?limit=10"

If you get any errors after completing the steps above there are a few things to check:

- Look for hints as the problem in `/var/log/httpd/ssl_error_log`, `/var/log/esmond/django.log` and `/var/log/esmond/esmond.log`
- The install should work with SELinucx but you may want to test with selinux disabled to see if that is causing issues: `setenforce 0` and re-run curl commands above.
- Double check the file permissions and ownership. You can always compare these things to the original host.


Accessing the Esmond host data
===============================

The data for your new esmond host is available at `https://ESMOND_HOST/esmond/perfsonar/archive/` where ESMOND_HOST is replaced with the name of your hosts.

If you want to look at graphs using this archive, you can manipulate the URL of an existing graphs install (it does not need to be on the same host, though you can install the graphs locally with `yum install perfsonar-graphs`). For example, lets say I am looking at a graph on my 5.0 Toolkit host that looks like the following:

  https://TOOLKIT_HOST/perfsonar-graphs/?source=10.1.1.1&dest=10.1.1.2&url=https://TOOLKIT_HOST/esmond/perfsonar/archive/&timeframe=1w

You can copy paste this URL and replace the `url` parameter to look at the Esmond instance with the old data:

  https://TOOLKIT_HOST/perfsonar-graphs/?source=10.1.1.1&dest=10.1.1.2&url=https://ESMOND_HOST/esmond/perfsonar/archive/&timeframe=1w