FROM debian:bullseye

ENV DEBIAN_FRONTEND noninteractive

ARG PHP_VERSION_MOLECULE=7.4
ARG PHP_VERSION=php${PHP_VERSION_MOLECULE}
ARG PHP_DIR=php/${PHP_VERSION_MOLECULE}

RUN \
    apt-get -y update ; \
    apt-get -y install \
      gnupg2 \
      nano \
      wget \
      unzip \
      mariadb-server \
      nginx \
      ssl-cert \
      php-pear \
      ${PHP_VERSION}-fpm \
      ${PHP_VERSION}-mysql \
      ${PHP_VERSION}-cgi \
      ${PHP_VERSION}-mbstring \
      ${PHP_VERSION}-gd \
      ${PHP_VERSION}-xsl \
      ${PHP_VERSION}-curl \
      ${PHP_VERSION}-intl \
      ${PHP_VERSION}-soap \
      ${PHP_VERSION}-zip \
      ${PHP_VERSION}-bz2 \
      ${PHP_VERSION}-sqlite3 \
      ${PHP_VERSION}-xml \
      ${PHP_VERSION}-xmlrpc

ADD default /etc/nginx/sites-available/

RUN \
    sed -i s/'max_execution_time = 30'/'max_execution_time = 3600'/ /etc/${PHP_DIR}/fpm/php.ini ; \
    sed -i s/'upload_max_filesize = 2M'/'upload_max_filesize = 1G'/ /etc/${PHP_DIR}/fpm/php.ini ; \
    sed -i s/'memory_limit = 128M'/'memory_limit = 256M'/ /etc/${PHP_DIR}/fpm/php.ini ; \
    sed -i s/'post_max_size = 8M'/'post_max_size = 1G'/ /etc/${PHP_DIR}/fpm/php.ini ; \
    sed -i s/';date.timezone ='/'date.timezone = Europe\/Paris'/ /etc/${PHP_DIR}/fpm/php.ini ; \
    sed -i s/';max_input_vars = 1000'/'max_input_vars = 100000'/ /etc/${PHP_DIR}/fpm/php.ini ; \
    sed -i s/'max_allowed_packet\t= 16M'/'max_allowed_packet\t= 1G'/ /etc/mysql/my.cnf ; \
    sed -i s/'index.nginx-debian.html'/'index.php'/ /etc/nginx/sites-available/default ; \
    sed -i s/'server_name _;'/"server_name _;\n\n\tlocation ~ \\.php$ {\n\t\tinclude snippets\/fastcgi-php.conf;\n\t\tfastcgi_pass unix:\/var\/run\/php\/php${PHP_VERSION_MOLECULE}-fpm.sock;\n\t}"/ /etc/nginx/sites-available/default

ADD index.html /var/www/html/

WORKDIR /var/www/html

RUN wget \
    https://forge.sigb.net/attachments/download/4131/pmb7.4.7.zip \
    ; \
    unzip pmb7*.zip ; rm pmb7*.zip ; chown -R www-data:www-data .

ADD entrypoint.sh /usr/local/bin/

EXPOSE 80

VOLUME ["/var/lib/mysql","/etc/pmb"]

CMD ["bash", "/usr/local/bin/entrypoint.sh"]
