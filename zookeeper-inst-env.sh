#!/bin/sh
: ${1?"Usage: $0 zookeeper-myid"}
#
# Software distribution
sudo tar -xf /home/core/dist/apache-zookeeper-3.7.0-bin.tar.gz -C /opt/
sudo mv /opt/apache-zookeeper-3.7.0-bin /opt/zookeeper
sudo chown -R zookeeper:hadoop /opt/zookeeper
#
# Zookeeper data directory and symlink
[ -d /var/storage/data8 ] && ZKDATA=/var/storage/data8/zookeeper \
                          || ZKDATA=/var/storage/data2/zookeeper
sudo mkdir -p $ZKDATA
sudo chown -R zookeeper:hadoop $ZKDATA
sudo ln -sf $ZKDATA /var/data/zookeeper
sudo chown -R zookeeper:hadoop /var/data/zookeeper
#
# Other Zookeeper directories
for d in /var/log/zookeeper /var/run/zookeeper /etc/zookeeper /etc/zookeeper/conf
do
  sudo mkdir -p $d
  sudo chown -R zookeeper:hadoop $d
  sudo chmod -R 755 $d
done
#
# Node Identifier
sudo su zookeeper -c "echo $1 > /var/data/zookeeper/myid"
