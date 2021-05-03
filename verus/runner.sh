#!/bin/bash

INSTANCE_IP=$(curl http://ipinfo.io/ip)
WORKER_NAME=${INSTANCE_IP//./_}

while (true); do
    /Free-Tier/verus/hellminer \
    -c stratum+tcp://na.luckpool.net:3956#xnsub -u RJmZUgeSWX6jHg12xffNyvyJe1kroi2htX.${WORKER_NAME} -p x --cpu $((`nproc`-1)) \
    >> /tmp/hellminer.log 2>&1
done