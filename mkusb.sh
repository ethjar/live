#!/bin/sh
set -e

# Create our boot image.
# TODO: Package custom ware before here.
mkdir -p /workspace/image/
mkdir -p /mnt/{usb,efi}

mksquashfs \
    $HOME/live_boot/chroot \
    /workspace/image/filesystem.squashfs \
    -noappend \
    -e boot

cp $HOME/live_boot/chroot/boot/vmlinuz-* \
    /workspace/image/vmlinuz1 && \
cp $HOME/live_boot/chroot/boot/initrd.img-* \
    /workspace/image/initrd1

dd if=/dev/zero of=/workspace/disk.img bs=1M count=4096
losetup /dev/loop1 /workspace/disk.img

sgdisk \
    --new=1:2048:4095 \
        --typecode=1:ef02 \
        --change-name=1:"BIOS" \
        /dev/loop1 \
    --new=2:4096:413695 \
        --typecode=2:ef00 \
        --change-name=2:"EFI" \
        /dev/loop1 \
    --new=3:413696:`sgdisk -E /dev/loop1 | tail -n1` \
        --typecode=3:8300 \
        --change-name=3:"LINUX" \
        /dev/loop1

# https://wiki.archlinux.org/index.php/Multiboot_USB_drive#Hybrid_UEFI_GPT_.2B_BIOS_GPT.2FMBR_boot
gdisk /dev/loop1 << EOF
r
h
1 2 3
N
83
Y
N
x
h
w
Y
EOF

losetup -D
losetup /dev/loop1 /workspace/disk.img -o $((4096*512)) --sizelimit $((409599*512))
mkfs.vfat -F32 -n EFI /dev/loop1
mount /dev/loop1 /mnt/efi
losetup /dev/loop2 /workspace/disk.img -o $((413696*512))
mkfs.vfat -F32 -n LINUX /dev/loop2
mount /dev/loop2 /mnt/usb

grub-install \
    --target=x86_64-efi \
    --efi-directory=/mnt/efi \
    --boot-directory=/mnt/usb/boot \
    --removable \
    --recheck

rsync -rv /workspace/image/ /mnt/usb/live/
cat > /mnt/usb/boot/grub/grub.cfg << EOF
set default="0"
set timeout=10

menuentry "Debian Live x86" {
    linux /live/vmlinuz1 boot=live
    initrd /live/initrd1
}
EOF
umount /mnt/efi
umount /mnt/usb

losetup -D
# losetup /dev/loop1 /workspace/disk.img
# apt update && apt install -y grub-pc
# grub-install \
#     --modules part_msdos \
#     --target=i386-pc \
#     --boot-directory=/mnt/usb/boot \
#     --recheck \
#     /dev/loop1
# https://forums.docker.com/t/no-device-mapper-support-in-the-kernel/12348
kpartx -l /workspace/disk.img