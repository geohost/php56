FROM ubuntu:18.04
LABEL maintainer="George Draghici <george@geohost.ro>"

# Setting frontend Noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Install supervisor, mysql-client, php-fpm, composer
RUN apt-get update ; \
    apt-get install -y \
    software-properties-common

RUN add-apt-repository ppa:ondrej/php

RUN apt-get update ; \
    apt-get install -y \
    apt-utils \
    wget \
    nano \
    curl \
    unzip \
    php5.6-redis \
    php5.6-cli \
    php5.6-fpm \
    php5.6-bz2 \
    php5.6-bcmath \
    php5.6-curl \
    php5.6-gd \
    php5.6-json \
    php5.6-mbstring \
    php5.6-mcrypt \
    php5.6-xml \
    php5.6-xmlrpc \
    php5.6-zip \
    php5.6-opcache \
    php5.6-cgi \
    php5.6-xml \
    php5.6-mysql \
    php5.6-sqlite3 \
    php5.6-imagick \
    libmysqlclient-dev \
    mysql-client \
    imagemagick \
    mailutils \
    net-tools \
    supervisor

# Install PHP ionCube module
ADD modules/ioncube_loader_lin_5.6.so /usr/lib/php/20131226/
#RUN apt install php-dev libmcrypt-dev gcc make autoconf libc-dev pkg-config -y
#RUN yes "" | pecl install mcrypt-1.0.1
#RUN echo "extension=mcrypt.so" | tee -a /etc/php/7.0/fpm/conf.d/mcrypt.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Copy php.ini file
ADD conf/php/php.ini /etc/php/5.6/fpm/php.ini
RUN mkdir -p /var/log/php
RUN touch /var/log/php/php-error.log && chown -R www-data:www-data /var/log/php
RUN mkdir -p /run/php/

#Create docroot directory , copy code and Grant Permission to docroot
RUN mkdir -p /app
RUN chown -R www-data:www-data /app

ADD conf/php/www.conf /etc/php/5.6/fpm/pool.d/www.conf
ADD conf/supervisord.conf /etc/supervisor/supervisord.conf


# Enable www-data user shell
RUN chsh -s /bin/bash www-data

EXPOSE 9000

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

CMD ["/docker-entrypoint.sh"]
