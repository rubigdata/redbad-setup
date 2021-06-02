#!/bin/sh
#
# Directories to be created on datanodes
# Table 4.4 from Eric Sammer's Hadoop Operations (2012).
# Updates: hadoop-project-dist/hadoop-common/DeprecatedProperties.html
#
for c in gelre frisia
do
    for n in 1 2 3 4 5 6
    do
        d=/var/storage/data${n}/dfs
        sudo mkdir -p $d
        sudo chown -R hdfs:hadoop $d
        #
        # dfs.datanode.data.dir
        d="/var/storage/data${n}/dfs/$c/dn"
        mkdir -p $d
        chown hdfs:hadoop $d
        chmod 0700 $d
        #
        # mapreduce.job.local.dir
        d="/var/storage/data${n}/mapred"
        sudo mkdir -p $d
        sudo chown mapred:hadoop $d
        sudo -u mapred chmod 0770 $d    
        d="/var/storage/data${n}/mapred/$c/local"
        sudo -u mapred mkdir -p $d
        sudo -u mapred chown mapred:hadoop $d
        sudo -u mapred chmod 0770 $d    
    done
done
#
# mapreduce.jobtracker.system.dir (1/fed)
for n in 1 4
do
    d="/var/storage/data${n}/mapred/system"
    sudo mkdir -p $d
    sudo chown mapred:hadoop $d
    sudo -u mapred chmod 0770 $d    
done
#
# Temp & log directories
for c in gelre frisia
do
    #
    # $HADOOP_LOG_DIR
    d=/var/log/hadoop/${c}	
    sudo mkdir -p $d
    sudo chown root:hadoop $d
    sudo chmod 0775 $d
    #
    # mapreduce.cluster.temp.dir
    d=/var/data1/tmp/hadoop-${c}-hdfs
    sudo mkdir -p $d
    sudo chown root:root $d
    sudo chmod 1777 $d
done
# TODO: (?)
# mapreduce.cluster.local.dir 
# mapreduce.cluster.temp.dir
# mapreduce.task.tmp.dir
