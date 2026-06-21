#!/usr/bin/env bash

export LFS="/mnt/lfs"

# chmod +x prepare_chroot.sh chroot_lfs.sh chroot_lfs2.sh
# sudo bash prepare_chroot.sh "$LFS"

echo "RUNNING IN CHROOT ENVIRONMENT..."
sleep 3

for script in '/sources/chroot_lfs.sh'; do #'/sources/chroot_lfs2.sh'; do
    sudo chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    MAKEFLAGS="-j$(nproc)"      \
    TESTSUITEFLAGS="-j$(nproc)" \
    /bin/bash --login +h -c "$script"
done

exit 0
