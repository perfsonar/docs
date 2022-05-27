**************
Managing Users
**************
The perfSONAR Toolkit provides utilities for adding, deleting and modifying users that have permissions to access the web interface. All of these tasks could be done through the standard \*NIX command-line tools and the tools provided are mainly for convenience.

.. note::  You will also be prompted to create a user and password that can be used to administer the host through the web interface during the first command line root login to the server. See also :doc:`install_config_first_time`.

.. note:: The perfSONAR Toolkit does not provide any special utilities to create superusers after it is already installed. You will need to use built-in utilities like *visudo* to create privileged users and add them to **pssudo** group (**pssudo** group is installed by perfSONAR Toolkit and allows anyone in pssudo group to have sudo on the machine). Note that any users in the wheel group will NOT be allowed access to the web interface.

.. _manage_users-add-web-user:

Adding a Web User
=================
When adding users to the Toolkit that you want to access the web interface, it is recommended you use the provided script |nptoolkit_script|. To add web users with that script run the following:

#. Login to the system as a root user
#. Run |nptoolkit_script| ::

    /usr/lib/perfsonar/scripts/nptoolkit-configure.py
	
#. At the prompt, select option **2. Manage Web Users**::

    perfSONAR Toolkit customization script
    
    1. Change Timezone
    2. Manage Web Users
    0. exit

    Make a selection: 2

#. Select option **1. Add a new user**::

    Welcome to the perfSONAR Toolkit user administration program.
    This program will help you administer users.
    You may configure any of the options below with this program: 
        1. Add a new user
        2. Delete a user
        3. Change a user's password
        0. exit
    Make a selection:  1

#. Enter the name of the user you would like to add and hit **Enter**::

    Enter the user whose account you'd like to add. Just hit enter to exit: myuser

#. Next enter and confirm the password for the new user::

    New password:
    Re-type new password:
    Adding password for user myuser

#. The new user is added. You may perform other operations with the tool or enter **0** to go back to main menu and then **0** to exit the program.

Deleting a Web User
===================
You may delete a Web user with the |nptoolkit_script|:

#. Login to the system as a root user.
#. Run |nptoolkit_script| ::

    /usr/lib/perfsonar/scripts/nptoolkit-configure.py
	
#. At the prompt, select option **2. Manage Web Users**::

    perfSONAR Toolkit customization script
    
    1. Change Timezone
    2. Manage Web Users
    0. exit

    Make a selection: 2
#. Select option **2. Delete a user**::

    Welcome to the perfSONAR Toolkit user administration program.
    This program will help you administer users.
    You may configure any of the options below with this program: 
        1. Add a new user
        2. Delete a user
        3. Change a user's password
        0. exit
    Make a selection:  2

#. Type the name of the user you would like to delete and confirm::

    Enter the user whose account you'd like to remove. Just hit enter to exit: myuser

#. The user is deleted. You may perform other operations with the tool or enter **0** to go back to main menu and then **0** to exit the program. 

Changing a Web User's Password
==============================
You may change a web user's password with the |nptoolkit_script|:

#. Login to the system as a root user.
#. Run |nptoolkit_script| ::

    /usr/lib/perfsonar/scripts/nptoolkit-configure.py
	
#. At the prompt, select option **2. Manage Web Users**::

    perfSONAR Toolkit customization script
    
    1. Change Timezone
    2. Manage Web Users
    0. exit

    Make a selection: 2 
#. Select option **3. Change a user's password**::

    Welcome to the perfSONAR Toolkit user administration program.
    This program will help you administer users.
    You may configure any of the options below with this program: 
        1. Add a new user
        2. Delete a user
        3. Change a user's password
        0. exit
    Make a selection:  3
#. Type the name of the user with the password you would like to change::

    Enter the user whose password you'd like to change. Just hit enter to exit: myuser
    
#. Type and confirm the new password::

    Please specify a password for the myuser account.
	New password:
	Re-type new password:
	Updating password for user myuser

#. Normal precautions should be taken to protect the password as it can be used to access the system. For example, safe password practices would recommend a password that contains a mixture of letters of different case, numbers, symbols, and a length greater than 8. It is also not recommend to re-use passwords on multiple machines, in the event of a system breach. 
#. The user's password is now changed. You may perform other operations with the tool or enter **0** to go back to main menu and then **0** to exit the program.

.. |nptoolkit_script| replace:: */usr/lib/perfsonar/scripts/nptoolkit-configure.py*
