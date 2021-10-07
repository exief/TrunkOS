#!/usr/bin/env bash

if [[ ! -e $BASE_DIR ]]; then
	mkdir -pv $BASE_DIR
fi

mkdir -pv ${BASE_DIR}/{bin,boot{,grub},dev,{etc/,}opt,home,lib/{firmware,modules},lib64,mnt}
mkdir -pv ${BASE_DIR}/{proc,media/{floppy,cdrom},sbin,srv,sys}
mkdir -pv ${BASE_DIR}/var/{lock,log,mail,run,spool}
mkdir -pv ${BASE_DIR}/var/{opt,cache,lib/{misc,locate},local}
install -dv -m 0750 ${BASE_DIR}/root
install -dv -m 1777 ${BASE_DIR}{/var,}/tmp
install -dv ${BASE_DIR}/etc/init.d
mkdir -pv ${BASE_DIR}/usr/{,local/}{bin,include,lib{,64},sbin,src}
mkdir -pv ${BASE_DIR}/usr/{,local/}share/{doc,info,locale,man}
mkdir -pv ${BASE_DIR}/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv ${BASE_DIR}/usr/{,local/}share/man/man{1,2,3,4,5,6,7,8}
for dir in ${BASE_DIR}/usr{,/local}; do
    ln -sv share/{man,doc,info} ${dir}
done

install -dv ${BASE_DIR}/cross-tools{,/bin}
ln -svf ../proc/mounts ${BASE_DIR}/etc/mtab
