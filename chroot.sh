#!/bin/bash

LFS=/mnt/lfs

error() { echo -e "$1" && exit; }

sudo chroot "$LFS" /usr/bin/env -i          \
    HOME=/root TERM="$TERM"            \
    PS1='(lfs chroot) \u:\w\$ '        \
    PATH=/usr/bin:/usr/sbin            \
    /bin/bash --login

exit 0
