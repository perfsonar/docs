***********************************
Updating Administrative Information
***********************************

The Toolkit allows you to enter contact and location information about the host. This information will not only display on the main page but will be published in the perfSONAR Lookup Service allowing other testers to find your host. This page contains information on editing this information through the web interface. 

Accessing the Administrative Info Interface
===========================================
#. Open **http://<hostname>** in your browser where **<hostname>** is the name of your toolkit host
#. Click on **Edit** in the host information section of the main page or **Configuration** button in the right-upper corner and login as the web administrator user created in the previous step

    .. image:: images/install_quick_start-admininfo.png

#. Login using the web administrator username and password.
    .. seealso:: See :doc:`manage_users` for more details on creating a web administrator account
	
#. The page that loads can be used to edit your administrative information. See the remainder of this document for details on making specific edits.
    .. image:: images/manage_admin_info-access2.png

Editing Host Information
========================

#. On the **Administrative Information** tab enter the requested information in the provided fields.

    .. image:: images/install_quick_start-admininfo2.png
    
#. The fields are as follows:
    
    .. glossary::

        Organization Name
            The name of the organization to which this host belongs
        
        City
            The city where the host resides
        
        State
            The state, province or other country-specific region where the host resides. May be the 2-letter abbreviation if applicable.
    
        Country
            The country where the host resides
    
        Zip Code
            The postal code of the location where the host resides
    
        Administrator Name
            The full name of a person to contact about this host
    
        Administrator Email
            The email address where correspondence regarding this host may be sent
    
        Latitude
            The latitude of the host as a decimal number between -90 and 90. Note that if you are in the southern hemisphere, this value should be negative.
    
        Longitude
            The longitude of the host as a decimal number between -180 and 180. Note that if you are in the western hemisphere, this value should be negative. 
        
#. When you are done making changes, click **Save** at the bottom of the page

Adding Node Metadata
====================
Node metadata are optional tags that can be used as a means to describe a host on the **Global node directory** page. There are two types of metadata tags:
	.. glossary::
		
		Node Role
			It describes the node roles in the domain. It helps potential users of this node to recognize the place of node installation in the owners' domain. You may select multiple Roles for a node.
			
		Node Access Policy
			It is used to indicate the access policy for a node: whether it's a public access node, private with no access, R&E only or with limited access. You may select only one Access Policy for a node.
			
In order to tag a node with metadata:

    #. In order to add a Node Role, under *Metadata*, click in the field **Node Role**. A drop-down list shows with possible values. Click on a preferred value to select it. Repeat this step to add more tags.
    
            .. image:: images/manage_admin_info-meta1.png
    #. In order to add a Node Access Policy, under *Metadata*, click in the field **Node Access Policy**. A drop-down list shows with possible values. Click on a preferred value.
    
            .. image:: images/manage_admin_info-meta2.png
	#. You may also add a descriptive note in **Access Policy Notes** field which is a human readable text that can optionally be added to help further describe the access policy.
	
    #. Click **Save** to apply your changes 

Deleting Node Metadata
======================
You may remove a particular node metadata with the following steps:
    
    #. Under *Metadata*, find the tag you wish to remove and click **x** beside the name
    
        .. image:: images/manage_admin_info-meta3.png
    #. Click **Save** to apply your changes

Adding a Community
==================

Communities are self-defined tags that can be used as a means to search for a host on the **Global node directory** page. There are two ways to add a new community. One method is to add it manually by typing the community (note that communities are case-sensitive):

    #. Under *Communities*, click **Add a community**
    
            .. image:: images/manage_admin_info-comm1.png
    #. At the prompt, type in the community you want to add (case-sensitive) and click **Add** when done
    
            .. image:: images/manage_admin_info-comm2.png
    #. Click **Save** to apply your changes 

Deleting a Community
====================
You may remove your host from a particular community with the following steps:
    
    #. Under *Communities*, find the community you wish to remove and click **x** beside the name
    
        .. image:: images/manage_admin_info-comm4.png
    #. Click **Save** to apply your changes

