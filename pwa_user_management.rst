*************
User Management
*************

Default Configuration
=====================

By default, PWA ships with account registration disabled, and with no accounts created. You either need to enable registration, or create one or more super-admin accounts (see below).

Interacting with the ``sca-auth`` service
==========================================

``sca-auth`` runs within a Docker container; there are two ways to run commands within a docker container.

1. ``docker exec -it <container> <command>`` - this allows you to execute something inside the container without actually interactively entering the container. This is useful for one-off or scripted commands. For example, this gives you a list of all the users.

   ::

        $ sudo docker exec -it sca-auth /app/bin/auth.js listuser

2. ``docker exec -it <container> bash`` - this starts an interactive bash shell within the container.

   ::

        $ sudo docker exec -it bash

        root@301be8a679c7:/# /app/bin/auth.js listuser

The two examples above are equivalent. To exit a bash shell, type ``exit``

**Running SCA commands**

You can run SCA commands by running commands inside the ``sca-auth`` container, using either method above.

sca-auth Commands
==================

**NOTE:** before changes to user roles go into effect, the user has to log out and then re-authenticate.

Listing accounts
----------------

::

    /app/bin/auth.js listuser


Creating accounts
------------------

Create a new user
 
::

    /app/bin/auth.js useradd --username <user> --fullname "<name>" --email "<email>" [--password "<password>"]




Modifying roles
------------

Add PWA access for a user

::

    /app/bin/auth.js modscope --username user --add '{"pwa": ["user"]}'

Make a user a PWA super-admin:

::

    /app/bin/auth.js modscope --username user --add '{"pwa": ["user", "admin"]}'

Reset password

::

    /app/bin/auth.js setpass --username user --password "password#123"

Modify (set/add/del) user scopes

::

/app/bin/auth.js modscope --username user --set '{"pwa": ["user", "admin"]}'
/app/bin/auth.js modscope --username user --add '{"pwa": ["user", "admin"]}'
/app/bin/auth.js modscope --username user --del '{"pwa": ["user", "admin"]}'

remove user

::

    /app/bin/auth.js userdel --username user

