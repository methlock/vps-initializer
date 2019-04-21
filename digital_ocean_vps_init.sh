#!/usr/bin/env bash

read -p "This script assumes that SSH key is already configured and you are logged as root in root home directory. True? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
read -p "Enter new username: " USER

# constants
YL='\033[1;33m' # yellow
GR='\033[0;32m' # green
RE='\033[0;31m' # red
NC='\033[0m'    # no color
echo -e "${GR}Running initial VPS setting${NC}"

# updates
echo -e "${YL}Updating${NC}"
sleep 3
apt-get update && apt-get upgrade -y
apt-get autoclean && apt-get autoremove

# user creation
echo -e "${YL}Creating $1 sudo user${NC}"
adduser --disabled-password --gecos "" $USER
echo $USER:password_to_disable | chpasswd
adduser $USER sudo

# ssh
echo -e "${YL}Copying and setting root ssh key for new user${NC}"
mkdir /home/$USER/.ssh
cp .ssh/authorized_keys /home/$USER/.ssh/authorized_keys
chmod -R go= /home/$USER/.ssh
chown -R $USER:$USER /home/$USER/.ssh
echo -e "${YL}Updating SSH config${NC}"
sed -i '/^PermitRootLogin/s/yes/no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
service ssh restart

echo -e "${GR}Now you should reboot and login as $USER$ with same ssh key as root! ${NC}"