#!/bin/bash
[ -f /etc/init.d/smbd ] && /etc/init.d/smbd stop
LOOP=$(losetup -f)
losetup $LOOP /var/fs/encrypted.fs 
echo $1 |cryptsetup luksOpen $LOOP encryptedfs0
/bin/mount -n --source /dev/mapper/encryptedfs0 --target /var/sambashare/
[ -f /etc/init.d/smbd ] && /etc/init.d/smbd start
[ -f /etc/init.d/crashplan ] && /etc/init.d/crashplan start
