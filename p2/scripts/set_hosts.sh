#!/bin/bash

if grep "app[1-3].com" /etc/hosts > /dev/null 2>&1
then
	echo "One or more hosts are already set."
	exit 0
fi

if [ "$(id -u)" != "0" ]
then
	echo "Can't set hosts without root permissions..."
	exit 1
fi

echo "Setting the hosts..."

cat >> /etc/hosts << EOF
192.168.56.110 app1.com
192.168.56.110 app2.com
192.168.56.110 app3.com
EOF
