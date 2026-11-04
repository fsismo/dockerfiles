#!/bin/bash
# Dumps every database to $BACKUPPATH. Exits 1 if anything fails, and in that
# case applies no retention, so old backups are kept.
set -uo pipefail
umask 077

BACKUPPATH='/var/dbbackups'
LOGFILE="$BACKUPPATH/last-backup.log"
# services.sh follows this file and forwards it to `docker logs`.
CONTAINER_LOG='/var/log/dbbackup.log'
FAILED=0
DUMPED=0

# Sets TZ too, which cron doesn't pass to its jobs.
. /opt/dbbackup/.config.sh
DATE=$(date +"%Y%m%d")

log() {
    local line="[$(date +"%Y-%m-%d %H:%M:%S %z")] [dbbackup] $*"
    echo "$line"
    echo "$line" >> "$LOGFILE"
    echo "$line" >> "$CONTAINER_LOG"
}

mkdir -p "$BACKUPPATH" || exit 1
: > "$LOGFILE" || exit 1
rm -f "$BACKUPPATH"/.*.sql.tmp

if [ -z "${MARIADB_ROOT_PASSWORD:-}" ]; then
    log "ERROR: MARIADB_ROOT_PASSWORD is not set, no backup was made"
    exit 1
fi
# In the environment and not in the arguments, so it stays out of the process list.
export MYSQL_PWD="$MARIADB_ROOT_PASSWORD"

if ! DATABASES=$(/usr/bin/mariadb -u root -N -B -e "SHOW DATABASES" 2>&1); then
    log "ERROR: could not list databases: $DATABASES"
    exit 1
fi

while IFS= read -r DATABASE; do
    case "$DATABASE" in
        information_schema|performance_schema)
            continue
            ;;
    esac
    TARGET="$BACKUPPATH/$DATABASE-$DATE.sql"
    TMP="$BACKUPPATH/.$DATABASE-$DATE.sql.tmp"
    # Dump to a temp file, so a failure never replaces a good backup.
    if ERROR=$(/usr/bin/mariadb-dump -u root --single-transaction "$DATABASE" 2>&1 > "$TMP") && mv "$TMP" "$TARGET"; then
        log "OK: $DATABASE"
        DUMPED=$((DUMPED + 1))
    else
        rm -f "$TMP"
        log "ERROR: $DATABASE: $ERROR"
        FAILED=$((FAILED + 1))
    fi
done <<< "$DATABASES"

if [ "$FAILED" -gt 0 ]; then
    log "ERROR: $FAILED failed, $DUMPED OK. Retention not applied"
    exit 1
fi

if ! [[ "${BACKUP_RETENTION:-}" =~ ^[0-9]+$ ]]; then
    log "ERROR: invalid BACKUP_RETENTION '${BACKUP_RETENTION:-}'. $DUMPED OK, retention not applied"
    exit 1
fi

find "$BACKUPPATH" -maxdepth 1 -type f -name '*.sql' -mtime +"$BACKUP_RETENTION" -delete
log "Finished OK: $DUMPED databases, retention $BACKUP_RETENTION days"
