#!/bin/bash
set -e
sudo docker buildx build --pull --no-cache --platform linux/amd64,linux/arm64 /mnt/storage/dockerfiles/ubuntu-22.04-php-wordpress/ -t fsismo/ubuntu-22.04-php-wordpress:latest -t fsismo/ubuntu-22.04-php-wordpress:v0.7.$(date +"%Y%m%d-%H%M") --push
