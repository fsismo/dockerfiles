#!/bin/bash
mkdir -p /var/www/html
rm -r /var/www/html/index.html
if [ -z "$(ls -A /var/www/html)" ]; then
    curl https://wordpress.org/latest.tar.gz | tar zx -C /tmp/ 
    mv /tmp/wordpress/* /var/www/html
    chown -R www-data.www-data /var/www/html
fi
apachectl -D FOREGROUND