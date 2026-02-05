#!/usr/bin/env bash

export LFS=/mnt/lfs

sudo umount -l $LFS/sources/src_dir
sudo umount $LFS/dev/pts
sudo umount $LFS/dev
sudo umount $LFS/proc
sudo umount $LFS/sys
sudo umount $LFS/run
sudo umount $LFS/boot/efi
sudo umount $LFS

exit 0
