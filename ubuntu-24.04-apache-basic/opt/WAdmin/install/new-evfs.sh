#!/bin/bash
source ./chek-root.sh

function GETSIZE {
	echo "Ingrese el tambaño en GB que le quiere asignar a la unidad"
	read SIZE
	if ! [ "$SIZE" -ge 0 ] 2> /dev/null; then
		echo "Solo enteros"
		GETSIZE
	fi
	SIZE=$((1024000 * $SIZE))
}

if [ -f /var/fs/encrypted.fs ]; then
	echo "Ya existe un disco virtual creado en /var/fs/encrypted.fs debe renombrarbro o borrarlo para crear uno nuevo".
else
	mkdir -p /var/fs/
	GETSIZE	
	echo "Creando disco virtual!"
	dd if=/dev/zero bs=1024 count=$SIZE 2> /dev/null | pv  | dd of=/var/fs/encrypted.fs 2> /dev/null
	sleep 5
	losetup /dev/loop107 /var/fs/encrypted.fs
	cryptsetup --verbose --verify-passphrase luksFormat /dev/loop107
	cryptsetup luksOpen /dev/loop107 encryptedfs0
	mkfs.ext4 /dev/mapper/encryptedfs0
	mkdir -p /var/sambashare/
	echo NO > /var/sambashare/.status
	mount /dev/mapper/encryptedfs0 /var/sambashare/
	echo SI > /var/sambashare/.status
	mkdir -p /var/sambashare/backup
	mkdir -p /var/sambashare/compartido
fi

