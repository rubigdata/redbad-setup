#!/bin/sh
#
# Software distribution
. ./versions.rc
#
sudo tar -xf /home/core/dist/spark-${SPARK_VER}-bin-without-hadoop.tgz -C /opt/
sudo mv /opt/spark-${SPARK_VER}-bin-without-hadoop /opt/spark
sudo chown -R spark:hadoop /opt/spark
#
sudo -u spark mkdir -p /opt/spark/.bashrc.d
sudo -u spark cp spark.rc /opt/spark/.bashrc.d/spark.rc
sudo -u spark cp spark-conf/* /opt/spark/conf
