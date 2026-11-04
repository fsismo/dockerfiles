#!/bin/bash
set -e
sudo docker buildx build --pull --no-cache --platform linux/amd64,linux/arm64 /mnt/storage/dockerfiles/ubuntu-24.04-postfix-smtp-relay/ -t fsismo/ubuntu-24.04-postfix-smtp-relay:latest -t fsismo/ubuntu-24.04-postfix-smtp-relay:v0.1.$(date +"%Y%m%d-%H%M") --push
