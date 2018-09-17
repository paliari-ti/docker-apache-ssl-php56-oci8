FROM ubuntu:16.04

LABEL Mantainer="Marcos Paliari <marcos@paliari.com.br>"
LABEL Description="A Simple apache-sll/php5.6/oci8 image using ubuntu:14.04"

RUN apt-get update && \
  apt-get install -y software-properties-common && \
  LANG=C.UTF-8 add-apt-repository ppa:ondrej/php -y && \
  apt-get update && \
  apt-get install -y \
  apache2 \
  php5.6 \
  php5.6-curl \
  php5.6-gd \
  php5.6-json \
  php5.6-mbstring \
  php5.6-mcrypt \
  php5.6-mysql \
  php5.6-soap \
  php5.6-zip \
  php5.6-xml \
  php5.6-sqlite3 \
  php5.6-dev \
  unzip \
  zip \
  libaio-dev \
  git \
  curl \
  wget \
  vim \
  cron \
  && apt-get clean -y && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && mkdir -p /etc/apache2/ssl \
  && rm -rf /var/lib/apt/lists/*

ADD ssl/* /etc/apache2/ssl/
COPY templates/apache_default.conf /etc/apache2/sites-available/000-default.conf
COPY templates/apache_default_ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY templates/php_default.ini /etc/php/5.6/apache2/php.ini
COPY templates/charset_apache_default.conf /etc/apache2/conf-available/charset.conf
COPY start.sh /usr/local/bin/start.sh
RUN sed -i "s#short_open_tag = Off#short_open_tag = On#" /etc/php/5.6/apache2/php.ini && \
  sed -i "s#display_errors = Off#display_errors = On#" /etc/php/5.6/apache2/php.ini && \
  sed -i "s#upload_max_filesize = 2M#upload_max_filesize = 50M#" /etc/php/5.6/apache2/php.ini && \
  sed -i "s#post_max_size = 8M#post_max_size = 50M#" /etc/php/5.6/apache2/php.ini && \
  sed -i "s#;date.timezone =#date.timezone = America/Sao_Paulo#" /etc/php/5.6/apache2/php.ini && \
  chmod +x /usr/local/bin/start.sh && \
  a2enmod ssl headers rewrite && \
  a2ensite default-ssl && \
  chown -R www-data:www-data /var/www/html

RUN wget -O /tmp/instantclient.x64-12.1.0.2.0.zip https://github.com/paliari-ti/docker-apache-ssl-php56-oci8/raw/master/instantclient.x64-12.1.0.2.0.zip && \
  unzip /tmp/instantclient.x64-12.1.0.2.0.zip -d /usr/local/ && \
  rm -f /tmp/instantclient.x64-12.1.0.2.0.zip && \
  ln -s /usr/local/instantclient_12_1 /usr/local/instantclient && \
  ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so && \
  ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus && \
  echo 'instantclient,/usr/local/instantclient' | pecl install oci8-2.0.10 && \
  echo "extension=oci8.so" > /etc/php/5.6/apache2/conf.d/30-oci8.ini && \
  echo "extension=oci8.so" > /etc/php/5.6/cli/conf.d/30-oci8.ini

EXPOSE 80
EXPOSE 443

WORKDIR /var/www/html
VOLUME ["/var/www/html"]

CMD ["/usr/local/bin/start.sh"]
