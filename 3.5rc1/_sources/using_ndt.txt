*****************************
Network Diagnostic Tool (NDT)
*****************************

NDT can be used to help indentify some types of network problems such as bottleneck link detection
and duplex mismatch detection. 

To connect to the NDT server, click on the link under "Services Offered" on the perfSONAR Toolkit 
home page. You will need to use a browser that supports Java such as Firefox.

Note that NDT requires TCP reno, and does not work with cubic. If you enable NDT on your host,
your iperf throughput results will likely be lower, as TCP reno recovers from loss more slowly than cubic.

We strongely recommend that NDT be run on a separate perfSONAR toolkit instance, and not on the same host
doing regular bwctl or owamp testing, as NDT tests will likely impact other test results.

For more information on NDT, see:
 * http://software.internet2.edu/ndt/
 * https://www.perfsonar.net/about/faq/#Q4
 * http://e2epi.internet2.edu/npw/jt07-umn/ndt-background-tutorial.pdf



