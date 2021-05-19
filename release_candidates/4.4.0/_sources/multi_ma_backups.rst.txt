***********************************
Managing Measurement Archive Data
***********************************

As you collect measurements over time, there are some common tasks you may wish to perform such as:

* Backing-up the data
* Migrating the data to new hardware
* Deleting old data

The measurement archive software, esmond, keeps data in two databases: `Cassandra <https://cassandra.apache.org>`_ and `PostgreSQL <http://www.postgresql.org>`_. Both of these databases need to be considered when performing any of the operations listed above. The remainder of this document covers the options and steps needed to perform each of these data management tasks.

Backing-up and Restoring Data
=============================

You may want to back-up data in case of a failure. Both Cassandra and PostgreSQL offer multiple options for backing-up and restoring data. A few common options are:

* **Using built-in replication features of each database** - See :doc:`multi_ma_clustering` for more details
* **Using existing tools to create snapshots** - The remainder of this section discusses how to do this for both Cassandra and PostgreSQL

.. _multi_ma_backups-snapshots-cassandra:

Cassandra Snapshots with `nodetool`
-----------------------------------

.. _multi_ma_backups-snapshots-cassandra-prep:

Preparing Your Environment
##########################
Cassandra comes with a command called *nodetool* that is capable of performing a number of administrative operations. One such operation is creating and restoring snapshots of the data. In order to make sure your cassandra server can use nodetool, login to your cassandra host(s) and do the following:

#. Uncomment or add the following at the bottom of */etc/cassandra/conf/cassandra-env.sh*::

    LOCAL_JMX=yes

    if [ "$LOCAL_JMX" = "yes" ]; then
      JVM_OPTS="$JVM_OPTS -Dcassandra.jmx.local.port=$JMX_PORT -XX:+DisableExplicitGC"
    else
      JVM_OPTS="$JVM_OPTS -Dcom.sun.management.jmxremote.port=$JMX_PORT"
      JVM_OPTS="$JVM_OPTS -Dcom.sun.management.jmxremote.rmi.port=$JMX_PORT"
      JVM_OPTS="$JVM_OPTS -Dcom.sun.management.jmxremote.ssl=false"
      JVM_OPTS="$JVM_OPTS -Dcom.sun.management.jmxremote.authenticate=true"
      JVM_OPTS="$JVM_OPTS -Dcom.sun.management.jmxremote.password.file=/etc/cassandra/jmxremote.password"
    fi

#. Restart cassandra::

    service cassandra restart


Creating the Snapshot
##################### 
You can create a snapshot of the esmond data with the following command::
    
    nodetool snapshot esmond -t esmond_snapshot

You may use a different value for -t, it is just a label for the snapshot. If -t is not specified a Unix timestamp of the current time will be used. Assuming you use esmond_snapshot as your value for -t the command will create the following directories:

* /var/lib/cassandra/data/esmond/base_rates/snapshots/esmond_snapshot
* /var/lib/cassandra/data/esmond/rate_aggregations/snapshots/esmond_snapshot
* /var/lib/cassandra/data/esmond/raw_data/snapshots/esmond_snapshot
* /var/lib/cassandra/data/esmond/stat_aggregations/snapshots/esmond_snapshot

Note that the directories above contain hard links to the original files, so they should not take a large amount of space on the existing disk. This also means you cannot delete the original files until these are removed.


Moving Snapshots to a Remote Server
###################################
You may optionally want to move your back-ups to a remote server. The steps to do so are as follows:

#. Create a tarball of the snapshot files::

    tar -czf esmond-snapshot-base_rates.tgz /var/lib/cassandra/data/esmond/base_rates/snapshots/esmond_snapshot
    tar -czf esmond-snapshot-rate_aggregations.tgz /var/lib/cassandra/data/esmond/rate_aggregations/snapshots/esmond_snapshot
    tar -czf esmond-snapshot-raw_data.tgz /var/lib/cassandra/data/esmond/raw_data/snapshots/esmond_snapshot
    tar -czf esmond-snapshot-stat_aggregations.tgz /var/lib/cassandra/data/esmond/stat_aggregations/snapshots/esmond_snapshot
