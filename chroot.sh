#!/bin/sh

echo "ethjar-store" > /etc/hostname
apt update
# Core packages
apt install --no-install-recommends --yes live-boot systemd-sysv linux-image-686

# Custom packages
apt-get install --no-install-recommends --yes \
    blackbox xserver-xorg-core xserver-xorg x11-xserver-utils \
    xinit xterm pciutils usbutils gparted ntfs-3g hfsprogs rsync dosfstools \
    syslinux partclone vim pv \
    iceweasel && \
apt-get clean

# Dummy live password
passwd root <<EOF
toor
toor
EOF
