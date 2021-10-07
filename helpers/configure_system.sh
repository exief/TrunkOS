#!/usr/bin/env bash

cat etc/passwd >${BASE_DIR}/etc/passwd
cat etc/group >${BASE_DIR}/etc/group
cat etc/fstab >${BASE_DIR}/etc/fstab
cat etc/profile >${BASE_DIR}/etc/profile
echo "TrunkOS" >${BASE_DIR}/etc/HOSTNAME
cat etc/issue >${BASE_DIR}/etc/issue
cat etc/inittab >${BASE_DIR}/etc/inittab
cat etc/mdev.conf >${BASE_DIR}/etc/mdev.conf

mkdir -pv ${BASE_DIR}/boot/grub
touch ${BASE_DIR}/boot/grub/grub.cfg
cat etc/grub.cfg >${BASE_DIR}/boot/grub/grub.cfg

touch ${BASE_DIR}/var/run/utmp ${BASE_DIR}/var/log/{btmp,lastlog,wtmp}
chmod -v 664 ${BASE_DIR}/var/run/utmp ${BASE_DIR}/var/log/lastlog
