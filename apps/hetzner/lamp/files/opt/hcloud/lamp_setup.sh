#!/bin/bash
#
# This will enable LAMP, configure it with user input
# and optionally set up LE.
#
cat <<EOF
 ____________________________________________________________________
|                                                                    |
|   Welcome to the LAMP One-Click-App configuration.                 |
|                                                                    |
|   In this process LAMP (specifically Apache) will be set up        |
|   accordingly. You only need to set your desired Domain and        |
|   E-Mail which will be used to configure Apache and allow Let's    |
|   Encrypt to obtain a valid SSL Certificate.                       |
|   Please make sure your Domain exists first.                       |
|                                                                    |
|   Please enter the Domain in following pattern: your.example.com   |
|____________________________________________________________________|
EOF


user_input(){

  while [ -z $domain ]
  do
    read -p "Your Domain: " domain
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
echo "Please enter your details to set up your new Apache Instance."

user_input

while true
do
    echo -en "\n"
    read -p "Is the everything correct? [Y/n] " confirm
    : ${confirm:="Y"}

    case $confirm in
      [yY][eE][sS]|[yY] ) break;;
      [nN][oO]|[nN] ) unset domain; user_input;;
      * ) echo "Please type y or n.";;
    esac
done


# create webserver folder and remove static page
mkdir /var/www/$domain
rm -rf /var/www/html

cat > /var/www/$domain/index.php <<EOF
<?php
echo "Hello World";
?>
EOF

# set domain_is_www variable
if [[ $domain == "www."* ]]; then domain_is_www=true; else domain_is_www=false; fi

sed -i "s/\$domain/$domain/g"  /etc/apache2/sites-available/000-default.conf
sed -i "s/html/$domain/g"  /etc/apache2/sites-available/000-default.conf

chown -R www-data: /var/www/$domain/

systemctl restart apache2


# Enable necessary Modules
{
a2enconf block-xmlrpc
a2enmod dir
a2enmod rewrite
a2enmod ssl
} &> /dev/null


echo -en "\n\n"
  echo -en "Do you want to create a Let's Encrypt Certificate for Domain $domain? \n"
  read -p "Note that the Domain needs to exist. [Y/n]: " le
  : ${le:="Y"}
    case $le in
        [Yy][eE][sS]|[yY] )
          while true
          do
            read -p "Your Email Address (for Let's Encrypt Notifications): " email
            if grep -oP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$' <<<"${email}" >/dev/null 2>&1; then
              break
            else
              echo "Please enter a valid E-Mail."
            fi
          done
          if [[ $domain_is_www = true ]]; then
            certbot --noninteractive --apache -d $domain --agree-tos --email $email --no-redirect
          elif [[ $domain_is_www = false ]]; then
            certbot --noninteractive --apache -d $domain --agree-tos --email $email --redirect
          fi
          domain_use_https=true
          certbot_crontab;;
        [nN][oO]|[nN] ) echo -en "\nSkipping Let's Encrypt.\n"; domain_use_https=false;;
        * ) echo "Please type y or n.";;
    esac


# set redirects for www domain
if [[ $domain_is_www = true ]] && [[ $domain_use_https = true ]]; then
    cat << EOF >> /var/www/$domain/.htaccess
  RewriteEngine on
  RewriteCond %{HTTPS} off [OR]
  RewriteCond %{HTTP_HOST} !^www\. [NC]
  RewriteRule (.*) https://$domain%{REQUEST_URI} [R=301,L]
EOF
elif [[ $domain_is_www = true ]] && [[ $domain_use_https = false ]]; then
    cat << EOF >> /var/www/$domain/.htaccess
  RewriteEngine on
  RewriteCond %{HTTP_HOST} !^www\. [NC]
  RewriteRule (.*) http://$domain%{REQUEST_URI} [R=301,L]
EOF
fi
systemctl restart apache2


echo -en "\n\n"
echo "The installation is complete and Apache should be running at your Domain."
echo "--- $domain ---"
echo -en "\n"


# Remove startup script from .bashrc
sed -i "/lamp_setup/d" ~/.bashrc
