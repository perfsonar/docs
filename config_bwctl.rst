*****
BWCTL
*****

By default, the /etc/bwctld/bwctld.conf on the perfSONAR toolkit uses the following ports:

   .. code-block:: none

    # bwctl control channel 
    peer_port       6001-6200
    # bwctl measurement test ports
    test_port       5001-5900


You can edit that file if you want to change those port ranges. Note that if you make the port
range too small, tests to/from your host will fail. 

More information on bwctld.conf is available at:
  * http://software.internet2.edu/bwctl/bwctld.conf.man.html

