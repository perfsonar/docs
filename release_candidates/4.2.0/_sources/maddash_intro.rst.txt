*******************************************
What is MaDDash?
*******************************************

The Monitoring and Debugging Dashboard (MaDDash) software is aimed at collecting and presenting two-dimensional monitoring data as a set of grids referred to as a dashboard. Many monitoring systems focus on one dimension, such as a single host or service. Unfortunately, users can quickly run into n-squared problems both in terms of configuration on the back-end and data presentation on the front-end if you try to present naturally two-dimensional data in this manner. 

The classic use case is point-to-point network measurements between two hosts. For every host in the set, you want to know some performance metric to every other host. You don't want to add a large configuration block for every host. You also don't want to do things like only look at the results in aggregate or be presented with a long list of every host pair. MaDDash addresses this by reading a configuration file where the two-dimensional grids are defined using specialized structures, running a set of jobs based on this configuration (usually a set of `Nagios <http://www.nagios.org>`_ checks), then storing the results. These results can then be accessed using a REST API which provides the building blocks for components such as the included web interface that presents the data as a set of grids. 

As such network monitoring is a primary focus of most deployments, but it is relatively agnostic to the data being collected and displayed so can be adapted to any case where a two-dimensional relationship is formed. 
 


