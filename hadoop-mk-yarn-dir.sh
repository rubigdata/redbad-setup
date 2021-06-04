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
		sudo chown -R root:yarn $d
    		#
    		# yarn.nodemanager.local-dirs
    		d=/var/storage/data${n}/yarn/$c/local
    		sudo mkdir -p $d
    		sudo chown root:yarn $d
    		sudo chmod 0700 $d
    		#
		# yarn.nodemanager.log-dirs
    		d=/var/storage/data${n}/yarn/$c/logs
    		sudo mkdir -p $d
    		sudo chown root:yarn $d
    		sudo chmod 0770 $d    
	fi
    done
done
