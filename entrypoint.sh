#!/bin/bash

function initialiser_db {
	service mariadb stop
	mysql_install_db --user=mysql
	service mariadb start --character-set-server=utf8 --collation-server=utf8_unicode_ci --sql_mode=NO_AUTO_CREATE_USER --key_buffer_size=1000000000 --join_buffer_size=4000000
	echo "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin'; GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;" | mysql -uroot
}

function initialiser_parametres {
	mkdir /etc/pmb
	touch /etc/pmb/db_param.inc.php
	chown www-data:www-data /etc/pmb/db_param.inc.php
	ln -s /etc/pmb/db_param.inc.php /var/www/html/pmb/includes/db_param.inc.php
    ln -s /etc/pmb/db_param.inc.php /var/www/html/pmb/opac_css/includes/opac_db_param.inc.php
}

ls /var/www/html/pmb/includes/db_param.inc.php || initialiser_parametres
service mariadb start --character-set-server=utf8 --collation-server=utf8_unicode_ci --key_buffer_size=1000000000 --join_buffer_size=4000000 --sql_mode=NO_AUTO_CREATE_USER
echo '' | mysql -uadmin -padmin || initialiser_db
service php7.4-fpm start
nginx -g 'daemon off;'
