#!/bin/sh

##
# Set better PHP defaults
sed -e "s|upload_max_filesize.*|upload_max_filesize = 50M|g" \
    -e "s|post_max_size.*|post_max_size = 50M|g" \
    -e "s|max_execution_time.*|max_execution_time = 60|g" \
    -i /etc/php/7.4/apache2/php.ini

# Set permissions for apache
chown -R www-data: /var/log/apache2
chown -R www-data: /etc/apache2
chown -R www-data: /var/www
