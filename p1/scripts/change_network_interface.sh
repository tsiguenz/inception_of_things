#!/bin/bash

if [ "$(id -u)" != "0" ]
then
	echo "Can't run this script without root permissions..."
	exit 1
fi

echo "Change network interface..."

# for ifconfig
apt install net-tools
sed -i 's/set-name: enp0s3/set-name: eth1/' /etc/netplan/50-cloud-init.yaml
netplan apply
