#!/bin/sh
: ${1?"Usage: $0 zookeeper-myid"}
# Data directory
sudo mkdir -p /var/data
# Zookeeper data directory and symlink
[ -d /var/storage/data8 ] && ZKDATA=/var/storage/data8/zookeeper \
                          || ZKDATA=/var/storage/data2/zookeeper
sudo mkdir -p $ZKDATA
sudo chown -R zookeeper:hadoop $ZKDATA
sudo ln -sf $ZKDATA /var/data/zookeeper
sudo chown -R zookeeper:hadoop /var/data/zookeeper
# Log and PID dir
sudo mkdir -p /var/log/zookeeper
sudo chown -R zookeeper:hadoop /var/log/zookeeper
sudo chmod -R 755 /var/log/zookeeper
sudo mkdir -p /var/run/zookeeper
sudo chown -R zookeeper:hadoop /var/run/zookeeper
sudo chmod -R 755 /var/run/zookeeper
sudo su zookeeper -c "echo $1 > /var/data/zookeeper/myid"
