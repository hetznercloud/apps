#!/bin/sh

##
# Set better PHP defaults
sed -e "s|upload_max_filesize.*|upload_max_filesize = 50M|g" \
    -e "s|post_max_size.*|post_max_size = 50M|g" \
    -e "s|max_execution_time.*|max_execution_time = 60|g" \
    -i /etc/php/7.4/apache2/php.ini

# Download given Nextcloud version
wget "https://download.nextcloud.com/server/releases/nextcloud-${application_version}.zip" -O /tmp/nextcloud.zip

##
# Extract Nextcloud and set apache2 permissions

mkdir -p /var/www
unzip /tmp/nextcloud.zip -d /var/www/

chown -R www-data: /var/log/apache2
chown -R www-data: /etc/apache2
chown -R www-data: /var/www
