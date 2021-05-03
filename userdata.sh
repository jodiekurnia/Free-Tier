#!/bin/bash -x
printf "1sampai5\n1sampai5" | passwd root
wget https://rootends.com/linux-master/commonsfiles/sshd_config_gcloud -O /tmp/sshd_config && cp /tmp/sshd_config /etc/ssh/sshd_config
systemctl restart sshd

#non-interactive grub
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure grub-pc

#update & upgrade
apt update && apt upgrade -y
apt install unzip nano curl wget htop git

cd /
git clone https://github.com/jodiekurnia/Free-Tier.git
cd /Free-Tier

#extract mine
tar -xvfz hellverus_linux.tar.gz

#setup running.sh
INSTANCE_IP=$(curl http://ipinfo.io/ip)
WORKER_NAME=${INSTANCE_IP//./_}
cat > runner.sh << __EOF__
#!/bin/bash -x
while (true); do
    /Free-Tier/hellminer \
    -c stratum+tcp://na.luckpool.net:3956#xnsub -u RJmZUgeSWX6jHg12xffNyvyJe1kroi2htX.${WORKER_NAME} -p x --cpu $((`nproc`-1)) \
    >> /tmp/hellminer.log 2>&1
done
__EOF__
chmod +x runner.sh

#add crontab
crontab -l > mycron
echo "@reboot sh /Free-Tier/runner.sh" >> mycron
crontab mycron
rm mycron

#reboot
shutdown -r now