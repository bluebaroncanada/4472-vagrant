# 4472-vagrant

## Optional
Before you begin you should get a private and public key.  I can't stress to you how much easier your life will be.

- Windows: https://github.com/bluebaroncanada/4472-vagrant/blob/master/windows-ssh.md
- Mac/Linux: I'll post explicit instructions for Linux if there's a need, but if you just look up how to generate an ssh key and create an ssh config file, you'll be fine.

## Installation
- Download vagrant from https://www.vagrantup.com/downloads.html
I think it comes with virtualbox, but if it doesn't https://www.virtualbox.org/wiki/Downloads

Clone this project.  If you're running Windows, I recommend downloading https://git-scm.com/download/win if you don't already have it.

```
git clone https://github.com/bluebaroncanada/4472-vagrant.git
```

If you took my advice in the Optional section, open up Vagrantfile and put your PUBLIC ssh key in the file.  It should look like:
```
ssh_public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDZC0wINCffUgIYbD7RznR1dMV4bTbkzW5JWp7bsTNWZNTUGiXt9nKl7Q+fE8ChpnqsLfQg4NtzxkMxFEOZI3qa/6dLlqlIq5UwdB/lF0YO7FMgn5sfJs2+/pvs2Ytx6niH4coLB8NZW5SiV9MWj3ECOOVWTtVyrU37/ANzCr+i+tU8g7H2+DxADXUcYWxwbv2tL1TF89BEaRaVQlz1oJNi54i+E/aggyw65WfoVDWQEXWO+SjiTm9Ide1RxHE0pDUKLoxTvsUZpR2PWRq0LCrzljfzfYl3RloCIelwy+pFgO8KlDgPvgnJs8iP6wmsMw5RyF5y3fhYWdET/h377jl"
```

If you're using Jet Brains Ruby Mine, it supports Vagrant.  Copy `Vagrantfile` and `provisioning.sh` to your project directory and go to Tools/Vagrant/Start.

Else, just cd to the project directory and type `vagrant up`.

The provisioning takes about 20-40 minutes depending on the speed of your connection and your CPU.

After you've finished, you'll be able to SSH in by setting the port to 2222 and the host to vagrant@localhost.  For example `ssh vagrant@localhost:2222` or in putty `vagrant@localhost` in the host, and `2222` in the port.

The default password is `vagrant`.

### Special note
A couple times while doing this installation the installation stalled at `Cloning Tracks ...`.  If that happens for more than 10 minutes, just `ctrl+c` to break out, ssh in, and run `/home/vagrant/4472-vagrant/scripts/reinstall-tracks.bash`

## Starting the server

To start the Tracks server, once sshed in, `/home/vagrant/4472-vagrant/scripts/start-tracks.bash`

The server will start on port `3000`.  To access the server, simply open a browser on your host (local machine) and browse to `http://192.168.34.10:3000`.

## Important note
Vagrant is designed to be disposable.  If you screw something up and your sever no longer works, `vagrant destroy; vagrant up` and you have a brand new server.  For this reason it's important that you don't do any work on your vagrant server.  It will be lost.  You use an IDE to create all your files and then deploy them to the server.
