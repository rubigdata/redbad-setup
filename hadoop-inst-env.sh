#!/bin/sh
: ${1?"Usage: $0 password-prefix"}
PASS=$1
HADOOP_GID=2021
HADOOP_UID=2021
MAPRED_UID=$((HADOOP_UID+1))
SPARK_UID=$((HADOOP_UID+2))
ZK_UID=$((HADOOP_UID+3))
groupadd -r -g ${HADOOP_GID} hadoop
useradd -r -m -u ${HADOOP_UID} -g ${HADOOP_GID} -d /opt/hadoop hdfs
useradd -r -m -u ${MAPRED_UID} -g ${HADOOP_GID} -d /opt/mapred mapred
useradd -r -m -u ${SPARK_UID} -g ${HADOOP_GID} -d /opt/spark spark
useradd -r -m -u ${ZK_UID} -g ${HADOOP_GID} -d /opt/zookeeper zookeeper
echo ${PASS}-h@d00p | passwd --stdin hdfs
echo ${PASS}-m@pr3d | passwd --stdin mapred
echo ${PASS}-sp@rk | passwd --stdin spark
echo ${PASS}-z00k33p3r | passwd --stdin zookeeper
usermod -aG wheel,sudo hdfs
usermod -aG wheel,sudo mapred
usermod -aG wheel,sudo spark
usermod -aG wheel,sudo zookeeper
# Data directory
sudo mkdir -p /var/data
# Zookeeper data directory and symlink
[ -d /var/storage/data8 ] && ZKDATA=/var/storage/data8/zookeeper \
                          || ZKDATA=/var/storage/data2/zookeeper
sudo mkdir -p $ZKDATA
sudo chown -R zookeeper:hadoop $ZKDATA
sudo ln -s $ZKDATA /var/data/zookeeper
sudo chown -R zookeeper:hadoop /var/data/zookeeper
