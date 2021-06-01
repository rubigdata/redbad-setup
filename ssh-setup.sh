#!/bin/sh
: ${2?"Usage: $0 user tool"}
u=$1
t=$2
#
# SSH
sudo -u $u mkdir -p /opt/$t/.ssh/authorized_keys.d
sudo -u $u chmod -R og-rwx /opt/$t/.ssh
sudo cp $HOME/.ssh/authorized_keys.d/id_rsa_redbad-nodes.pub /opt/$t/.ssh/authorized_keys.d
sudo chown $u:hadoop /opt/$t/.ssh/authorized_keys.d/id_rsa_redbad-nodes.pub
sudo cp $HOME/.ssh/id_rsa_redbad-nodes /opt/$t/.ssh
sudo chown $u:hadoop /opt/$t/.ssh/id_rsa_redbad-nodes
echo IdentityFile /opt/$t/.ssh/id_rsa_redbad-nodes | sudo -u $u tee /opt/$t/.ssh/config
sudo chcon -R unconfined_u:object_r:usr_t:s0 /opt/$t/.ssh
