example docker-compose.yml

```
example.com:
 image: casp/site-php5.3
 restart: always
 container_name: example.com
 hostname: example.com
 volumes:
  - /srv/docker/docker-sitehosting/example.com/www:/var/www/html
  - /srv/docker/docker-sitehosting/example.com/log/nginx/:/var/log/nginx
  - /srv/docker/docker-sitehosting/example.com/log/apache2/:/var/log/apache2
  - /srv/docker/docker-sitehosting/example.com/nginx/nginx.conf:/etc/nginx/nginx.conf
  - /srv/docker/docker-sitehosting/example.com/log/supervisor/:/var/log/supervisor
  - /srv/docker/docker-sitehosting/example.com/letsencrypt:/var/www/letsencrypt:ro
  - /srv/docker/docker-sitehosting/example.com/sftpdev-home:/home/sftpdev
  - /srv/docker/docker-sitehosting/crontabs/:/var/spool/cron/:rw
 ports:
  - "1089:80"
  - "2200:22"
 external_links:
  - mysql_local
 environment:
  - SFTPDEV_PASSWD=mysshpasswd
  - WEB_DOCUMENTROOT=/var/www/html/deploy/current # default /var/www/html
  - STATIC_BY_NGINX=1 #static send nginx (default 0)
```
Add ssh key to file /srv/docker/docker-sitehosting/example.com/sftpdev-home/.ssh/authorized_keys and login remote by server ip and port 2200.

And after login:
```
sudo supervisorctl status
apache2                          RUNNING    pid 27, uptime 0:24:53
cron                             FATAL      Exited too quickly (process log may have details)
nginx                            RUNNING    pid 16, uptime 0:24:54
sshd                             RUNNING    pid 17, uptime 0:24:54
```

