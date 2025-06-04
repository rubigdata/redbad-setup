#!/bin/sh
#
# Directories to be created on nodes
# Table 4.4 from Eric Sammer's Hadoop Operations (2012).
# Updates: hadoop-project-dist/hadoop-common/DeprecatedProperties.html
#
for c in gelre frisia
do
    for n in 1 2 3 4 5 6
    do
        if [ -d /var/storage/data${n} ] 
        then
    	    	d=/var/storage/data${n}/yarn
    		sudo mkdir -p $d
		sudo chown -R yarn:hadoop $d
    		#
    		# yarn.nodemanager.local-dirs
    		d=/var/storage/data${n}/yarn/$c/local
    		sudo mkdir -p $d
    		sudo chown yarn:hadoop $d
    		sudo chmod 0700 $d
    		#
		# yarn.nodemanager.log-dirs
    		d=/var/storage/data${n}/yarn/$c/log
    		sudo mkdir -p $d
    		sudo chown yarn:hadoop $d
    		sudo chmod 0770 $d    
	fi
    done
done
#
# Node labels setup
# https://hadoop.apache.org/docs/current3/hadoop-yarn/hadoop-yarn-site/NodeLabel.html
#
hdfs dfs -mkdir hdfs://gelre/etc
hdfs dfs -chown hdfs:hadoop hdfs://gelre/etc
hdfs dfs -mkdir hdfs://gelre/etc/node-labels
hdfs dfs -chown yarn:hadoop hdfs://gelre/etc/node-labels
