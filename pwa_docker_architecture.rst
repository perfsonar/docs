PWA Docker Deployment Architecture
==================================

PWA is deployed using a series of docker containers; some are PWA-specific and provided by the perfSONAR project, and there are a couple of third-party containers involved, as well.

=========   ===========
Container   Description
=========   ===========
pwa-admin   PWA UI and API
pwa-pub     Publisher, used for publishing Configs defined in PWA
sca-auth    Authentication module used by the GUI
nigninx     Web server, used as a proxy to access the PWA and SCA components
mongodb     MongoDB, used by pwa-admin and pwa-pub
postfix     Optional, if you want to run a mail server in another docker container, install this
=========   ===========

Architecture Overview
---------------------

This example architecture assumes you name your instances like pwa-admin1, pwa-pub1, pwa-pub2, etc. You can name them differently if you like. You can increase the number of publishers to improve publisher performance, if needed. 

.. image:: images/pwa/pwa_docker_architecture_600.png
   :target: ./_images/pwa_docker_architecture.png
   :width: 600px
   :alt: PWA Docker Architecture screenshot
