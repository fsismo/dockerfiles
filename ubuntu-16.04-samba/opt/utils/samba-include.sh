#!/bin/sh
# default samba .conf file
SMB_CONF=/etc/samba/smb.conf
# samba directory to store samba configuration files individually
SMB_CONF_DIR=/etc/samba/smb.conf.d/
# first need to create individual .conf files with desired sambs configuration into path defined above

# file which contains all includes to samba configuration files individually
SMB_INCLUDES=/etc/samba/includes.conf
# adds includes.conf file existance to smb.conf file
if ! grep -q 'include = '"${SMB_INCLUDES}" $SMB_CONF ; then
   echo 'include = '"${SMB_INCLUDES}" | tee -a $SMB_CONF > /dev/null
fi

# create directory smb.conf.d to store samba .conf files
mkdir -p $SMB_CONF_DIR

# If there isn't any configuration files I copy the sample one
if [ -z "$(ls -A $SMB_CONF_DIR)" ]; then
   cp /opt/utils/sample.conf $SMB_CONF_DIR
fi

mkdir -p $(cat /etc/samba/smb.conf.d/* |grep path |grep sambashare|cut -d = -f 2)

# Set permisions to the sambashares
chown -R shareuser.sharegroup /var/sambashare/

# populates includes.conf with files in smb.conf.d directory
ls "${SMB_CONF_DIR}"* | sed -e 's/^/include = /' > $SMB_INCLUDES
#systemctl restart smbd.service