#. Remotely copy the files to the new server using a tool such as scp::
    
    scp esmond-snapshot-*.tgz user@newhost:

Restoring Snapshots
###################
You may restore you files, either on a new or existing host, with the following steps:

#. Shutdown cassandra::

    service cassandra stop
#. Clear the commit logs::

    rm -f /var/lib/cassandra/commitlog/*.log
#. Delete all the the old data files::

    rm -f  /var/lib/cassandra/data/esmond/base_rates/*.db
    rm -f  /var/lib/cassandra/data/esmond/rate_aggregations/*.db
    rm -f  /var/lib/cassandra/data/esmond/raw_data/*.db
    rm -f  /var/lib/cassandra/data/esmond/stat_aggregations/*.db
#. Copy the contents of the snapshot into the data directories (*NOTE: The location of the snapshot may vary if it was migrated from another host or a label other than esmond_snapshot was used*)::
    
    cp /var/lib/cassandra/data/esmond/base_rates/snapshots/esmond_snapshot/* /var/lib/cassandra/data/esmond/base_rates/
    cp /var/lib/cassandra/data/esmond/rate_aggregations/snapshots/esmond_snapshot/* /var/lib/cassandra/data/esmond/rate_aggregations/
    cp /var/lib/cassandra/data/esmond/raw_data/snapshots/esmond_snapshot/* /var/lib/cassandra/data/esmond/raw_data/
    cp /var/lib/cassandra/data/esmond/stat_aggregations/snapshots/esmond_snapshot/* /var/lib/cassandra/data/esmond/stat_aggregations/
#. Start cassandra::

    service cassandra start

#. Run a repair::

    nodetool repair

Clearing snapshots
##################
You may want to clear a snapshot because it's too old to be useful, you'd like to delete data to which it is linked or you mistakenly created a snapshot testing the commands in the previous section. Rather than removing all the files by hand you can use a nodetool command to do so. Below is an example of how to remove the snapshot labelled esmond_snapshot in the esmond keyspace::
    
    nodetool clearsnapshot -t esmond_snapshot -- esmond 

If you want to clear all snapshots in the esmond keyspace run::

    nodetool clearsnapshot -- esmond 

.. _multi_ma_backups-snapshots-postgresql:

PostgreSQL Snapshots with `pg_dump` and `pg_restore`
----------------------------------------------------

Creating the Snapshot
##################### 
You may create a snapshot of your database with the following command:

  *CentOS/RedHat:*::

    pg_dump -F t -f esmond.tar -U esmond 

  *Debian/Ubuntu:*::

    sudo -u postgres pg_dump -F t -f esmond.tar esmond

This will create a tarball file in the current directory named esmond.tar. Note that this is a new file and though compressed, will consume additional disk space.

.. note:: If you are prompted for a password, see the *sql_db_password* property in */etc/esmond/esmond.conf*


Moving the Snapshot to a Remote Server
######################################

Moving the snapshot to a different server is as simple using your favorite remote copy tool to move the tarball to another server. For example, using *scp*::
    
    scp esmond.tar user@remote-host:


Restoring the Snapshot
######################

You may restore the snapshot with the following command:

  *CentOS/RedHat:*::

    pg_restore -c -U esmond -d esmond esmond.tar 

  *Debian/Ubuntu:*::

    sudo -u postgres pg_restore -c -d esmond esmond.tar

.. note:: If you are prompted for a password, see the *sql_db_password* property in */etc/esmond/esmond.conf*

This will delete any existing data and replace it with the backup. See the pg_restore documentation for more details.



Migrating Data
==============

All hardware is eventually retired and when this happens you may want to move your data to a new server. This section covers how to migrate both the Cassandra and PostgreSQL data.  

Migrating Cassandra Data
------------------------

.. note:: If migrating to a server with a different architecture or operating system it is recommended you instead follow the steps in :ref:`multi_ma_backups-snapshots-cassandra` for creating, migrating and restoring snapshots.

By default, packaged installs of cassandra keep all data in */var/lib/cassandra*. If you are migrating to a server running a similar operating system and architecture as the old system, a valid option may be simply stopping your cassandra server and copying the directory to the new host. For example::

    service cassandra stop
    scp -r /var/lib/cassandra user@newhost:cassandra
    
