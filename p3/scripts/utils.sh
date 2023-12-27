#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
NC="\e[0m"

print_status() {
	echo -e "${GREEN}[STATUS] $1$NC"
}

print_error() {
	echo -e "${RED}[ERROR] $1$NC"
}

check_root() {
	if [ "$(id -u)" != "0" ]
	then
		print_error "Can't run this script without root permissions!"
		exit 1
	fi
}

