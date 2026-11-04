#!/bin/bash
set -e
sudo docker buildx build --pull --no-cache --platform linux/amd64,linux/arm64 /mnt/storage/dockerfiles/ubuntu-22.04-apache-php/ -t fsismo/ubuntu-22.04-apache-php:latest -t fsismo/ubuntu-22.04-apache-php:v0.2.$(date +"%Y%m%d-%H%M") --push
