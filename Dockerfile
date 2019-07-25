FROM php:5.6-apache

LABEL maintainer="Marcos Paliari <marcos@paliari.com.br>"

COPY start.sh /start.sh

RUN apt-get update && apt-get -y install wget bsdtar libaio1 curl git zlib1g-dev libzip-dev \
  && wget -qO- https://github.com/paliari/docker-php7-apache/raw/master/oracle/instantclient-basic-linux.x64-12.2.0.1.0.zip | bsdtar -xvf- -C /usr/local \
  && wget -qO- https://github.com/paliari/docker-php7-apache/raw/master/oracle/instantclient-sdk-linux.x64-12.2.0.1.0.zip | bsdtar -xvf- -C /usr/local \
  && wget -qO- https://github.com/paliari/docker-php7-apache/raw/master/oracle/instantclient-sqlplus-linux.x64-12.2.0.1.0.zip | bsdtar -xvf- -C /usr/local \
  && ln -s /usr/local/instantclient_12_2 /usr/local/instantclient \
  && ln -s /usr/local/instantclient/libclntsh.so.* /usr/local/instantclient/libclntsh.so \
  && ln -s /usr/local/instantclient/lib* /usr/lib \
  && ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus \
  && docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient \
  && docker-php-ext-install oci8 \
  && docker-php-ext-install pdo_mysql exif opcache \
  && apt-get install -y libicu-dev libaio-dev libxml2-dev libjpeg-dev libpng-dev libfreetype6-dev \
  && docker-php-ext-install intl soap dom \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd \
  && docker-php-ext-install zip \
  && apt-get install -y imagemagick \
  && apt-get purge -y --auto-remove \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /etc/apache2/ssl \
  && mkdir -p /var/www/html/public \
  && chmod +x /start.sh \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD ssl/* /etc/apache2/ssl/
COPY apache/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY apache/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY apache/charset.conf /etc/apache2/conf-available/charset.conf
COPY php/vars.ini /usr/local/etc/php/conf.d/vars.ini
COPY php/timezone.ini /usr/local/etc/php/conf.d/timezone.ini
COPY src/index.php /var/www/html/public/index.php

RUN a2enmod ssl headers rewrite \
  && a2ensite default-ssl

EXPOSE 443

WORKDIR /var/www/html

ENTRYPOINT ["docker-php-entrypoint"]

CMD ["/start.sh"]
