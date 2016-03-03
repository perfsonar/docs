**************
Managing Users
**************
The perfSONAR Toolkit provides utilities for adding, deleting and modifying users. In particular it helps with the management of users that have permissions to access the web interface or login to the host via SSH. All of these tasks could be done through the standard \*NIX command-line tools and the tools provided are mainly for convenience .

Adding a User
=============
When adding users to the toolkit, in particular those that you want to access the web interface or SSH into the host, it is recommended you use the provided script |nptoolkit_script|. To add users with that script run the following:

#. Login to the system as a root user
#. Run |nptoolkit_script|
#. At the prompt, select option *3. Manage Users*::

    perfSONAR Toolkit customization script
    
    1. Configure Networking
    2. Change Timezone
    3. Manage Users
    0. exit

    Make a selection: 3   
#. Select option *1. Add a new user*::

    Welcome to the perfSONAR Toolkit user administration program.
    This program will help you administer users.
    You may configure any of the options below with this program: 
        1. Add a new user
        2. Delete a user
        3. Change a user's password
        0. exit
    Make a selection:  1
#. Enter the name of the user you would like to add and hit *Enter*:
   
    ::

        Enter the user whose account you'd like to add. Just hit enter to exit: myuser

    .. warning:: You may not create a user with name *psadmin* as it will conflict with an existing group.

#. At the next prompt enter *yes* or *no* if you want the user to be able to login via SSH. Alternatively leave the input blank and it will default to *yes*.::

    Should this user be able to login via SSH? [yes]
#. At the next prompt enter *yes* or *no* if you want the user to be able to manage the host through the web interface. Alternatively leave the input blank and it will default to *yes*.:

    ::

        Should this user be able to login to the web interface? [yes]
    
    .. note:: Under the covers, this adds the user to the system group *psadmin*.
#. Next enter and confirm the password for the new user::

    Please specify a password for the myuser account.
    Changing password for user myuser.
    New password: 
    Retype new password: 
    passwd: all authentication tokens updated successfully.
#. The new user is added. You may enter **0** to exit the program or perform other operations with the tool. 

.. note:: The perfSONAR Toolkit does not provide any special utilities to create superusers. You will need to use built-in utilities like *visudo* to create privileged users. This is a change as of 3.4 of the perfSONAR Toolkit. Note that any users in the wheel group will NOT be allowed access to the web interface.  The **psadmin** group is provided as a special group for web administrators.


Deleting a User
==========================
You may delete a user with the |nptoolkit_script|:

#. Login to the system as a root user
#. Run |nptoolkit_script|
#. At the prompt, select option *3. Manage Users*::

    perfSONAR Toolkit customization script
    
    1. Configure Networking
    2. Change Timezone
    3. Manage Users
    0. exit

    Make a selection: 3   
#. Select option *2. Delete a user*::

    Welcome to the perfSONAR Toolkit user administration program.
    This program will help you administer users.
    You may configure any of the options below with this program: 
        1. Add a new user
        2. Delete a user
        3. Change a user's password
        0. exit
    Make a selection:  2
#. Type the name of the user you would like to delete::

    Enter the user whose account you'd like to remove. Just hit enter to exit: myuser
#. at the next prompt, enter *yes* or *no* if you would like to delete the user's home directory (default is *yes*)::
    
    Would you like to delete test3's home directory? [yes]
#. The new user is deleted. You may enter **0** to exit the program or perform other operations with the tool. 

Changing a User's Password
==========================
You may change a user's password with the |nptoolkit_script|:

#. Login to the system as a root user
#. Run |nptoolkit_script|
#. At the prompt, select option *3. Manage Users*::

    perfSONAR Toolkit customization script
    
    1. Configure Networking
    2. Change Timezone
    3. Manage Users
    0. exit

    Make a selection: 3   
#. Select option *3. Change a user's password*::

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
    Changing password for user myuser.
    New password: 
    Retype new password: 
    passwd: all authentication tokens updated successfully.

#. Normal precautions should be taken to protect the password as it can be used to access the system. For example, safe password practices would recommend a password that contains a mixture of letters of different case, numbers, symbols, and a length greater than 8.  It is also not recommend to re-use passwords on multiple machines, in the event of a system breach. 
#. The new user's password is now changed. You may enter **0** to exit the program or perform other operations with the tool. 

.. |nptoolkit_script| replace:: */usr/lib/perfsonar/scripts/nptoolkit-configure.py*