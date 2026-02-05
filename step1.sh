#!/usr/bin/env bash

# LFS Version 12.4-systemd

set -e

info() {
    if command -v gum &>/dev/null; then
        gum style --foreground 39 --border-foreground 39 --border rounded --padding "0 1" "INFO: $1"
    else
        echo -e "\e[1;34m[INFO]\e[0m $1"
    fi
}

warn() {
    if command -v gum &>/dev/null; then
        gum style --foreground 214 --border-foreground 214 --border thick --padding "0 1" "WARN: $1"
    else
        echo -e "\e[1;33m[WARN]\e[0m $1"
    fi
}

error() {
    if command -v gum &>/dev/null; then
        gum style --foreground 196 --border-foreground 196 --border double --padding "0 1" --margin "1 0" "ERROR: $1"
    else
        echo -e "\e[1;31m[ERROR]\e[0m $1"
    fi
    exit 1
}

success() {
    if command -v gum &>/dev/null; then
        gum style --foreground 82 --border-foreground 82 --border rounded --padding "0 1" "SUCCESS: $1"
    else
        echo -e "\e[1;32m[SUCCESS]\e[0m $1"
    fi
}

warn "Make sure to mount $LFS_DISK before running this script!
If this is THE FIRST TIME you run this script, chown $LFS to your user!"

select yn in "Continue" "Exit"; do
    case $yn in
    Continue)
        break
        ;;
    Exit)
        info "User exits!"
        exit 0
        ;;
    esac
done

if ! grep -q "$LFS" /proc/mounts; then
    error "Run setup.sh script first!!!"
fi

if ! [ -d "$SRC_DIR" ]; then
    error "Run setup.sh script first!!!"
fi

gum spin --spinner minidot --title "Running after 5 seconds..." -- sleep 5

mkdir -pv "$LFS"/{sources,etc,var} "$LFS"/usr/{bin,lib,sbin}

[ -f "$LFS"/cleanedup ] || mkdir -pv "$LFS"/tools

if ! [ -d "$LFS"/bin ]; then
    for i in bin lib sbin; do
        ln -sv usr/$i "$LFS"/$i
    done
fi

case $(uname -m) in
x86_64) mkdir -pv "$LFS"/lib64 ;;
esac

cp -rf ./*.csv ./*.sh ./*.py chapter* "$LFS"/sources

cd "$LFS"/sources

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
    gawk grep gzip make patch sed tar "xz utils" binutils gcc; do
    source install_package.sh 6 "$package"
done
