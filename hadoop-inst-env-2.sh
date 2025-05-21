#!/bin/bash
#
# NB: this is now integrated in hadoop-inst-env.sh, you probably do not need it
#
[ ! -f /opt/hadoop/.bashrc ] && sudo -u hdfs cp /etc/skel/.bash* /opt/hadoop
sudo -u hdfs mkdir -p /opt/hadoop/.bashrc.d
sudo -u hdfs cp hadoop.rc /opt/hadoop/.bashrc.d
