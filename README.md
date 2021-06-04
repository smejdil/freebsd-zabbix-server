## FreeBSD Zabbix Server

This small project is used for install zabbix[5|52|54]_agent, zabbix[5|52|54]_frontend and
zabbix[5|52|54]_server with mysql57-server on OS FreeBSD 13.

## Dependencies

- Package zabbix - zabbix[5|52|54]-server
- Packahe apache - apache24-2.4.46_2 - Version 2.4.x of Apache web server
- Package php - php74-7.4.19 - PHP Scripting Language
- Package mysql - mysql57-server-5.7.33 - Multithreaded SQL database (server)

## How it works

On Linux desktop run vagrant with VirtualBox. For test install and configure
zabbix_server and other component by ansible on FreeBSD 13

### Installation test evnviroment FreeBSD

Vagrant use Vagrantfile

```console
vagrant up
vagrant ssh
```
- Vagrant also configure network public_network, sshd - PermitRootLogin yes, set up root password and install ansible package

The Vagrantfile was initialized as follows.
```console
vagrant init freebsd/FreeBSD-13.0-RELEASE
```

### Installation Desktop

- install ssh public key to FreeBSD

```console
cd ~/.ssh && ssh-copy-id -i id_rsa.pub root@192.168.42.100
cd ${HOME}/work/freebsd-zabbix-server
```
- test Ansible communication
```console
ansible "*" -i "192.168.42.100," -u root -m ping
192.168.42.100 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/local/bin/python3.7"
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
freebsd ansible_ssh_host=192.168.42.100 ansible_ssh_user=root

ansible fbsd-zabbix-server -m ping
```
Use Ansible community collection zabbix, general and mysql. And pkgng, portinstall module, etc.

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
- 3.6.2021 - zabbix54 does not exist in the binary version
- ansible use module community.general.portinstall

```console
ansible-playbook zabbix5-server-mysql.yml
ansible-playbook zabbix52-server-mysql.yml
ansible-playbook zabbix54-server-mysql.yml

ansible-playbook zabbix54-server-postgresql.yml
```

```console
192.168.42.100/zabbix/
Admin/zabbix
```

- configure zabbix server by API

```console
ZABBIX_SERVER=http://192.168.5.200/zabbix/

ansible-playbook configure-zabbix.yml
```

### ToDo

- write zabbix-server-tsdb.yml
- solve problem with recompilation packages
