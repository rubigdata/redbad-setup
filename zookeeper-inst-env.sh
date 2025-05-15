#!/bin/sh
: ${1?"Usage: $0 zookeeper-myid"}
#
source versions.rc
#
# Software distribution
sudo tar -xf /home/core/dist/apache-zookeeper-${ZK_VER}-bin.tar.gz -C /opt/
sudo mv /opt/apache-zookeeper-${ZK_VER}-bin /opt/zookeeper
sudo chown -R zookeeper:hadoop /opt/zookeeper
#
# Zookeeper data directory and symlink
[ -d /var/storage/data8 ] && ZKDATA=/var/storage/data8/zookeeper \
                          || ZKDATA=/var/storage/data2/zookeeper
sudo mkdir -p $ZKDATA
sudo chown -R zookeeper:hadoop $ZKDATA
sudo ln -sf $ZKDATA /var/data/zookeeper
sudo chown -R zookeeper:hadoop /var/data/zookeeper
#
# Other Zookeeper directories
for d in /var/log/zookeeper /var/run/zookeeper /etc/zookeeper /etc/zookeeper/conf
do
  sudo mkdir -p $d
  sudo chown -R zookeeper:hadoop $d
  sudo chmod -R 755 $d
done
#
# Install Node identifier and config file
echo $1 | sudo -u zookeeper tee /var/data/zookeeper/myid
sudo -u zookeeper cp zoo.cfg /etc/zookeeper/conf/zoo.cfg
#
# Systemd setup
# Note: chcon may not be final, but FCOS does not work well with semanage
#       see also https://github.com/coreos/fedora-coreos-tracker/issues/701
sudo loginctl enable-linger core
sudo cp zookeeper.service /etc/systemd/system
sudo chcon -t bin_t /opt/zookeeper/bin/zkServer.sh
sudo systemctl enable zookeeper
sudo systemctl start zookeeper
