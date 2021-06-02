#!/bin/bash
sudo -u hdfs cp /etc/skel/.bash* /opt/hadoop
sudo -u hdfs mkdir /opt/hadoop/.bashrc.d
sudo -u hdfs cp redbad-setup/hadoop.rc /opt/hadoop/.bashrc.d
