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
# QJM data storage
# dfs.journalnode.edits.dir
# Q: postfix gelre/frisia?
d="/var/storage/data2/qjm-journal-edits"
mkdir -p $d
chown hdfs:hadoop $d
chmod 0700 $d

