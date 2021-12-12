#!/bin/bash

export LFS=/mnt/lfs

error() { echo -e "$1" && exit; }

sudo umount -l $LFS/sources/src_dir
sudo umount $LFS/dev/pts
sudo umount $LFS/dev
sudo umount $LFS/proc
sudo umount $LFS/sys
sudo umount $LFS/run
sudo umount $LFS/boot/efi
sudo umount $LFS

exit 0
