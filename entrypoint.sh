#!/bin/bash

service mysql start || initialiser_db
service php5-fpm start
nginx -g 'daemon off;'

function initialiser_db {
	mysql_install_db
	service mysql start
	echo "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin'; GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;" | mysql -uroot
}
