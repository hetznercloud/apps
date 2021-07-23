#!/bin/bash
#
# This will enable Nextcloud, configure it with user input
# and optionally set up LE.
#
cat <<EOF
 _________________________________________________________________________
|                                                                         |
|   Welcome to the Nextcloud One-Click-App configuration.                 |
|                                                                         |
|   In this process Nextcloud will be set up accordingly.                 |
|   You only need to set your desired User, Domain and E-Mail.            |
|   The latter will be used to configure Apache and allow Let's           |
|   Encrypt to obtain a valid SSL Certificate.                            |
|   Please make sure your Domain exists first.                            |
|                                                                         |
|   Please enter the Domain in following pattern: nextcloud.example.com   |
|_________________________________________________________________________|
EOF

host_ip_address=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

user_input(){

  while [ -z $domain ]
  do
    read -p "Your Domain: " domain
  done

  while [ -z $email ]
  do
    read -p "Your Email Address (for Let's Encrypt Notifications): " email
  done

  while [ -z $username ]
  do
    read -p "Your Username [Default=admin]: " username
    : ${username:="admin"}
  done

  while true
  do
    read -s -p "Password: " password
    echo
    read -s -p "Password (again): " password2
    echo
    [ "$password" = "$password2" ] && break || echo "Please try again."
  done

}

certbot_crontab() {

echo -en "\n"
echo "Setting up Crontab for Let's Encrypt."
crontab -l > certbot
echo "30 2 * * 1 /usr/bin/certbot renew >> /var/log/le-renew.log" >> certbot
echo "35 2 * * 1 systemctl reload apache2" >> certbot
crontab certbot
rm certbot

}


echo -en "\n"
echo "Please enter your details to set up your new Nextcloud Instance."

user_input

while true
do
    echo -en "\n"
    read -p "Is everything correct? [Y/n] " confirm
    : ${confirm:="Y"}

    case $confirm in
      [yY][eE][sS]|[yY] ) break;;
      [nN][oO]|[nN] ) unset domain email username password; user_input;;
      * ) echo "Please type y or n.";;
    esac
done

sed -i "s/\$domain/$domain/g"  /etc/apache2/sites-enabled/000-default.conf


# Enable necessary Modules
{
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime
} &> /dev/null


echo -en "\n\n"
  echo -en "Do you want to create a Let's Encrypt Certificate for Domain $domain? \n"
  read -p "Note that the Domain needs to exist. [Y/n]: " le
  : ${le:="Y"}
    case $le in
        [Yy][eE][sS]|[yY] ) certbot --noninteractive --apache -d $domain --agree-tos --email $email --redirect; certbot_crontab;;
        [nN][oO]|[nN] ) echo -en "\nSkipping Let's Encrypt.\n";;
        * ) echo "Please type y or n.";;
    esac


# Move Nextcloud to its final path
if [[ -d /var/www/nextcloud ]]
then
  rm -rf /var/www/html
  mv /var/www/nextcloud /var/www/html
fi
chown -Rf www-data:www-data /var/www/html


# Wait for Nextcloud to be installed
if [ -f "/var/www/html/config/CAN_INSTALL" ]
then
  echo -en "\n"
  echo "The Application is being prepared ..."

  source ~/.hcloud_password
  sudo -u www-data php /var/www/html/occ maintenance:install \
    --database "mysql" --database-name "nextcloud" --database-user "nextcloud" \
    --database-pass "$nextcloud_mysql_pass" --admin-user "$username" \
    --admin-pass "$password" --data-dir "/var/www/html/data"

  { # Set Nextcloud parameters via occ
  sudo -u www-data php /var/www/html/occ config:system:set trusted_domains 0 --value=$host_ip_address
  sudo -u www-data php /var/www/html/occ config:system:set trusted_domains 1 --value=$domain
  sudo -u www-data php /var/www/html/occ config:system:set overwrite.cli.url --value=https://$domain/
  sudo -u www-data php /var/www/html/occ config:system:set htaccess.RewriteBase --value=/
  sudo -u www-data php /var/www/html/occ maintenance:update:htaccess
  } &> /dev/null

  rm /var/www/html/config/CAN_INSTALL
  systemctl restart apache2
fi


echo -en "\n\n"
echo "The installation is complete and Nextcloud should be running at your Domain."
echo "--- $domain ---"
echo -en "\n"


# Remove startup script from .bashrc
sed -i "/nextcloud_setup/d" ~/.bashrc
