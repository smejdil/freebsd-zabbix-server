#!/bin/sh

# ports
portsnap fetch && portsnap extract

# ansible
pkg install -y py38-ansible python38 py38-setuptools
ln -s /usr/local/bin/python3.8 /usr/bin/python

# make
touch /etc/make.conf
echo "BATCH=yes" > /etc/make.conf

# EOF