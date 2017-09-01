#!/bin/bash
set -e

rm -f /etc/init.d/rcS
dpkg-divert --package fai-nfsroot --remove --rename /etc/init.d/rcS
insserv -r fai-abort
export LC_ALL=C
adduser --disabled-login --gecos "fai demo user" demo
ROOTPW='$1$kBnWcO.E$djxB128U7dMkrltJHPf6d1'
usermod -p "$ROOTPW" demo

apt-cache dumpavail > /var/lib/dpkg/available
apt-get update
aptitude -y install dosfstools at-spi2-core locales task-xfce-desktop network-manager systemd-sysv sysvinit-core-
apt-get clean

rm lib/systemd/system/wpa_supplicant@.service
