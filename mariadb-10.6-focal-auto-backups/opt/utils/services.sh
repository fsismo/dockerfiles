#!/bin/bash
echo "#!/bin/bash" > /opt/dbbackup/.config.sh
echo "BACKUP_RETENTION="$(echo $BACKUP_RETENTION) >> /opt/dbbackup/.config.sh
echo "MARIADB_ROOT_PASSWORD="$(echo $MARIADB_ROOT_PASSWORD) >> /opt/dbbackup/.config.sh
/usr/sbin/cron &
