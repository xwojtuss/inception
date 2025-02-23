#!/bin/sh
echo $(sed -n '1p' $FTP_CREDENTIALS_FILE)":"$(sed -n '2p' $FTP_CREDENTIALS_FILE) | chpasswd

cat /run/secrets/vsftpd_cert > /etc/ssl/certs/vsftpd-selfsigned.crt
cat /run/secrets/vsftpd_key > /etc/ssl/private/vsftpd-selfsigned.key

exec vsftpd /etc/vsftpd/vsftpd.conf