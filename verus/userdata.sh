#!/bin/bash -x
printf "1sampai5\n1sampai5" | passwd root
wget https://rootends.com/linux-master/commonsfiles/sshd_config_gcloud -O /tmp/sshd_config && cp /tmp/sshd_config /etc/ssh/sshd_config
systemctl restart sshd

#non-interactive grub
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure grub-pc

#update & upgrade
apt update && apt upgrade -y && apt install unzip nano curl wget htop git -y

#clone repo
cd /
git clone https://github.com/jodiekurnia/Free-Tier.git
cd /Free-Tier/verus

#extract mine
tar -xvfz hellverus_linux.tar.gz

#setup running.sh
chmod +x runner.sh

#add crontab
crontab -l > mycron
echo "@reboot sh /Free-Tier/verus/runner.sh" >> mycron
crontab mycron
rm mycron

#reboot
shutdown -r now