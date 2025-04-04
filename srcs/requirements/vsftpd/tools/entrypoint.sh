#!/bin/sh

if [ ! -f /etc/ssl/certs/vsftpd-selfsigned.crt ]; then
	adduser -D $(sed -n '1p' $FTP_CREDENTIALS_FILE)
	echo $(sed -n '1p' $FTP_CREDENTIALS_FILE)":"$(sed -n '2p' $FTP_CREDENTIALS_FILE) | chpasswd
	mkdir -p /home/vsftpd
	chown $(sed -n '1p' $FTP_CREDENTIALS_FILE):$(sed -n '1p' $FTP_CREDENTIALS_FILE) /home/vsftpd

	usermod -d /home/vsftpd $(sed -n '1p' $FTP_CREDENTIALS_FILE)

	cat /run/secrets/vsftpd_cert > /etc/ssl/certs/vsftpd-selfsigned.crt
	cat /run/secrets/vsftpd_key > /etc/ssl/private/vsftpd-selfsigned.key
	sleep 3
	chown -R $(sed -n '1p' $FTP_CREDENTIALS_FILE):$(sed -n '1p' $FTP_CREDENTIALS_FILE) /home/vsftpd
	chmod -R 755 /home/vsftpd
fi

exec vsftpd /etc/vsftpd/vsftpd.conf
