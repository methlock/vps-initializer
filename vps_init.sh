#!/usr/bin/env bash
# You must be in script folder to run it like this:
# $ bash vps_init.sh user password new_ssh_port

# checking if three arguments are passed in
if [[ $# -ne 3 ]]
  then
    echo "Bad number of arguments! Try: $ bash vps_init.sh 'new_user' 'password' 'new_ssh_port'"
fi

# constants
YL='\033[1;33m' # yellow
GR='\033[0;32m' # green
RE='\033[0;31m' # red
NC='\033[0m' # no color
echo -e "${RE}Running initial VPS setting${NC}"

# updates
echo -e "${YL}Updating${NC}"
sleep 3
apt-get update && apt-get upgrade -y
apt-get autoclean && apt-get autoremove

# user creation
echo -e "${YL}Creating $1 sudo user${NC}"
adduser --disabled-password --gecos "" $1
echo $1:$2 | chpasswd
adduser $1 sudo

# ssh config
echo -e "${YL}Inserting SSH key${NC}"
echo -e "${RE}Not implemented see code for web help.${NC}"
#https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-1604
#https://tutorials.ubuntu.com/tutorial/tutorial-ssh-keygen-on-windows#3

echo -e "${YL}Setting ssh config${NC}"
sed -i '/^PermitRootLogin/s/yes/no/' /etc/ssh/sshd_config
sed -i '/^Port/s/22/'$3'/' /etc/ssh/sshd_config
echo -e "${RE}SSH key not implemented, password authentication is still on.${NC}"
#sed -i '/^PasswordAuthentication/s/yes/no/' /etc/ssh/sshd_config
service ssh restart

# custom installs
echo -e "${YL}Installing htop${NC}"
apt-get install -y htop

echo -e "${YL}Installing Docker and setting symlink${NC}"
apt-get -y install docker.io && ln -sf /usr/bin/docker.io /usr/local/bin/docker

echo -e "${YL}Adding $1 to docker group${NC}"
groupadd docker  # just to be sure that docker group exists
gpasswd -a $1 docker

# final notice
echo -e "${GR}Now you should reboot and login as $1${NC}"