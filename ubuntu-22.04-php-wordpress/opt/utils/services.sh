#!/bin/bash
mkdir -p /var/www/html
rm -r /var/www/html/index.html
if [ -z "$(ls -A /var/www/html)" ]; then
    sudo docker container stop ubuntu-22.04-php-wordpress && sudo docker container rm ubuntu-22.04-php-wordpress
fi
apachectl -D FOREGROUND