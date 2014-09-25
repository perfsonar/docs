********************
Updating the Toolkit
********************

To upgrade from perfSONAR Toolkit 3.3.X to 3.4.X, all you need to do log into the host, su to the admin user,
and type 'yum update'. After the yum update is complete, you'll need to reboot. 

All data in your old measurement
archive will automatically get migrated to the new measurement archive. Depending on how much data is there,
this could take up to 24 hours.

Then log into the Toolkit admin GUI, and make sure the 'administrative information' is correct. 
In particular, check the latitude/longitude values.

Upgrades from perfSONAR Toolkit 3.2.x are not supported. You'll just need to do a fresh install.

