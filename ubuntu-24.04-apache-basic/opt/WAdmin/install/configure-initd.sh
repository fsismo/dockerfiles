#!/bin/bash
source ./chek-root.sh
ln /opt/WAdmin/WAdmin-init.sh /etc/init.d/WAdmin
chmod 700 /etc/init.d/WAdmin
update-rc.d WAdmin defaults
update-rc.d WAdmin enable
systemctl start WAdmin
systemctl status WAdmin

