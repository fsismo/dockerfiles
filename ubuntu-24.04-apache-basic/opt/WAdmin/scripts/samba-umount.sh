#!/bin/bash
LOOP=$(losetup -l |grep encrypted | awk '{print $1}')
[ -f /etc/init.d/crashplan ] && /etc/init.d/crashplan stop
[ -f /etc/init.d/smbd ] && /etc/init.d/smbd stop
umount /dev/mapper/encryptedfs0
cryptsetup luksClose encryptedfs0
losetup -d $LOOP
[ -f /etc/init.d/smbd ] && /etc/init.d/smbd start
dmsetup remove_all
