#!/bin/sh
#
# Directories to be created on datanodes
# Table 4.4 from Eric Sammer's Hadoop Operations (2012).
# Updates: hadoop-project-dist/hadoop-common/DeprecatedProperties.html
#
# dfs.datanode.data.dir
for n in 1 2 3 4 5 6
do
    d="/var/storage/data${n}/dfs/dn"
    mkdir -p $d
    chown hdfs:hadoop $d
    chmod 0700 $d
done
#
# mapreduce.job.local.dir
for n in 1 2 3 4 5 6
do
    d="/var/storage/data${n}/mapred/local"
    mkdir -p $d
    chown mapred:hadoop $d
    chmod 0770 $d    
done
#
# mapreduce.jobtracker.system.dir (1/fed)
for n in 1 4
do
    d="/var/storage/data${n}/mapred/system"
    mkdir -p $d
    chown mapred:hadoop $d
    chmod 0770 $d    
done
#
# Temp & log directories
for c in gelre frisia
do
    #
    # $HADOOP_LOG_DIR
    d=/var/log/hadoop	
    mkdir -p $d
    chown root:hadoop $d
    chmod 0775 $d
    #
    # mapreduce.cluster.temp.dir
    d=/var/data1/tmp/hadoop-${c}-hdfs
    mkdir -p $d
    chown root:root $d
    chmod 1777 $d
done

# TODO: (?)
# mapreduce.cluster.local.dir 
# mapreduce.cluster.temp.dir
# mapreduce.task.tmp.dir
