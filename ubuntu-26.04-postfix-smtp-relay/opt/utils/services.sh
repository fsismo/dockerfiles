#!/bin/bash

#/etc/postfix/main.cf
echo "maillog_file = /dev/stdout" >> /etc/postfix/main.cf
sed -i -e "s|mynetworks = 127.*|mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 $SMTP_NETWORK|" /etc/postfix/main.cf
sed -i -e "s|myhostname =.*|myhostname = $SMTP_HOSTNAME|" /etc/postfix/main.cf
sed -i -e "s|relayhost =|relayhost = [$SMTP_SRV]:$SMTP_PORT|" /etc/postfix/main.cf
echo "smtp_sasl_auth_enable = yes" >> /etc/postfix/main.cf
echo "smtp_sasl_security_options = noanonymous" >> /etc/postfix/main.cf
echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" >> /etc/postfix/main.cf
echo "smtp_use_tls = yes" >> /etc/postfix/main.cf
echo "smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt" >> /etc/postfix/main.cf


echo "root: ${SMTP_EMAIL}" >> /etc/aliases
echo "${SMTP_DOMAIN}" >> /etc/mailname
echo "[${SMTP_SRV}]:${SMTP_PORT} ${SMTP_EMAIL}:${SMTP_EMAIL_PASSWORD}" >> /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd && \
chmod 0600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
cp /etc/resolv.conf /var/spool/postfix/etc/resolv.conf
/usr/sbin/postfix start-fg
