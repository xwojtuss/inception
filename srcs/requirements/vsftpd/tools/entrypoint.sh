#!/bin/sh
echo $(sed -n '1p' $FTP_CREDENTIALS_FILE)":"$(sed -n '2p' $FTP_CREDENTIALS_FILE) | chpasswd

exec vsftpd /etc/vsftpd/vsftpd.conf