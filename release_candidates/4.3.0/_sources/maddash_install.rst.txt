************************
MaDDash Installation
************************

Installation Options
=====================
MaDDash can be installed one of two ways:

1. As a standalone package on any perfSONAR supported operating system
2. As part of the perfSONAR CentralManagement bundle. See :doc:`install_options` for more information.

MaDDash installs the following packages:

* *maddash* - Container package that has dependencies on packages below. The package itself does not install any additional software, it simply pulls in the aforementioned packages.
* *maddash-server* - The backend server that schedules checks and makes results available via a REST/JSON interface running on an embedded web server. This package has a dependency on java which will also be installed during the yum installation process.
* *maddash-webui* - The web pages that display the dashboard. It consists of a set of CGI scripts that run under Apache. The server contacts the REST server run by the maddash-server package and then presents the data on the web page.
* *nagios-plugins-perfsonar* - Installs the perfSONAR Nagios checks that can alarm based on throughput, loss and other data returned by perfSONAR services.
* *perfsonar-graphs* - Provides the performance graphs used by the maddash-webui package for perfSONAR checks.

Installing MaDDash on CentOS
=====================================
MaDDash can be installed with the following commands::

    yum install epel-release http://software.internet2.edu/rpms/el7/x86_64/latest/packages/perfSONAR-repo-0.9-1.noarch.rpm
    yum clean all
    yum install maddash

Installing MaDDash on Debian/Ubuntu
=====================================
MaDDash can be installed with the following commands::

    cd /etc/apt/sources.list.d/
    wget http://downloads.perfsonar.net/debian/perfsonar-release.list
    wget -qO - http://downloads.perfsonar.net/debian/perfsonar-official.gpg.key | apt-key add -
    apt-get update
    apt-get install maddash
        
