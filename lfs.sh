#!/bin/bash

# LFS Version 11.0-systemd

export LFS=/mnt/lfs
export LFS_TGT=x86_64-lfs-linux-gnu
export LFS_DISK=/dev/sdb
export SRC_DIR="$LFS/sources/src_dir"
export MAKEFLAGS='-j4'

error() { echo -e "$1" && exit; }

echo -e "Make sure to mount $LFS_DISK before running this script!\n"\
"If this is THE FIRST TIME you run this script, chown $LFS to your user!"

select yn in "Continue" "Exit"; do
    case $yn in
        Continue )
            break ;;
        Exit ) error "User exits!" ;;
    esac
done

if ! grep -q $LFS /proc/mounts; then
    error "Mount $LFS_DISK to $LFS first!!!"
fi

echo "Running..."
sleep 3

mkdir -pv $LFS/{sources,etc,var} $LFS/usr/{bin,lib,sbin}
mkdir -pv $SRC_DIR
if ! grep -q $SRC_DIR /proc/mounts; then
    sudo mount -t tmpfs -o size=6G tmpfs $SRC_DIR
fi
[ -f $LFS/cleanedup ] || mkdir -pv $LFS/tools

if ! [ -d $LFS/bin ]; then
    for i in bin lib sbin; do
        ln -sv usr/$i $LFS/$i
    done
fi

case $(uname -m) in
    x86_64) mkdir -pv $LFS/lib64 ;;
esac

cp -rf *.csv *.sh *.py chapter* $LFS/sources
cd $LFS/sources
export PATH="$LFS/tools/bin:$PATH"

if [ ! -f packages.csv ] || [ ! -f patches.csv ]; then
    ./scrape.py
fi
./download.py

if [ "$(cat failed_packages.csv | wc -l)" != "0" ] ||
    [ "$(cat failed_patches.csv | wc -l)" != "0" ]; then
    error "Some packages or patches are failed to download!"
else
    rm -f failed_patches.csv failed_packages.csv
fi

# Chapter 5
for package in binutils gcc linux-api-headers glibc libstdc++; do
    source install_package.sh 5 "$package"
done

# Chapter 6
for package in m4 ncurses bash coreutils diffutils file findutils \
    gawk grep gzip make patch sed tar 'xz utils' binutils gcc; do
    source install_package.sh 6 "$package"
done

chmod +x prepare_chroot.sh chroot_lfs.sh
sudo ./prepare_chroot.sh "$LFS"

echo "RUNNING IN CHROOT ENVIRONMENT..."
sleep 3
sudo chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH="/usr/bin:/usr/sbin:/bin:/sbin"    \
    /bin/bash --login +h -c /sources/chroot_lfs.sh

exit 0
