FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

ADD http://ftp.indexdata.dk/debian/indexdata.asc /root/

RUN echo deb http://ftp.indexdata.dk/debian jessie main >> /etc/apt/sources.list ; apt-key add /root/indexdata.asc ; apt-get -y update ; \
    apt-get -y install nginx php5-fpm php5-yaz php5-xsl php5-mysql php5-cgi php5-gd mariadb-server unzip

RUN sed -i s/'max_execution_time = 30'/'max_execution_time = 3600'/ /etc/php5/fpm/php.ini ; \
    sed -i s/'upload_max_filesize = 2M'/'upload_max_filesize = 1G'/ /etc/php5/fpm/php.ini ; \
    sed -i s/'max_allowed_packet\t= 16M'/'max_allowed_packet\t= 1G'/ /etc/mysql/my.cnf ; \
    sed -i s/'index.nginx-debian.html'/'index.php'/ /etc/nginx/sites-available/default ; \
    sed -i s/'server_name _;'/'server_name _;\n\n\tlocation ~ \\.php$ {\n\t\tinclude snippets\/fastcgi-php.conf;\n\t\tfastcgi_pass unix:\/var\/run\/php5-fpm.sock;\n\t}'/ /etc/nginx/sites-available/default

ADD index.html /var/www/html/

ADD http://forge.sigb.net/redmine/attachments/download/2019/pmb5.0.RC1.zip /var/www/html/

RUN cd /var/www/html/ ; unzip pmb5.0.RC1.zip ; rm pmb5.0.RC1.zip ; chown -R www-data:www-data .

ADD entrypoint.sh /usr/local/bin/

EXPOSE 80

VOLUME ["/var/lib/mysql","/etc/pmb"]

CMD ["/usr/local/bin/entrypoint.sh"]
