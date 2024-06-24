#!/bin/bash
/usr/sbin/cron &
ln -sf /proc/$$/fd/1 /var/log/apache2/access.log
ln -sf /proc/$$/fd/2 /var/log/apache2/error.log
/usr/sbin/apache2ctl -D FOREGROUND
