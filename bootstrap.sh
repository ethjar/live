#!/bin/sh

debootstrap \
    --arch=i386 \
    --variant=minbase \
    stretch $HOME/live_boot/chroot http://ftp.se.debian.org/debian/

# Initialize from within the chroot.
chroot $HOME/live_boot/chroot /chroot.sh
