#!/bin/sh
sudo tee -a /etc/zincati/config.d/90-disable-auto-updates.toml > /dev/null <<__EOF__
[updates]
enabled = false
__EOF__
