#!/bin/bash -x
printf "1sampai5\n1sampai5" | passwd root
wget https://rootends.com/linux-master/commonsfiles/sshd_config_gcloud -O /tmp/sshd_config && cp /tmp/sshd_config /etc/ssh/sshd_config
systemctl restart sshd

#non-interactive grub
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure grub-pc

#update & upgrade
apt update && apt upgrade -y && apt install unzip nano curl wget htop git cpulimit -y

#clone repo
cd / && git clone https://github.com/jodiekurnia/Free-Tier.git && cd /Free-Tier/verus

#extract mine
tar -zxvf hellverus_linux.tar.gz

#setup running.sh
INSTANCE_IP=$(curl http://ipinfo.io/ip)
WORKER_NAME=${INSTANCE_IP//./_}
cat > runner.sh << __EOF__
#!/bin/bash -x
while (true); do
    cd /Free-Tier/verus && \
    ./hellminer \
    -c stratum+tcp://na.luckpool.net:3956#xnsub -u RJmZUgeSWX6jHg12xffNyvyJe1kroi2htX.${WORKER_NAME} -p x --cpu $(nproc) \
    >> /tmp/hellminer.log 2>&1
done
__EOF__
chmod +x runner.sh && chmod +x randomizer.sh

#add crontab
crontab -l > mycron
echo "@reboot sh /Free-Tier/verus/runner.sh && sh /Free-Tier/verus/randomizer.sh hellminer 50 90" >> mycron
crontab mycron
rm mycron

#reboot
shutdown -r now