#!/bin/bash
set -e
sudo docker buildx build --pull --no-cache --platform linux/amd64,linux/arm64 /mnt/storage/dockerfiles/ubuntu-24.04-apache-php/ -t fsismo/ubuntu-24.04-apache-php:latest -t fsismo/ubuntu-24.04-apache-php:v0.3.$(date +"%Y%m%d-%H%M") --push
