## FreeBSD Zabbix Server

This small project is used for install zabbix[5|6]_agent, zabbix[5|6]_frontend and
zabbix[5|6]_server with mysql57-server or postgresql13-server with
timescaledb-2.5.2 on OS FreeBSD 13.0-RELEASE-p7.

## Dependencies

- Package zabbix - zabbix[5|6]-server
- Packahe apache - apache24-2.4.52 - Version 2.4.x of Apache web server
- Package php - php74-7.4.27 - PHP Scripting Language
- Package mysql - mysql57-server-5.7.36 - Multithreaded SQL database (server)
- Package postgresql - postgresql13-server-13.5 - PostgreSQL is the most advanced open-source database available anywhere
- Package timescaledb - timescaledb-2.5.2 - Time-series database built on PostgreSQL

## How it works

On Linux desktop run vagrant with vagrant-libvirt and vagrant-disksize. For test install and configure
zabbix_server and other component by ansible on FreeBSD 13. Or use GCP.

### Installation Vagrant test evnviroment FreeBSD

For ready function Vagrantfile is need use plugin vagrant-disksize

```console
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
vagrant init freebsd/FreeBSD-13.0-RELEASE
```

### Installation GCP test evnviroment FreeBSD

```console
gcloud config set project zabbix-test
gcloud compute instances create zabbix-server --image freebsd-13-0-release-amd64 --image-project=freebsd-org-cloud-dev --zone=europe-central2-a --metadata-from-file startup-script=./scripts/install-gcp.sh
gcloud compute instances add-tags zabbix-server --tags=http-server --zone=europe-central2-a
gcloud compute ssh zabbix-server --zone=europe-central2-a
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
freebsd ansible_ssh_host=192.168.42.100 ansible_ssh_user=root ansible_python_interpreter=/usr/local/bin/python3.8

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
ansible-galaxy collection install -r requirements.yml
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
- apache24 - apache24-2.4.52 
- php - php74-7.4.27
- postgresql - postgresql14-server-13.5
- ansible - py38-ansible-4.7.0

```console
portsnap fetch && portsnap update && pkg version -v | grep upd
portupgrade -a
```

### ToDo

- Fix problem with import data.sql and timescaledb.sql (py38-psycopg2) largre SQL
