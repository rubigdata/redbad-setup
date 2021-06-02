#!/bin/bash
[ ! -f /opt/hadoop/.bashrc ] && sudo -u hdfs cp /etc/skel/.bash* /opt/hadoop
sudo -u hdfs mkdir -p /opt/hadoop/.bashrc.d
sudo -u hdfs cp hadoop.rc /opt/hadoop/.bashrc.d
