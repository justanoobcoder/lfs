#!/usr/bin/env bash

LFS="/mnt/lfs"
LFS_DISK="/dev/nvme0n1p7"
SRC_DIR="$LFS/sources/src_dir"

[ -d "$LFS" ] || sudo mkdir -pv "$LFS" && sudo chown "$USER":users "$LFS"

if ! grep -q "$LFS" /proc/mounts; then
    sudo mount "$LFS_DISK" "$LFS"
fi

mkdir -pv "$SRC_DIR"
if ! grep -q "$SRC_DIR" /proc/mounts; then
    sudo mount -t tmpfs -o size=10G tmpfs "$SRC_DIR"
fi
