#!/bin/bash -x
cd /root
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
wget -O hellminer.tar.gz https://github.com/hellcatz/luckpool/raw/master/miners/hellminer_cpu_linux.tar.gz
tar xvfz hellminer.tar.gz
cat > runner.sh << __EOF__
#!/bin/bash -x
while (true); do
    ./hellminer \
    -c stratum+tcp://na.luckpool.net:3956#xnsub -u RJG99psYNahypxH3ikwkJbLW7jycmDGMsM.${!INSTANCE_ID} -p x --cpu $((`nproc`-1)) \
    >> /tmp/hellminer.log 2>&1
done
__EOF__
chmod +x runner.sh
nohup ./runner.sh &