# VPS initializer
*Designed for Ubuntu 14/16 server.*

This simple bash script which initialize VPS server with custom sudo user, 
ssh connection and docker.

Log on your VPS as root and install Git first with: 
```bash
(optional) $ apt-get update
$ apt-get install git -y
```
Clone this repo with bash script and enter to it.
```bash
$ git clone https://github.com/methlock/vps-initializer
$ cd vps-initializer
```
Run script with desired arguments.
```bash
$ bash vps_init.sh <new user> <its password> <new ssh port>
```
You will be prompted for ssh key at some point. You should have this key at
your disposal. 

**This script will block password authentication. So if you enter
ssh key somehow wrong, you must reinitialize your VPS:).**
