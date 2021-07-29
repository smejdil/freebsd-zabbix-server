## Vagrant od Ubuntu

Description of install Vagrant enviroment on Ubuntu Desktop

## Dependeces

- Package virtualbox - 6.1.16-dfsg-6~ubuntu1.20.04.2 - x86 virtualization solution - base binaries
- Package vagrant - 2.2.6+dfsg-2ubuntu3 - ool for building and distributing virtualized

## Installation

### Install VirtualBox

```console
apt install virtualbox
```

### Install Vagrant

```console
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && sudo apt-get install vagrant
```

### Configure Vagrant

```console
vagrant plugin install vagrant-disksize
vagrant init freebsd/FreeBSD-13.0-RELEASE
vagrant up
```

## ToDo

- ?