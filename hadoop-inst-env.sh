#!/bin/sh
#
# Software distribution
. ./versions.rc
#
sudo tar -xf /home/core/dist/hadoop-${HADOOP_VER}.tar.gz -C /opt/
sudo mv /opt/hadoop-${HADOOP_VER} /opt/hadoop
sudo chown -R hdfs:hadoop /opt/hadoop
#
cp hadoop.rc $HOME/.bashrc.d/hadoop.rc
sudo -u hdfs mkdir -p /opt/hadoop/.bashrc.d
sudo -u hdfs cp hadoop.rc /opt/hadoop/.bashrc.d/hadoop.rc
sudo -u hdfs cp hadoop-conf/* /opt/hadoop/etc/hadoop/
#
sudo chown root:hadoop /opt/hadoop/bin/container-executor
sudo chmod 050 /opt/hadoop/bin/container-executor
sudo chmod u+s /opt/hadoop/bin/container-executor
sudo chmod g+s /opt/hadoop/bin/container-executor
