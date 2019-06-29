#!/bin/bash

sfxcss=$1
#size=870G
size=85G

sudo umount $sfxcss
sudo service aerospike stop
sudo nvme format ${sfxcss}

#primary disk
for i in $(seq 1 1);
do
echo "n
p
$i

+$size
w
" | sudo fdisk $sfxcss
done

sudo cp -f ./aerospike_conf/1P_raw_aerospike.conf /etc/aerospike/aerospike.conf
sudo service aerospike start

#extend disk
echo "n
e
4


w
" | sudo fdisk $sfxcss

#logical disk

for i in $(seq 5 17);
do
echo "n
l
$i

+$size
w
" | sudo fdisk $sfxcss
done

sudo cp -f ./aerospike_conf/1P_raw_aerospike.conf /etc/aerospike/aerospike.conf
sudo service aerospike start
