#!/bin/bash
#
# This will enable WordPress, configure it with user input
# and optionally set up LE.
#
cat <<EOF
 ____________________________________________________________________
|                                                                    |
|   Welcome to the Wordpress One-Click-App configuration.            |
|                                                                    |
|   In this process Wordpress will be set up accordingly.            |
|   You only need to set your desired Domain and a few Wordpress     |
|   details. You can also decide if Let's Encrypt should obtain      |
|   a valid SSL Certificate.                                         |
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

  while true
  do
    read -p "Your Email Address (for Wordpress Account): " email
    if grep -oP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,24}$' <<<"${email}" >/dev/null 2>&1; then
      break
    else
      echo "Please enter a valid E-Mail."
    fi
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
    [ "$password" = "$password2" ] && break || echo "Please try again"
  done

  read -p "Wordpress Title: " title

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
echo "Please enter your details to set up your new Wordpress Instance."

user_input


while true
do
    echo -en "\n"
    read -p "Is everything correct? [Y/n] " confirm
    : ${confirm:="Y"}

    case $confirm in
      [yY][eE][sS]|[yY] ) break;;
      [nN][oO]|[nN] ) unset domain email username password title; user_input;;
      * ) echo "Please type y or n.";;
    esac
done


# set domain_is_www variable
if [[ $domain == "www."* ]]; then domain_is_www=true; else domain_is_www=false; fi

sed -i "s/\$domain/$domain/g"  /etc/apache2/sites-enabled/000-default.conf


# create webserver folder and remove static page
if [[ -d /var/www/wordpress ]]
then
  rm -rf /var/www/html
  mv /var/www/wordpress /var/www/html
  chown -Rf www-data:www-data /var/www/html
  systemctl restart apache2
fi


# Enable necessary Modules
{
a2enconf block-xmlrpc
a2enmod dir
a2enmod rewrite
a2enmod socache_shmcb
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
            read -p "Your Email Address (for Let's Encrypt Notifications): " le_email
            if grep -oP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$' <<<"${le_email}" >/dev/null 2>&1; then
              break
            else
              echo "Please enter a valid E-Mail."
            fi
          done
          if [[ $domain_is_www = true ]]; then
            certbot --noninteractive --apache -d $domain --agree-tos --email $le_email --no-redirect
          elif [[ $domain_is_www = false ]]; then
            certbot --noninteractive --apache -d $domain --agree-tos --email $le_email --redirect
          fi
          domain_use_https=true
          certbot_crontab;;
        [nN][oO]|[nN] ) echo -en "\nSkipping Let's Encrypt.\n"; domain_use_https=false;;
        * ) echo "Please type y or n.";;
    esac


# set redirects for www domain
if [[ $domain_is_www = true ]] && [[ $domain_use_https = true ]]; then
    cat << EOF >> /var/www/html/.htaccess
  RewriteEngine on
  RewriteCond %{HTTPS} off [OR]
  RewriteCond %{HTTP_HOST} !^www\. [NC]
  RewriteRule (.*) https://$domain%{REQUEST_URI} [R=301,L]
EOF
elif [[ $domain_is_www = true ]] && [[ $domain_use_https = false ]]; then
    cat << EOF >> /var/www/html/.htaccess
  RewriteEngine on
  RewriteCond %{HTTP_HOST} !^www\. [NC]
  RewriteRule (.*) http://$domain%{REQUEST_URI} [R=301,L]
EOF
fi
systemctl restart apache2


# install wp cli and configure WP
{
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/bin/wp
chmod +x /usr/bin/wp

wp core install --allow-root --path="/var/www/html" --title="$title" --url="$domain" --admin_email="$email"  --admin_password="$password" --admin_user="$username"

chown -Rf www-data.www-data /var/www/
cp /etc/skel/.bashrc /root
} &> /dev/null


echo -en "\n\n"
echo "The installation is complete and Wordpress should be running at your Domain."
echo "--- $domain ---"
echo -en "\n"
echo "The Admin Panel can be accessed via"
echo "--- $domain/wp-admin ---"
echo -en "\n"


# Remove startup script from .bashrc
sed -i "/wordpress_setup/d" ~/.bashrc
