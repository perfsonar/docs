******************
BWCTL Limits File
******************

You can control access to the bwctl server via the file /etc/bwctl-server/bwctl-server.limits.

Information on how to use this file can be found at:
  * http://software.internet2.edu/bwctl/bwctld.limits.man.html

By default, the perfSONAR toolkit allows access from anywhere, and limits TCP tests to 60 seconds, and UDP tests to 100Mbps and 30 seconds.

ESnet generates a nightly update of bwctl-server.limits that allows testing from all Research and Education networks around the world, and nothing else.

Information on how to use this file is available at :docs:`manage_limits`.

