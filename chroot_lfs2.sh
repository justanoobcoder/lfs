#!/bin/bash

export LFS=""
export LFS_TGT=x86_64-lfs-linux-gnu
export SRC_DIR="/sources/src_dir"
export MAKEFLAGS='-j4'

error() { echo -e "$1" && exit; }

echo "Hello from the other side!!!"
sleep 3

cd /sources

cat > /etc/systemd/network/10-ether0.link << "EOF"
[Match]
# Change the MAC address as appropriate for your network device
MACAddress=28:f1:0e:1f:a1:22

[Link]
Name=ether0
EOF

cat > /etc/systemd/network/10-wlan0.link << "EOF"
[Match]
# Change the MAC address as appropriate for your network device
MACAddress=a0:d3:7a:8c:ea:f6

[Link]
Name=wlan0
EOF

cat > /etc/systemd/network/10-eth-dhcp.network << "EOF"
[Match]
Name=ether0

[Network]
DHCP=ipv4

[DHCP]
UseDomains=false
EOF

ln -sfv /run/systemd/resolve/resolv.conf /etc/resolv.conf

echo "lfs-pc" > /etc/hostname

cat > /etc/hosts << "EOF"
# Begin /etc/hosts

127.0.0.1   localhost
::1         localhost
127.0.1.1   lfs-pc.localdomain  lfs-pc

# End /etc/hosts
EOF

cat > /etc/adjtime << "EOF"
0.0 0 0.0
0
LOCAL
EOF

LC_ALL=en_US.utf8 locale charmap
LC_ALL=en_US.utf8 locale language
LC_ALL=en_US.utf8 locale charmap
LC_ALL=en_US.utf8 locale int_curr_symbol
LC_ALL=en_US.utf8 locale int_prefix

cat > /etc/locale.conf << "EOF"
LANG=en_US.UTF-8
EOF

cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

mkdir -pv /etc/systemd/system/getty@tty1.service.d

cat > /etc/systemd/system/getty@tty1.service.d/noclear.conf << EOF
[Service]
TTYVTDisallocate=no
EOF

mkdir -pv /etc/systemd/coredump.conf.d

cat > /etc/systemd/coredump.conf.d/maxuse.conf << EOF
[Coredump]
MaxUse=1G
EOF
