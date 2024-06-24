# Based on mariadb:10.6-focal https://hub.docker.com/_/mariadb
Just added a bash script to create backups every days at 3am.

```# MariaDB 10.6
version: '3.1'
services:
  db:
    image: fsismo/mariadb-10.6-focal-auto-backups:latest
    environment:
      - TZ=America/Argentina/Buenos_Aires
      - MARIADB_ROOT_PASSWORD=S3cr3t0
    restart: always
    ports:
      - 3306:3306
    volumes:
      - ./mariadb/data:/var/lib/mysql
      - ./mariadb/dbbackups:/var/dbbackups

  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080
    environment:
      - TZ=America/Argentina/Buenos_Aires```