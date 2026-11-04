#!/bin/bash
set -e
sudo docker buildx build --pull --no-cache --platform linux/amd64,linux/arm64 /mnt/storage/dockerfiles/mariadb-12.3-noble-auto-backups/ -t fsismo/mariadb-12.3-noble-auto-backups:latest -t fsismo/mariadb-12.3-noble-auto-backups:12.3.$(date +"%Y%m%d-%H%M") --push
