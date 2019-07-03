***************
User Management
***************

Default Configuration
=====================

By default, PWA ships with account registration disabled, and with no accounts created. You either need to enable registration, or create one or more super-admin accounts (see below).

This interaction is slightly different between docker and RPM installs

Interacting with the ``sca-auth`` service (rpm)
==================================================

Everything is the same as below, except you can ignore the Docker commands, and rather than ``/app/bin/auth.js``, you run ``/usr/sbin/pwa_auth``

Interacting with the ``sca-auth`` service (docker)
==================================================

``sca-auth`` runs within a Docker container; there are two ways to run commands within a docker container.

1. ``docker exec -it <container> <command>`` - this allows you to execute something inside the container without actually interactively entering the container. This is useful for one-off or scripted commands. For example, this gives you a list of all the users.

   .. code-block:: shell

        $ sudo docker exec -it sca-auth /app/bin/auth.js listuser

2. ``docker exec -it <container> bash`` - this starts an interactive bash shell within the container.

   .. code-block:: shell

        $ sudo docker exec -it bash

        root@301be8a679c7:/# /app/bin/auth.js listuser

The two examples above are equivalent. To exit a bash shell, type ``exit``

**Running SCA commands**

You can run other SCA commands by running commands inside the ``sca-auth`` container, using either method above.

sca-auth Commands
=================

**NOTE:** before changes to user roles go into effect, the user has to log out and then re-authenticate.

Listing accounts
----------------

Docker

.. code-block:: shell

    /app/bin/auth.js listuser

RPM

.. code-block:: shell

    /usr/sbin/pwa_auth listuser

The commands for RPM installs are the same as the Docker ones, simply with pwa_auth rather than auth.js.


Creating accounts
-----------------

Create a new user
 
.. code-block:: shell

    /app/bin/auth.js useradd --username <user> --fullname "<name>" --email "<email>" [--password "<password>"]


Modifying roles
---------------

Add PWA access for a user

.. code-block:: shell

    /app/bin/auth.js modscope --username user --add '{"pwa": ["user"]}'

Certain features in PWA are restricted to only super-admin. In order to become a super-admin, you will need to run following as root via the command line.

Make a user a PWA super-admin:

.. code-block:: shell

    /app/bin/auth.js modscope --username user --add '{"pwa": ["user", "admin"]}'

Reset password

.. code-block:: shell

    /app/bin/auth.js setpass --username user --password "password#123"

Modify (set/add/del) user scopes

.. code-block:: shell

    /app/bin/auth.js modscope --username user --set '{"pwa": ["user", "admin"]}'
    /app/bin/auth.js modscope --username user --add '{"pwa": ["user", "admin"]}'
    /app/bin/auth.js modscope --username user --del '{"pwa": ["user", "admin"]}'

Remove a user

.. code-block:: shell

    /app/bin/auth.js userdel --username user

