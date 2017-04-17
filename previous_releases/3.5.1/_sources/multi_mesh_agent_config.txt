************************************
Reading a Central Configuration File
************************************

Participating in a centrally configured mesh  is a matter of the following:

 #. :ref:`Finding <multi_agent_config-find>` a mesh in which you want to participate
 #. :ref:`Editing <multi_agent_config-config>` a file on your perfSONAR Toolkit with the URL of the central configuration file(s) you wish to use.  

.. _multi_agent_config-find:

Finding a Test Mesh
===================
Currently finding centrally configured meshes in which to participate is largely an out-of-band process. You will need to obtain a URL to a configuration file in order to participate. It is possible to simultaneously participate in multiple meshes (a well as :doc:`manually <manage_regular_tests>` define your own tests) so don't feel like you are limited by what's in a single mesh configuration file. 

The best way to discover meshes is to talk to others you test with (or would like to test with) to see if they are participating in any meshes. If not, it may be worth :doc:`creating one <multi_mesh_server_config>`. If you do find a mesh in which you'd like to participate, be sure to talk to the administrator of the file. It's not only polite, but you cannot use that file to generate tests with the MeshConfig software unless they add the address(es) of your host(s)!


.. _multi_agent_config-config:

Configuring a Host To Participate in a Mesh
============================================

Once you have the URL(s) you would like to use for you mesh configuration file, you simply need to add it to a *mesh* block in :ref:`agent_configuration.conf <config_files-meshconfig-conf-agent>`. In this block you can define the URL as follows::

    <mesh>
        configuration_url             https://host.otherdomain.edu/mesh.json
    </mesh>

Additionally if a mesh config is hosted by a server running https you can add further options to validate the certificate. This ensures the server you are talking to is the one you expect and is recommended in most cases. The options to do this are *ca_certificate_file* containing a path to a certificate bundle used to verify the server's certificate and the *validate_certificate*. The latter option not only validates *ca_certificate_file* against the server but also verifies information such as the hostname matches the certificate distinguished name. An example is shown below::

    <mesh>
        configuration_url            https://host.otherdomain.edu/mesh.json
        validate_certificate         1
        ca_certificate_file          /etc/pki/tls/bundle.crt
    </mesh>

You may add multiple mesh blocks to the file to participate in multiple meshes. Also note that any :doc:`manually <manage_regular_tests>` defined tests will remain intact. See the agent configuration section of :doc:`config_mesh` for more details on options in this file.

Your regular tests will be updated nightly by a :ref:`cron script <config_files-meshconfig-cron-generate_configuration>`. If you would like to update your regular tests sooner then manually run the following:

    /usr/lib/perfsonar/bin/generate_configuration