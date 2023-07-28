## FreeBSD Zabbix Server

This small project is used for install zabbix6_agent, zabbix6_frontend and
zabbix6_server with mysql82-server or postgresql15-server with
timescaledb-2.11.1 on OS FreeBSD 13.2-RELEASE.

## Dependencies

- Package zabbix - zabbix6-server
- Packahe apache - apache24-2.4.57_1 - Version 2.4.x of Apache web server
- Package php - mod_php82-8.2.8 - PHP Scripting Language
- Package mysql - mysql80-server-8.0.33 - Multithreaded SQL database (server)
- Package postgresql - postgresql15-server-15.3 - PostgreSQL is the most advanced open-source database available anywhere
- Package timescaledb - timescaledb-2.11.1 - Time-series database built on PostgreSQL

## How it works

On Linux desktop run vagrant with vagrant-libvirt and vagrant-disksize. For test install and configure
zabbix_server and other component by ansible on FreeBSD 13.2 Or use GCP or BHyVe.

### Installation Vagrant test evnviroment FreeBSD

For ready function Vagrantfile is need use plugin vagrant-disksize

```console
vagrant plugin install virtualbox
vagrant plugin install vagrant-disksize
```
Vagrant use Vagrantfile
```console
vagrant up
vagrant ssh
sudo su -
portsnap fetch && portsnap extract
```
- Vagrant also configure network public_network, sshd - PermitRootLogin yes, set up root password and install ansible package

The Vagrantfile was initialized as follows.
```console
vagrant init freebsd/FreeBSD-13.2-RELEASE
```

### Installation GCP test evnviroment FreeBSD

```console
gcloud config set project zabbix-test
gcloud compute instances create zabbix-server --image freebsd-13-2-release-amd64 --image-project=freebsd-org-cloud-dev --zone=europe-central2-a --metadata-from-file startup-script=./scripts/install-gcp.sh
gcloud compute instances add-tags zabbix-server --tags=http-server --zone=europe-central2-a
gcloud compute ssh zabbix-server --zone=europe-central2-a
```

### Installation BHyVe test evnviroment FreeBSD

```console
vm image list -l | grep fbsd13
78d9a3e4-2c58-11ee-9c8a-a08cfdf259ea  fbsd13      Thu Jul 27 10:34:59 CEST 2023  FreeBSD13-base-install

vm image provision 78d9a3e4-2c58-11ee-9c8a-a08cfdf259ea freebsd
Unpacking guest image, this may take some time...

vm snapshot freebsd@2023072801

vm start freebsd
Starting freebsd
  * found guest in /vms/freebsd
  * booting...

vm list | grep freebsd
freebsd      default    bhyveload  2    2048M   -    No    Running (91460)

vm console freebsd

vm snapshot freebsd@2023072802

zfs list -t snapshot
NAME                                 USED  AVAIL     REFER  MOUNTPOINT
zroot/vms/freebsd@2023072801          76K      -      124K  -
zroot/vms/freebsd@2023072802          76K      -      124K  -
zroot/vms/freebsd/disk0@2023072801  4.26M      -     6.54G  -
zroot/vms/freebsd/disk0@2023072802  2.75M      -     6.54G  -
```

### Installation Desktop evnviroment

- install ssh public key to FreeBSD for Vagrant

```console
VAGRANT_IP=192.168.42.100
ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "${VAGRANT_IP}"
cd ~/.ssh && ssh-copy-id -i id_rsa.pub root@${VAGRANT_IP}
cd ${HOME}/work/freebsd-zabbix-server
```
- test Ansible communication for Vagrant
```console
ansible "*" -i "${VAGRANT_IP}," -u root -m ping
192.168.42.100 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```
### Configure ansible on Desktop

- test Ansible communication

```console
sudo vim /etc/ansible/hosts

[fbsd-zabbix-server]
freebsd ansible_ssh_host=192.168.42.100 ansible_ssh_user=root ansible_python_interpreter=/usr/local/bin/python3.9

ansible fbsd-zabbix-server -m ping
```
Use Ansible community collection zabbix, general, mysql and postgresql. And pkgng, portinstall module, etc.

- https://galaxy.ansible.com/community/zabbix
- https://galaxy.ansible.com/community/general
- https://galaxy.ansible.com/community/mysql
- https://galaxy.ansible.com/community/postgresql

- https://docs.ansible.com/ansible/latest/collections/community/general/index.html#plugins-in-community-general
- https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html
- https://docs.ansible.com/ansible/latest/collections/community/general/portinstall_module.html

## Install Ansible module

```console
ansible-galaxy collection install community.zabbix
```

## Run Ansible playbook

- choise version of zabbix
- ansible use module community.general.portinstall

```console
ansible-playbook playbooks/zabbix5-server-mysql.yml
ansible-playbook playbooks/zabbix6-server-mysql.yml

ansible-playbook playbooks/zabbix6-server-postgresql.yml
```

```console
192.168.42.100/zabbix/
Admin/zabbix
```

- configure zabbix server by API

```console
ZABBIX_SERVER=http://192.168.5.200/zabbix/

ansible-playbook playbooks/configure-zabbix.yml
```

## Postinstall upgrade package

- Upgrade package from ports
- curl - curl-7.82.0
- apache24 - apache24-2.4.55 
- php - php81-8.1.13
- postgresql - postgresql14-server-15.1
- ansible - py39-ansible-5.5.0
- ansible-core - py39-ansible-core-2.12.4

```console
portsnap fetch && portsnap update && pkg version -v | grep upd
portupgrade -a
```

### ToDo

- Fix problem with import data.sql and timescaledb.sql (py39-psycopg2) largre SQL
