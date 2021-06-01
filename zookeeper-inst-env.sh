#!/bin/sh
: ${1?"Usage: $0 zookeeper-myid"}
#
# Software distribution
sudo tar -xf /home/core/dist/apache-zookeeper-3.7.0-bin.tar.gz -C /opt/
sudo mv /opt/apache-zookeeper-3.7.0-bin /opt/zookeeper
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
# Systemd user setup
mkdir -p $HOME/.config/systemd/user
cp zookeeper.service $HOME/.config/systemd/user
systemctl --user enable zookeeper
systemctl --user start zookeeper
sudo loginctl enable-linger core
