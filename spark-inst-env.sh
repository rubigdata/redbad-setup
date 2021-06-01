#!/bin/sh
#
# Software distribution
sudo tar -xf /home/core/dist/spark-3.1.1-bin-without-hadoop.tgz -C /opt/
sudo mv /opt/spark-3.1.1-bin-without-hadoop /opt/spark
sudo chown -R spark:hadoop /opt/spark
#
cp spark.rc $HOME/.bashrc.d/spark.rc
#
# SSH
sudo -u spark mkdir -p /opt/spark/.ssh/authorized_keys.d
sudo -u spark chmod -R og-rwx /opt/spark/.ssh
sudo cp $HOME/.ssh/authorized_keys.d/id_rsa_redbad-nodes.pub /opt/spark/.ssh/authorized_keys.d
sudo chown spark:hadoop /opt/spark/.ssh/authorized_keys.d/id_rsa_redbad-nodes.pub