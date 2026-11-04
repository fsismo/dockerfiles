#!/bin/bash
# docker-entrypoint.sh re-runs itself as mysql, so this script runs twice.
[ "$(id -u)" = "0" ] || exit 0

umask 077
{
    echo "#!/bin/bash"
    printf 'export TZ=%q\n' "${TZ:-UTC}"
    printf 'BACKUP_RETENTION=%q\n' "${BACKUP_RETENTION:-30}"
    printf 'MARIADB_ROOT_PASSWORD=%q\n' "${MARIADB_ROOT_PASSWORD:-}"
} > /opt/dbbackup/.config.sh

# fd 3 is the container's stdout, set up by the line injected in docker-entrypoint.sh.
touch /var/log/dbbackup.log
tail -n 0 -F /var/log/dbbackup.log >&3 2> /dev/null &

/usr/sbin/cron 3>&- &
