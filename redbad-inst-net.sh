#!/bin/sh
sudo sed -i -e 's/search science.ru.nl/search cs.ru.nl science.ru.nl/' /etc/resolv.conf
cat hosts | sudo tee -a /etc/hosts > /dev/null
