#!/bin/sh
#
# Software distribution
sudo tar -xf /home/core/dist/hadoop-3.2.2.tar.gz -C /opt/
sudo mv /opt/hadoop-3.2.2 /opt/hadoop
sudo chown -R hdfs:hadoop /opt/hadoop
#
cp hadoop.rc $HOME/.bashrc.d/hadoop.rc

