# Based on mariadb:12.3-noble https://hub.docker.com/_/mariadb
Adds a bash script that backs up every database daily at 3:30 am to `/var/dbbackups`.

`BACKUP_RETENTION` sets how many days dumps are kept (default: 30). If any dump fails, nothing is deleted.

Dumps are owned by root with mode 600. Check `/var/dbbackups/last-backup.log` or `docker logs` (lines starting with `[dbbackup]`) for the result of each run.

`MARIADB_AUTO_UPGRADE=1` upgrades the system tables on start when the data comes from an older version. Back up first: MariaDB can't go back to an older version on the same data.

See `docker-compose.yml` for an example.
