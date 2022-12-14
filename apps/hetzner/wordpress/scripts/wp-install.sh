#!/bin/sh
set -e

##
# Set better PHP defaults
sed -e "s|upload_max_filesize.*|upload_max_filesize = 50M|g" \
    -e "s|post_max_size.*|post_max_size = 50M|g" \
    -e "s|max_execution_time.*|max_execution_time = 60|g" \
    -i /etc/php/8.1/apache2/php.ini

# Download given WordPress version and check sha256 checksum
wget "https://wordpress.org/wordpress-${application_version}.tar.gz" -O /tmp/wordpress.tar.gz

echo "${application_checksum} /tmp/wordpress.tar.gz" | sha1sum -c

##
# Extract WordPress and set apache2 permissions

mkdir -p /var/www
tar -C /var/www -xvvf /tmp/wordpress.tar.gz

chown -R www-data: /var/log/apache2
chown -R www-data: /etc/apache2
chown -R www-data: /var/www
