*********************************
BWCTL Server Configuration File
*********************************

By default, the /etc/bwctl-server/bwctl-server.conf on the perfSONAR toolkit uses the following ports:

   .. code-block:: none

    # bwctl control channel 
    peer_port       6001-6200
    # bwctl measurement test ports
    test_port       5001-5900


You can edit that file if you want to change those port ranges. Note that if you make the port
range too small, tests to/from your host will fail. 

You can also control what tests are allowed using bwctl-server.conf. For example, if want to allow
bwctl-server to run low bandwidth tools like ping and owping, but not throughput tools, you can use 'disable_[tool name]'.
For example:

   .. code-block:: none

    # disable throughput tools
    disable_iperf3
    disable_iperf
    disable_nuttcp


More information on bwctl-server.conf is available at:
  * http://software.internet2.edu/bwctl/bwctld.conf.man.html

