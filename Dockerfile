FROM php:5.3.29-apache
RUN apt-get update && \
apt-get install -y wget nginx supervisor libapache2-mod-rpaf sudo git mc net-tools openssh-server mysql-client vim nano msmtp \
	cron gcc make libjpeg-dev libpng-dev libtiff-dev libvpx-dev libxpm-dev libfontconfig1-dev libxpm-dev checkinstall \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libxml2 \
        libxml2-dev \
        libcurl4-openssl-dev \
        libpspell-dev \
        libtidy-dev \
	libgeoip-dev \
        libxslt1-dev \
	libicu-dev


RUN docker-php-ext-install bcmath ctype curl dom gettext hash iconv json mbstring mysqli mysql opcache posix pspell  session shmop simplexml  soap sockets \
	tidy tokenizer wddx iconv mcrypt \
	xsl zip \
	pdo pdo_mysql \ 
	xml  xmlrpc xmlwriter \
        exif intl 
RUN docker-php-ext-configure gd  --with-jpeg-dir --with-freetype-dir; \
    docker-php-ext-install gd

RUN pecl install geoip && echo "extension=geoip.so" >> /usr/local/etc/php/conf.d/geoip.ini \
	&&  pecl install memcache && echo "extension=memcache.so" >> /usr/local/etc/php/conf.d/memcache.ini


ADD apache-security.conf /etc/apache2/conf-enabled/security.conf 
RUN a2enmod rpaf rewrite headers

ADD supervisord.conf /etc/supervisor/

RUN /usr/bin/ssh-keygen -A

RUN useradd -d /home/sftpdev/ -s /bin/bash -o -g 33 -u 33 sftpdev; \
    usermod -d /home/sftpdev/ www-data && \
    echo "sftpdev ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers; \
    ln -s /var/www/html/ /home/sftpdev/ ; \
    echo "www-data ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /home/sftpdev/


RUN mkdir /var/run/sshd; chmod 0755 /var/run/sshd \
	&&  sed -i "s/Listen 80/Listen 81/g" /etc/apache2/ports.conf

RUN rm -rf /etc/apache2/sites-enabled/*
ADD apache-default-vhost.conf /etc/apache2/sites-enabled/
ADD nginx.conf /etc/nginx/

RUN echo "DOCKER PHP_VERSION=$PHP_VERSION; BUILD DATE: `date -I`" > /etc/motd


RUN echo 'sendmail_path = "/usr/bin/msmtp -C /var/www/.msmtprc  -t"' > /usr/local/etc/php/conf.d/sendmail-msmtp.ini

RUN sed -i '/session    required     pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/sshd 




ADD start.sh /
CMD ["/start.sh"]

