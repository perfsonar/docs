****************************************
User Guide
****************************************

pSConfig Web Admin (PWA) allows you to configure meshes using a Web-based administrative interface. You can also add more users and collaborate on the the configs with other people.

There are a few steps you need to complete to create a working configuration.

#.
    Make sure the hosts you need exit under the ``Hosts`` section; these may be hosts from the Lookup Service, or hosts you add yourself (``ad-hoc``)

#.
    Create a ``Testspec`` for all the tests you want to run

#.
    Create a ``Hostgroups`` for each test type you want to run - select a test type and select hosts to be used in the hostgroup.

#.
    Create a ``Config``, where you pull together ``Testspecs``, ``Hostgroups``, and measurement archive information. These ``Configs`` can be accessed in pSConfig format and/or MeshConfig format.

``Hostgroups`` and ``Testspecs`` can be reused across multiple ``Configs``. 


Before you can start using PWA, you have to create at least one user account. Note that public registration is disabled by default. Read `User Management <pwa_user_management>`_ for details on this.

If you added a user via the CLI, you should be able to login. If you registered an account through the web interface, you may be prompted to confirm the ownership of the email address by following the confirmation URL in an email sent by the authentication service (or not, depending on your configuration).

You may edit existing entities with your name listed under "Admins" list for each entity. Certain features, such as to override the MA endpoints, requires you to have super-admin privileges. Please see :doc:`pwa_user_management` for more details.

.. toctree::
   :maxdepth: 1

   pwa_userguide_intro
   pwa_userguide_hostgroup
   pwa_userguide_testspec
   pwa_userguide_config
   pwa_userguide_host
 
