# VPS initializer
*Designed for Ubuntu 14 server.*

This is simple bash script which initialize VPS server with custom sudo user and docker.

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
And finally, run script with arguments.
```bash
$ bash vps_init.sh <new user> <its password> <new ssh port>
```

