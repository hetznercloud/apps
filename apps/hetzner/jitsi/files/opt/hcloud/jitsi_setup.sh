#!/bin/bash
#
# This will enable Jitsi, configure it with user input
# and optionally set up LE.
#
cat <<EOF
 _______________________________________________________________________
|                                                                       |
|   Welcome to the Jitsi One-Click-App configuration.                   |
|                                                                       |
|   In this process Jitsi will be set up accordingly.                   |
|   You only need to set your desired Domain and E-Mail which will be   |
|   used to configure Nginx and allow Let's Encrypt to obtain a         |
|   valid SSL Certificate.                                              |
|   Please make sure your Domain exists first.                          |
|                                                                       |
|   Please enter the Domain in following pattern: jitsi.example.com     |
|_______________________________________________________________________|
EOF

host_ip_address=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
hostname=$(hostname)

user_input(){

  while [ -z $domain ]
  do
    read -p "Your Domain: " domain
  done

  while [ -z $email ]
  do
    read -p "Your Email Address (for Let's Encrypt Notifications): " email
  done

}

remove_static_page(){

  if [[ -d "/var/www/html" ]]
    then
      rm -rf /var/www/html
      rm /etc/nginx/sites-available/hetzner
  fi

}

certbot_crontab() {

echo -en "\n"
echo "Setting up Crontab for Let's Encrypt."
crontab -l > certbot
echo "30 2 * * 1 /usr/bin/certbot renew >> /var/log/le-renew.log" >> certbot
echo "35 2 * * 1 systemctl reload nginx" >> certbot
crontab certbot
rm certbot

}

jitsi_meet_debconf(){

  cat <<EOF | sudo debconf-set-selections
  jitsi-meet jitsi-meet/jvb-serve boolean false
  jitsi-meet-prosody jitsi-meet-prosody/jvb-hostname string $domain
  jitsi-videobridge jitsi-videobridge/jvb-hostname string $domain
  jitsi-meet jitsi-meet/cert-choice select "Generate a new self-signed certificate (You will later get a chance to obtain a Let's encrypt certificate)"
EOF

}

nginx_le_setup(){

  le_privkey="/etc/letsencrypt/live/$domain/privkey.pem"
  le_fullchain="/etc/letsencrypt/live/$domain/fullchain.pem"

  le_privkey_sed=$(echo $le_privkey | sed 's/\./\\\./g')
  le_privkey_sed=$(echo $le_privkey_sed | sed 's/\//\\\//g')

  sed -i "s/ssl_certificate_key\ \/etc\/jitsi\/meet\/.*key/ssl_certificate_key\ $le_privkey_sed/g" "/etc/nginx/sites-available/$domain.conf"

  le_fullchain_sed=$(echo $le_fullchain | sed 's/\./\\\./g')
  le_fullchain_sed=$(echo $le_fullchain_sed | sed 's/\//\\\//g')

  sed -i "s/ssl_certificate\ \/etc\/jitsi\/meet\/.*crt/ssl_certificate\ $le_fullchain_sed/g" "/etc/nginx/sites-available/$domain.conf"

  systemctl restart nginx

}


echo -en "\n"
echo "Please enter your details to set up your new Jitsi Instance."

user_input


while true
do
    echo -en "\n"
    read -p "Is everything correct? [Y/n] " confirm
    : ${confirm:="Y"}

    case $confirm in
      [yY][eE][sS]|[yY] ) break;;
      [nN][oO]|[nN] ) unset domain email; user_input;;
      * ) echo "Please type y or n.";;
    esac
done

# change /etc/hosts
sed -i "s/\$domain/$domain/g"  /etc/hosts
sed -i "s/\$host_ip_address/$host_ip_address/g"  /etc/hosts

# Set up cloud-init hosts template || temporare fix
sed -i "s/\$domain/$domain/g"  /etc/cloud/templates/hosts.debian.tmpl
sed -i "s/\$host_ip_address/$host_ip_address/g"  /etc/cloud/templates/hosts.debian.tmpl

# Install Jitsi-Meet with debconf
echo -en "\nJitsi-Meet is being installed. This can take some time..."
remove_static_page
jitsi_meet_debconf
apt-get update > /dev/null
apt-get install -y jitsi-meet > /dev/null
update-ca-certificates -f > /dev/null
systemctl restart prosody.service
systemctl restart jicofo.service
systemctl restart jitsi-videobridge2.service

echo -en "\n\n"
  echo -en "Do you want to create a Let's Encrypt Certificate for Domain $domain? \n"
  read -p "Note that the Domain needs to exist. [Y/n]: " le
  : ${le:="Y"}
    case $le in
        [Yy][eE][sS]|[yY] )
          certbot certonly --noninteractive --webroot --webroot-path /usr/share/jitsi-meet -d $domain --agree-tos --email $email
          nginx_le_setup
          certbot_crontab
          ;;
        [nN][oO]|[nN] )
          echo -en "\nSkipping Let's Encrypt."
          echo -en "\nYou can obtain a Let's Encrypt certificate anytime by running"
          echo -en "\n/usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh\n";;

        * )
          echo "Please type y or n.";;
    esac


echo -en "\n\n"
echo "The installation is complete and Jitsi should be running at your Domain."
echo "--- $domain ---"
echo -en "\n"


# Remove startup script from .bashrc
sed -i "/jitsi_setup/d" ~/.bashrc
