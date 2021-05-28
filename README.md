## FreeBSD Zabbix Server

This small project is used for install zabbix5_agent, zabbix5_frontend and
zabbix5_server with mysql80-server on OS FreeBSD 13.

## Dependencies

- Package zabbix
- Packahe apache

## How it works

On Linux desktop run vagrant with VirtualBox. For test install and configure zabbix_agent by ansible on FreeBSD 13

### Installation test evnviroment FreeBSD

```console
vagrant up
vagrant ssh
```
- Vagrant also configure sshd - PermitRootLogin yes and set up root password and install ansible package

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

```console
sudo vim /etc/ansible/hosts

[fbsd-zabbix-server]
freebsd ansible_ssh_host=192.168.42.100 ansible_ssh_user=root

ansible fbsd-zabbix-server -m ping
```
Use Ansible community collection zabbix, general and pkgng module, etc.

- https://galaxy.ansible.com/community/zabbix
- https://galaxy.ansible.com/community/general

- https://docs.ansible.com/ansible/latest/collections/community/general/index.html#plugins-in-community-general
- https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html

## Install Ansible module

```console
ansible-galaxy collection install -r requirements.yml
```

## Run Ansible playbook with enviroment

```console
ansible-playbook zabbix-server.yml
```

### ToDo

- write zabbix-server-tsdb.yml
