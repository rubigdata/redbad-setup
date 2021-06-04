#!/bin/sh
#
# Software distribution
sudo tar -xf /home/core/dist/hadoop-3.2.2.tar.gz -C /opt/
sudo mv /opt/hadoop-3.2.2 /opt/hadoop
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
