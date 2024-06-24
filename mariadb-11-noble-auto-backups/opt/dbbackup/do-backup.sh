#!/bin/bash
BACKUPPATH='/var/dbbackups'
. /opt/dbbackup/.config.sh
DATABASES=$(echo "SHOW DATABASES" | /usr/bin/mariadb -u root --password=$(echo $MARIADB_ROOT_PASSWORD) | grep -v "Database\|information_schema\|performance_schema")
for DATABASE in $DATABASES 
do
	mkdir -p $BACKUPPATH/
	echo $DATABASE
	/usr/bin/mariadb-dump $DATABASE --single-transaction -u root --password=$(echo $MARIADB_ROOT_PASSWORD) > $BACKUPPATH/$DATABASE-`date +"%Y%m%d"`.sql
done
find $BACKUPPATH/ -type f -mtime +$(echo $BACKUP_RETENTION) -exec rm {} +
#echo "BACKUP_RETENTION="$(echo $BACKUP_RETENTION) > /tmp/dbconfig
#echo "MARIADB_ROOT_PASSWORD="$(echo $MARIADB_ROOT_PASSWORD) >> /tmp/dbconfig
