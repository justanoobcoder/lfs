#!/usr/bin/env bash

# LFS Version 12.4-systemd

set -e

# export LFS="/mnt/lfs"
# export LC_ALL="POSIX"
# export LFS_TGT="x86_64-lfs-linux-gnu"
# export LFS_DISK="/dev/nvme0n1p7"
# export SRC_DIR="$LFS/sources/src_dir"
# export CONFIG_SITE="$LFS/usr/share/config.site"
# export MAKEFLAGS="-j$(nproc)"

error() { echo -e "$1" && exit 1; }

echo -e "Make sure to mount $LFS_DISK before running this script!\nIf this is THE FIRST TIME you run this script, chown $LFS to your user!"

select yn in "Continue" "Exit"; do
    case $yn in
    Continue)
        break
        ;;
    Exit) error "User exits!" ;;
    esac
done

if ! grep -q $LFS /proc/mounts; then
    error "Mount $LFS_DISK to $LFS first!!!"
fi

echo "Running after 5 seconds ..."
sleep 5

mkdir -pv $LFS/{sources,etc,var} $LFS/usr/{bin,lib,sbin}
mkdir -pv $SRC_DIR
# if ! grep -q $SRC_DIR /proc/mounts; then
#     sudo mount -t tmpfs -o size=10G tmpfs $SRC_DIR
# fi
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

#export PATH="$LFS/tools/bin:$PATH"

if [ ! -f packages.csv ] || [ ! -f patches.csv ]; then
    if [ ! -d ./venv ]; then
        python -m venv venv
    fi
    source ./venv/bin/activate
    pip install -r requirements.txt
    python scrape.py
    deactivate
fi
python download.py

if [ "$(cat failed_packages.csv | wc -l)" != "1" ] ||
    [ "$(cat failed_patches.csv | wc -l)" != "1" ]; then
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
    gawk grep gzip make patch sed tar xz binutils gcc; do
    source install_package.sh 6 "$package"
done
