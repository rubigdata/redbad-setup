#!/bin/sh
#
# Directories to be created on namenodes
# Table 4.4 from Eric Sammer's Hadoop Operations (2012).
#
# dfs.namenode.name.dir
for c in gelre frisia
do
    for n in 1 2
    do
	d="/var/storage/data${n}/dfs-${c}/nn"
	mkdir -p $d
	chown hdfs:hadoop $d
	chmod 0700 $d
    done
done
#
# dfs.namenode.checkpoint.dir
# /data1/dfs/snn
# TODO QJM directories?

