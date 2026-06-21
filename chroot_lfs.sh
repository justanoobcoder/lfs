#!/usr/bin/env bash

export LFS=""
export LFS_TGT=x86_64-lfs-linux-gnu
export SRC_DIR="/sources/src_dir"

info() {
    echo -e "\e[1;34m[INFO]\e[0m $1"
}

warn() {
    echo -e "\e[1;33m[WARN]\e[0m $1"
}

error() {
    echo -e "\e[1;31m[ERROR]\e[0m $1"
    exit 1
}

success() {
    echo -e "\e[1;32m[SUCCESS]\e[0m $1"
}

echo "Hello from the other side!!!"
sleep 3

# mkdir -pv /{boot,home,mnt,opt,srv}
# mkdir -pv /etc/{opt,sysconfig}
# mkdir -pv /lib/firmware
# mkdir -pv /media/{floppy,cdrom}
# mkdir -pv /usr/{,local/}{include,src}
# mkdir -pv /usr/lib/locale
# mkdir -pv /usr/local/{bin,lib,sbin}
# mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
# mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
# mkdir -pv /usr/{,local/}share/man/man{1..8}
# mkdir -pv /var/{cache,local,log,mail,opt,spool}
# mkdir -pv /var/lib/{color,misc,locate}
#
# ln -sfv /run /var/run
# ln -sfv /run/lock /var/lock
#
# install -dv -m 0750 /root
# install -dv -m 1777 /tmp /var/tmp
#
# ln -sv /proc/self/mounts /etc/mtab
#
# cat > /etc/hosts << EOF
# 127.0.0.1  localhost $(hostname)
# ::1        localhost
# EOF
#
# cat > /etc/passwd << "EOF"
# root:x:0:0:root:/root:/bin/bash
# bin:x:1:1:bin:/dev/null:/usr/bin/false
# daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
# messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
# systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/usr/bin/false
# systemd-journal-remote:x:74:74:systemd Journal Remote:/:/usr/bin/false
# systemd-journal-upload:x:75:75:systemd Journal Upload:/:/usr/bin/false
# systemd-network:x:76:76:systemd Network Management:/:/usr/bin/false
# systemd-resolve:x:77:77:systemd Resolver:/:/usr/bin/false
# systemd-timesync:x:78:78:systemd Time Synchronization:/:/usr/bin/false
# systemd-coredump:x:79:79:systemd Core Dumper:/:/usr/bin/false
# uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
# systemd-oom:x:81:81:systemd Out Of Memory Daemon:/:/usr/bin/false
# nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
# EOF
#
# cat > /etc/group << "EOF"
# root:x:0:
# bin:x:1:daemon
# sys:x:2:
# kmem:x:3:
# tape:x:4:
# tty:x:5:
# daemon:x:6:
# floppy:x:7:
# disk:x:8:
# lp:x:9:
# dialout:x:10:
# audio:x:11:
# video:x:12:
# utmp:x:13:
# clock:x:14:
# cdrom:x:15:
# adm:x:16:
# messagebus:x:18:
# systemd-journal:x:23:
# input:x:24:
# mail:x:34:
# kvm:x:61:
# systemd-journal-gateway:x:73:
# systemd-journal-remote:x:74:
# systemd-journal-upload:x:75:
# systemd-network:x:76:
# systemd-resolve:x:77:
# systemd-timesync:x:78:
# systemd-coredump:x:79:
# uuidd:x:80:
# systemd-oom:x:81:
# wheel:x:97:
# users:x:999:
# nogroup:x:65534:
# EOF
#
# echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd
# echo "tester:x:101:" >> /etc/group
# install -o tester -d /home/tester
#
# touch /var/log/{btmp,lastlog,faillog,wtmp}
# chgrp -v utmp /var/log/lastlog
# chmod -v 664  /var/log/lastlog
# chmod -v 600  /var/log/btmp

cd /sources

echo "Installing packages in 3s..."
sleep 3

# Chapter 7
for package in gettext bison perl python texinfo util-linux; do
    source install_package.sh 7 "$package"
done

if ! [ -f /cleanedup ]; then
    rm -rf /usr/share/{info,man,doc}/*
    find /usr/{lib,libexec} -name \*.la -delete
    rm -rf /tools
    touch /cleanedup
    echo "Cleaned up!"
fi

# Chapter 8
for package in man-pages iana-etc glibc zlib bzip2 'xz utils' lz4 zstd file readline pcre2 m4 bc \
    flex tcl expect dejagnu pkgconf binutils gmp mpfr mpc attr acl libcap libxcrypt shadow gcc \
    ncurses sed psmisc gettext bison grep bash libtool gdbm gperf expat inetutils less \
    perl 'xml::parser' intltool autoconf automake openssl libelf libffi sqlite python \
    flit_core packaging wheel setuptools ninja meson kmod coreutils diffutils gawk findutils groff gzip iproute2 kbd \
    libpipeline make patch tar texinfo vim markupsafe jinja2 systemd d-bus man-db procps util-linux e2fsprogs; do
    source install_package.sh 8 "$package"
done

if ! [ -f /cleanedup2 ]; then
    rm -rf /tmp/{*,.*}
    find /usr/lib /usr/libexec -name \*.la -delete
    find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf
    userdel -r tester
    touch /cleanedup2
    echo "Cleaned up"
fi