You can then restore the data as follows::

    service cassandra stop
    rm -rf /var/lib/cassandra/*
    mv cassandra/* /var/lib/cassandra/
    chown -R cassandra:cassandra /var/lib/cassandra/*
    service cassandra start

.. note:: If you are running on a cluster you may also need to run *nodetool repair*



Migrating PostgreSQL Data
-------------------------

.. note:: If migrating to a server with a different architecture or operating system it is recommended you instead follow the steps in :ref:`multi_ma_backups-snapshots-postgresql` for creating, migrating and restoring data.

By default, packaged installs of PostgreSQL keep all data in */var/lib/pgsql*. If you are migrating to a server running a similar operating system and architecture as the old system, a valid option may be simply stopping your PostgreSQL server and copying the directory to the new host. For example:
    
  *CentOS/RedHat:*::

    service pgsql stop
    scp -r /var/lib/pgsql user@newhost:pgsql

  *Debian/Ubuntu:*::

    service postgresql stop
    scp -r /var/lib/postgresql user@newhost:pgsql

You can then restore the data as follows:
    
  *CentOS/RedHat:*::

    service pgsql stop
    rm -rf /var/lib/pgsql/*
    mv pgsql/* /var/lib/pgsql/
    chown -R postgres:postgres /var/lib/pgsql/*
    service pgsql start

  *Debian/Ubuntu:*::

    service postgresql stop
    rm -rf /var/lib/postgresql/*
    mv pgsql/* /var/lib/postgresql/
    chown -R postgres:postgres /var/lib/postgresql/*
    service postgresql start

.. _multi_ma_backups-delete:

Deleting Old Data
=================

You may want to remove old data over time to conserve disk space or to clear out measurements you no longer want displayed. Currently perfSONAR comes with a script named `clean_esmond_db.sh` that uses esmond's tool named `ps_remove_data.py` capable of deleting data based on age in both in Cassandra and PostgreSQL. This section details usage of that script.

Using `clean_esmond_db.sh`
--------------------------
`clean_esmond_db.sh` sets the environment and then invokes `ps_remove_data.py` with optional parameters that uses a configuration file defining a data retention policy and then removes data in Cassandra and PostgreSQL based on that policy. The script is installed by default with esmond, used to run as a cron job, and can be found at:

* /usr/lib/prefsonar/scripts/clean_esmond_db.sh

`ps_remove_data.py` itself is located in */usr/lib/esmond/util/*. This script accepts the following arguments:

* **-c <conf-file>**: Optional parameter to set the location of the config file. Defaults to `/usr/lib/esmond/util/ps_remove_data.conf`. `clean_esmond_db.sh` sets this path to `/etc/perfsonar/toolkit/clean_esmond_db.conf` that contains the default retention policy after installing esmond. If you need to use another path modify it in `clean_esmond_db.sh`.
* **-s DATESTRING**: Date string with time in past to start looking for expired data. Default is current time. e.g. "2017-01-01 00:00:00"
* **-t SECONDS**: Number of seconds of data to query at a time. Querying the full range causes timeouts. Default is 86400 (1 day).
* **-m NUMBER**: Number of queries that don't return data before giving up on looking for more. If -t is 1 day and this value is 50, that means it will need to say 50 days without data before determining there is nothing left to delete. Default is 50.

The configuration file is in JSON format and defines data retention policies for your data. It allows you to match on three values: 

* **event_type** - The type of data for which this policy applies. A valid list can be found in the esmond :ref:`API documentation <psclient-rest-eventtypes>`. You may also pass ``*`` to match any value.
* **summary_type** - The type of summary to which this policy applies. Valid values are *base* for unsummarized data and any value from the list found in `this discussion <psclient-rest-basevsumm>`. You may also pass ``*`` to match any value.
* **summary_window** - An integer indicating the summary window to match (in seconds). A value of 0 means unsummarized (a.k.a base) data. You may also pass ``*`` to match any value. 

.. note:: If you are curious about the summary types and summary windows being used, look for pscheduler archiver reference.

In addition to the matching fields you must also set the following:

* **expire** - The value (in days) after which point the data should be deleted. A value of "never" means to always keep data. A value of "0" means to delete all matching data  immediately.

The script will choose the policy with the most specific match using a preference
order of event_type, summary_type and then summary_window. For example, assume a piece of data matches two policies defined as follows:

#. One where it matches the *event_type* but both the other filters are set to ``*``
#. Another where the event_type is ``*`` but it matches both *summary_type* and *summary_window*, 

In this example it will choose the first policy where it matches the specific (i.e. not ``*``) event type based on the preference order of the fields.  

A full example of a configuration file can be found below::

    {
    "policies": [

    {
    "event_type":      "*",
    "summary_type":    "*",
    "summary_window":  "*",
    "expire":          "365"
    },

    {
    "event_type":      "*",
    "summary_type":    "*",
    "summary_window":  "86400",
    "expire":          "1825"
    },

    {
    "event_type":      "histogram-owdelay",
    "summary_type":    "*",
    "summary_window":  "0",
    "expire":          "180"
    },

    {
    "event_type":      "histogram-rtt",
    "summary_type":    "*",
    "summary_window":  "0",
    "expire":          "180"
    },

    {
    "event_type":      "histogram-ttl",
    "summary_type":    "*",
    "summary_window":  "0",
    "expire":          "180"
    },

    {
    "event_type":      "packet-loss-rate",
    "summary_type":    "*",
    "summary_window":  "0",
    "expire":          "180"
    },

    {
    "event_type":      "packet-count-sent",
    "summary_type":    "*",
    "summary_window":  "0",
    "expire":          "180"
    },

    {
    "event_type":      "packet-count-lost",
    "summary_type":    "*",
    "summary_window":  "0",
    "expire":          "180"
    },

    {
    "event_type":      "packet-duplicates",
    "summary_type":    "*",
    "summary_window":  "0",
    "expire":          "180"
    },

    {
    "event_type":      "packet-reorders",
    "summary_type":    "*",
    "summary_window":  "0",
    "expire":          "180"
    },

    {
    "event_type":      "time-error-estimates",
    "summary_type":    "*",
    "summary_window":  "0",
    "expire":          "180"
    }

    ]
    }

.. seealso:: The example above can be found in `/usr/lib/esmond/util/ps_remove_data.conf` of the system where esmond is installed

The example contains several policies. The order of the policies is NOT significant. The first policy is a catch-all that removes anything older than 365 days if it does not match any other policies. This policy has a ``*`` for every value and is the least specific of a match possible. That means if any part of the other policies match, they will override the expiration of this policy. The second policy, matches all 24 hour (86400 seconds) summaries and keeps them for 5 years. Notice that it extends the life of these types of data from the default policy. The remaining policies match a specific event type and a summary window of 0 (which means unsummarized data) and expires it after 180 days (roughly 6 months). The event types all match that registered by the OWAMP tool, which writes new data every minute. Given the amount of data, this policy deletes it sooner that it would other (presumably less frequently written) data. 

  *CentOS/RedHat:*:
  
  It's best to run `clean_esmond_db.sh` with it's default settings::
  
    /usr/lib/prefsonar/scripts/clean_esmond_db.sh

  If you want to run the removal script with another policy file then enter the following commands (-c points to your specific policy file)::

    cd /usr/lib/esmond
    . bin/activate
    python ./util/ps_remove_data.py -c /usr/lib/esmond/util/ps_remove_data.conf

  *Debian/Ubuntu:*::

    . /etc/default/esmond
    export ESMOND_ROOT ESMOND_CONF
    export DJANGO_SETTINGS_MODULE=esmond.settings
    python /usr/share/esmond/util/ps_remove_data.py -c /usr/share/esmond/util/ps_remove_data.conf

.. note:: If running your measurement archive on a perfSONAR Toolkit or *core* or *centralmanagement* bundles then a cronjob under */etc/cron.d/* with a default policy will be setup and run nightly automatically.

Finally, though this tool can be useful it has several limitations that are important to be aware of:

* You can only delete data based on it's age, NOT other parameters like source or destination
* This tool may perform slowly for large deployments with lots of data and/or clustered databases. 

These limitations will be addressed in future versions of the software.