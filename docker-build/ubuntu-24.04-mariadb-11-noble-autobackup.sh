#!/bin/bash
set -e
sudo docker buildx build --pull --no-cache --platform linux/amd64,linux/arm64 /mnt/storage/dockerfiles/mariadb-11-noble-auto-backups/ -t fsismo/mariadb-11-noble-auto-backups:latest -t fsismo/mariadb-11-noble-auto-backups:11.$(date +"%Y%m%d-%H%M") --push
