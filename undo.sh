#!/bin/sh
#
# Remove directories
[ -d /var/storage/data8 ] && ZKDATA=/var/storage/data8/zookeeper \
                          || ZKDATA=/var/storage/data2/zookeeper
sudo rm -rf $ZKDATA
sudo rm /var/data/zookeeper
for d in /var/log/zookeeper /var/run/zookeeper /etc/zookeeper /etc/zookeeper/conf
do
  sudo rm -rf $d
done
#
# Remove users
for u in zookeeper spark mapred hdfs
do
  sudo userdel $u
done
sudo groupdel hadoop
