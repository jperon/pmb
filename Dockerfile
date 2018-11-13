FROM debian

ENV DEBIAN_FRONTEND noninteractive

ADD http://ftp.indexdata.dk/debian/indexdata2.asc /root/

RUN apt-get -y update ; apt-get -y install gnupg ; \
    echo deb http://ftp.indexdata.dk/debian stretch main >> /etc/apt/sources.list; \
    apt-key add /root/indexdata2.asc ; apt-get -y update ; \
    apt-get -y --allow-unauthenticated install nginx \
    php7.0-fpm php7.0-yaz php7.0-xsl php7.0-mysql php7.0-cgi php7.0-gd php7.0-curl \
    mariadb-server wget

RUN sed -i s/'max_execution_time = 30'/'max_execution_time = 3600'/ /etc/php/7.0/fpm/php.ini ; \
    sed -i s/'upload_max_filesize = 2M'/'upload_max_filesize = 1G'/ /etc/php/7.0/fpm/php.ini ; \
    sed -i s/'max_allowed_packet\t= 16M'/'max_allowed_packet\t= 1G'/ /etc/mysql/my.cnf ; \
    sed -i s/'index.nginx-debian.html'/'index.php'/ /etc/nginx/sites-available/default ; \
    sed -i s/'server_name _;'/'server_name _;\n\n\tlocation ~ \\.php$ {\n\t\tinclude snippets\/fastcgi-php.conf;\n\t\tfastcgi_pass unix:\/var\/run\/php\/php7.0-fpm.sock;\n\t}'/ /etc/nginx/sites-available/default

ADD index.html /var/www/html/

RUN cd /var/www/html/ ; \
    wget http://forge.sigb.net/redmine/attachments/download/$(\
         wget -O- http://forge.sigb.net/redmine/projects/pmb/files \
             | grep attachments/download | cut -d'/' -f 5- \
             | sort -h | tail -1 | cut -d'"' -f1 \
    ) ; \
    tar xaf pmb*.tgz ; rm pmb*.tgz ; chown -R www-data:www-data .

ADD entrypoint.sh /usr/local/bin/

EXPOSE 80

VOLUME ["/var/lib/mysql","/etc/pmb"]

CMD ["/usr/local/bin/entrypoint.sh"]
