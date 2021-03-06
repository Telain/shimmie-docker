FROM eboraas/debian:stable

ENV SHIMMIEDIR SHIMMIE

RUN echo deb http://ftp.uk.debian.org/debian jessie-backports main \
                  >>/etc/apt/sources.list

RUN apt-get update && apt-get -y \
    install \
	apache2 \
	php5 \
	php5-mysql \
	php5-pgsql \
	php5-sqlite \
	imagemagick \
	unzip \
	ffmpeg \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN /usr/sbin/a2ensite default-ssl
RUN /usr/sbin/a2enmod ssl
RUN /usr/sbin/a2dismod 'mpm_*' && /usr/sbin/a2enmod mpm_prefork

ADD https://raw.githubusercontent.com/Telain/shimmie-docker/master/php.ini /etc/php5/apache2/php.ini

CMD mkdir /var/www/html/$SHIMMIEDIR
ADD https://github.com/shish/shimmie2/archive/master.zip /var/www/html/shimmie2.zip
CMD unzip /var/www/html/shimmie2.zip -d /var/www/html/$SHIMMIEDIR
CMD rm /var/www/html/shimmie2.zip

VOLUME	["/var/www", "/var/log/apache2", "/etc/apache2"]

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

