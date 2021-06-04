#!/bin/sh
: ${1?"Usage: sudo $0 password-prefix"}
PASS=$1
HADOOP_GID=321
YARN_GID=$((HADOOP_GID+4))
HADOOP_UID=321
MAPRED_UID=$((HADOOP_UID+1))
SPARK_UID=$((HADOOP_UID+2))
ZK_UID=$((HADOOP_UID+3))
YARN_UID=$((HADOOP_UID+4))
groupadd -r -g ${HADOOP_GID} hadoop
useradd -r -m -u ${HADOOP_UID} -g ${HADOOP_GID} -d /opt/hadoop hdfs
useradd -r -m -u ${MAPRED_UID} -g ${HADOOP_GID} -d /opt/mapred mapred
useradd -r -m -u ${SPARK_UID} -g ${HADOOP_GID} -d /opt/spark spark
useradd -r -m -u ${ZK_UID} -g ${HADOOP_GID} -d /opt/zookeeper zookeeper
useradd -r -m -u ${YARN_UID} -g ${HADOOP_GID} -d /opt/yarn yarn
echo ${PASS}-h@d00p | passwd --stdin hdfs
echo ${PASS}-m@pr3d | passwd --stdin mapred
echo ${PASS}-sp@rk | passwd --stdin spark
echo ${PASS}-z00k33p3r | passwd --stdin zookeeper
echo ${PASS}-y@rn | passwd --stdin yarn
usermod -aG wheel,sudo hdfs
usermod -aG wheel,sudo mapred
usermod -aG wheel,sudo spark
usermod -aG wheel,sudo zookeeper
usermod -aG wheel,sudo yarn
mkdir -p /var/data
