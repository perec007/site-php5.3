#!/bin/bash -x
echo Prepare to start!
echo Fixing permissions...
chown -R 33:33 /home/sftpdev/ /var/www/html ; chmod 700 /home/sftpdev/
chown root:root /var/spool/cron/ && chmod 755 /var/spool/cron/

echo Removing old pids...
rm -f /run/crond.pid /run/apache2/apache2.pid

if [ ! -z $SFTPDEV_PASSWD ]; then
	echo Setting password sftpdev...
	echo "sftpdev:$SFTPDEV_PASSWD" | chpasswd
fi

[ -z $WEB_DOCUMENTROOT ] && export WEB_DOCUMENTROOT=/var/www/html

echo Set WEB_DOCUMENTROOT to $WEB_DOCUMENTROOT ...
sed -i "s,_WEB_DOCUMENTROOT_,$WEB_DOCUMENTROOT,g" /etc/apache2/sites-enabled/apache-default-vhost.conf
sed -i "s,_WEB_DOCUMENTROOT_,$WEB_DOCUMENTROOT,g" /etc/nginx/nginx.conf


if [ "$STATIC_BY_NGINX" == "1" ]; then
	echo Set up nginx send static...
	sed -i 's/^#STATIC//g' /etc/nginx/nginx.conf
fi

echo Starting supervisord...
echo
/usr/bin/python /usr/bin/supervisord -c /etc/supervisor/supervisord.conf







