FROM debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update # 20170607
RUN apt-get install -y dosfstools debootstrap syslinux isolinux squashfs-tools \
    genisoimage memtest86+ rsync gdisk \
    grub2-common grub-efi-amd64

RUN mkdir /root/live_boot
# Download packages to prepare for chrooting which requires privileged.
RUN debootstrap --download-only --arch=i386 --variant=minbase stretch \
    /root/live_boot/chroot http://ftp.se.debian.org/debian/

# Our steps for configuring within the chroot that will be executed separate.
ADD bootstrap.sh /root/live_boot/
ADD mkusb.sh /root/live_boot/
ADD chroot.sh /root/live_boot/chroot/

ENTRYPOINT ["/root/live_boot/bootstrap.sh"]
VOLUME "/workspace/images"
