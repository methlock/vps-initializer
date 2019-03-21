#!/usr/bin/env bash
# You must be in script folder to run it like this:
# $ bash vps_init.sh <user> <password> <new_ssh_port>

# checking if three arguments are passed in
if [[ $# -ne 3 ]]
  then
    echo "Bad number of arguments! Try: $ bash vps_init.sh <new_user> <password> <new_ssh_port>"
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
mkdir -p home/$1/.ssh  # make sure that this folder exists
echo -e "${YL}Resolving SSH key${NC}"
read -p "Please enter your generated ssh key. It should start like ssh-rsa AAAA...: `echo $'\n> '`"  SSH_KEY
echo $SSH_KEY >> home/$1/.ssh/authorized_keys
chmod -R go= home/$1/.ssh
chown -R $1:$1 home/$1/.ssh
echo -e "${YL}Setting ssh config${NC}"
sed -i '/^PermitRootLogin/s/yes/no/' /etc/ssh/sshd_config
sed -i '/^Port/s/22/'$3'/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
systemctl restart ssh

# custom installs
echo -e "${YL}Installing Docker and setting symlink${NC}"
apt-get -y install docker.io && ln -sf /usr/bin/docker.io /usr/local/bin/docker

echo -e "${YL}Adding $1 to docker group${NC}"
groupadd docker  # just to be sure that docker group exists
gpasswd -a $1 docker

# final notice
echo -e "${GR}Now you should reboot and login as $1${NC}"
