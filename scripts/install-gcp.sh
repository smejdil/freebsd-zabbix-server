#!/bin/sh

# ports
portsnap fetch && portsnap extract

# bash
pkg install -y bash bash-completion

# ansible
pkg install -y py39-ansible python38 py39-setuptools
ln -s /usr/local/bin/python3.9 /usr/bin/python

# git
pkg install -y git

# make
touch /etc/make.conf
echo "BATCH=yes" > /etc/make.conf

# get projekt
git clone https://github.com/smejdil/freebsd-zabbix-server/

# EOF