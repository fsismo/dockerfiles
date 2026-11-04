#!/bin/bash
set -e
sudo docker buildx build --pull --no-cache --platform linux/amd64,linux/arm64 /mnt/storage/dockerfiles/ubuntu-24.04-postfix-smtp/ -t fsismo/ubuntu-24.04-postfix-smtp:latest -t fsismo/ubuntu-24.04-postfix-smtp:v1.$(date +"%Y%m%d-%H%M") --push
