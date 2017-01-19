#!/bin/bash

function initialiser_db {
	mysql_install_db
	service mysql start
	echo "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin'; GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;" | mysql -uroot
}

ls /etc/pmb/db_param.inc.php || (mkdir /etc/pmb ; touch /etc/pmb/db_param.inc.php ; chown www-data:www-data /etc/pmb/db_param.inc.php ; ln -s /etc/pmb/db_param.inc.php /var/www/html/pmb/includes/db_param.inc.php)
service mysql start || initialiser_db
service php5-fpm start
nginx -g 'daemon off;'
