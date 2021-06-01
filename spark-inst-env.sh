#!/bin/sh
#
# Software distribution
sudo tar -xf /home/core/dist/spark-3.1.1-bin-without-hadoop.tgz -C /opt/
sudo mv /opt/spark-3.1.1-bin-without-hadoop /opt/spark
sudo chown -R spark:hadoop /opt/spark
#
cp spark.rc $HOME/.bashrc.d/spark.rc
sudo -u spark cp spark-conf/* /opt/spark/conf
