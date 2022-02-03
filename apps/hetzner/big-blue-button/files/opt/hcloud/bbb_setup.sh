#!/bin/bash
#
# This will enable BigBlueButton, configure it with user input
# and optionally set up LE.
#
cat <<EOF
 _____________________________________________________________________
|                                                                     |
|   Welcome to the BigBlueButton One-Click-App configuration.         |
|                                                                     |
|   In this process BigBlueButton will be set up accordingly.         |
|   You only need to set your desired Domain, E-Mail and User which   |
|   will be used to configure Nginx, Greenlight and allow Let's       |
|   Encrypt to obtain a valid SSL Certificate.                        |
|   Please make sure your Domain exists first.                        |
|                                                                     |
|   Please enter the Domain in following pattern: bbb.example.com     |
|_____________________________________________________________________|
EOF

host_ip_address=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
hostname=$(hostname)

user_input(){

  while true
  do
    read -p "Your Domain: " domain
    if grep -oP '(?=^.{4,253}$)(^(?:[a-zA-Z0-9](?:(?:[a-zA-Z0-9\-]){0,61}[a-zA-Z0-9])?\.)+([a-zA-Z]{2,}|xn--[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])$)' <<<"${domain}" >/dev/null 2>&1; then
      break
    else
      echo "Please enter a valid FQDN."
    fi
  done

  while [ -z $username ]
  do
    read -p "Your BBB Admin Username [Default: admin]: " username
    : ${username:="admin"}
  done

  while true
  do
    read -p "Your BBB Admin EMail Address: " email
    if grep -oP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$' <<<"${email}" >/dev/null 2>&1; then
      break
    else
      echo "Please enter a valid E-Mail."
    fi
  done

  while true
  do
    read -s -p "Your BBB Admin Password [8-32 characters, A-Z, a-z, 0-9, #?!@$%^&*-]: " password
    echo
    read -s -p "Your BBB Admin Password (again): " password2
    echo
    if [ "$password" = "$password2" ]; then
      if grep -oP '^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])[^.(){}[\]:;<>,.\/~_+=|]{8,32}$' <<<"${password}" >/dev/null 2>&1; then
        break
      else
        echo "Password invalid."
      fi
    else
      echo "Passwords don't match."
    fi
  done

}

# Remove Hetzner static page
remove_static_page(){

  rm -rf /var/www/html
  rm /etc/nginx/sites-enabled/default
  rm /etc/nginx/sites-enabled/hetzner
  rm /etc/nginx/sites-available/hetzner
  ln -s /etc/nginx/sites-available/bigbluebutton /etc/nginx/sites-enabled/bigbluebutton

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

selfsigned_cert(){

  echo -en "\n"
  echo "Generating selfsigned certificate."

  organization=localdomain
  organizationalunit=bbb-test
  cert_email=$email
  commonname=$domain

  openssl rand -writerand /root/.rnd
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/bbb-selfsigned.key -out /etc/ssl/certs/bbb-selfsigned.crt -subj "/O=$organization/OU=$organizationalunit/CN=$domain/emailAddress=$cert_email"

  openssl dhparam -dsaparam -out /etc/ssl/private/dhparam.pem 4096

  sed -i "s/\$selfsigned_ssl_certificate/\/etc\/ssl\/certs\/bbb-selfsigned.crt/g"  /etc/nginx/sites-available/bigbluebutton
  sed -i "s/\$selfsigned_key_certificate/\/etc\/ssl\/private\/bbb-selfsigned.key/g"  /etc/nginx/sites-available/bigbluebutton

}

configure_html5() {
# https://github.com/bigbluebutton/bbb-install/blob/master/bbb-install.sh

  sed -i "s/^attendeesJoinViaHTML5Client=.*/attendeesJoinViaHTML5Client=true/"  /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
  sed -i "s/^moderatorsJoinViaHTML5Client=.*/moderatorsJoinViaHTML5Client=true/"  /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
  sed -i "s/swfSlidesRequired=true/swfSlidesRequired=false/g"  /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

}

install_greenlight() {
# https://github.com/bigbluebutton/bbb-install/blob/master/bbb-install.sh

  echo -en "\n"
  echo "Setting up Greenlight Frontend.."
  echo -en "\n"

  source /root/.hcloud_password

  bbb_security_salt=$(cat /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties /etc/bigbluebutton/bbb-web.properties | grep -v '#' | grep ^securitySalt | tail -n 1  | cut -d= -f2)
  greenlight_rake_secret=$(docker run --rm bigbluebutton/greenlight:v2 bundle exec rake secret)

  sed -i "s|SECRET_KEY_BASE=.*|SECRET_KEY_BASE=$greenlight_rake_secret|"  /root/greenlight/.env
  sed -i "s|.*BIGBLUEBUTTON_ENDPOINT=.*|BIGBLUEBUTTON_ENDPOINT=https:\/\/$domain\/bigbluebutton\/|"  /root/greenlight/.env
  sed -i "s|.*BIGBLUEBUTTON_SECRET=.*|BIGBLUEBUTTON_SECRET=$bbb_security_salt|"  /root/greenlight/.env
  sed -i "s|SAFE_HOSTS=.*|SAFE_HOSTS=$domain|"  /root/greenlight/.env

  systemctl restart nginx

  sed -i "s/POSTGRES_PASSWORD=password/POSTGRES_PASSWORD=$greenlight_postgres_pass/g" /root/greenlight/docker-compose.yml
  sed -i "s/DB_PASSWORD=password/DB_PASSWORD=$greenlight_postgres_pass/g" /root/greenlight/.env

  # Check if greenlight already exists and
  if [[ $(docker network ls | grep greenlight) ]] || [[ $(docker container ls | grep greenlight) ]]
  then
    docker-compose -f /root/greenlight/docker-compose.yml down
  fi

  docker-compose -f /root/greenlight/docker-compose.yml up -d

}

echo -en "\n"
echo "Please enter your details to set up your new BigBlueButton Instance."

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


# populate nginx with domain
sed -i "s/\$domain/$domain/g"  /etc/nginx/sites-available/bigbluebutton

# change serverURL in bigbluebutton.properties
sed -i 's/bigbluebutton.web.serverURL=.*/bigbluebutton.web.serverURL=https:\/\/$domain/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

# change /etc/hosts
sed -i "s/\$domain/$domain/g"  /etc/hosts
sed -i "s/\$host_ip_address/$host_ip_address/g"  /etc/hosts

# Set up cloud-init hosts template || temporare fix
sed -i "s/\$domain/$domain/g"  /etc/cloud/templates/hosts.debian.tmpl
sed -i "s/\$host_ip_address/$host_ip_address/g"  /etc/cloud/templates/hosts.debian.tmpl

# Setup
remove_static_page
selfsigned_cert
systemctl restart nginx

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
          certbot --noninteractive --nginx -d $domain --agree-tos --email $le_email --redirect
          certbot_crontab
          greenlight_use_selfsigned=false;;
        [nN][oO]|[nN] )
          echo -en "\nSkipping Let's Encrypt and using selfsigned Certificate.\n"
          greenlight_use_selfsigned=true;;
        * ) echo "Please type y or n.";;
    esac

echo -en "\n"
configure_html5
install_greenlight
echo -en "\n"
echo "Setting up user and assigning domain to BigBlueButton."
echo -en "\n"
sleep 20

# Update CA for selfsigned
if $greenlight_use_selfsigned; then
  docker cp /etc/ssl/certs/bbb-selfsigned.crt greenlight-v2:/usr/local/share/ca-certificates/CA.crt
  docker exec greenlight-v2 update-ca-certificates
fi
echo -en "\n"
docker exec greenlight-v2 bundle exec rake user:create["$username","$email","$password","admin"]
echo -en "\n\n"
bbb-conf --setip "$domain"
sleep 20

echo -en "\n\n"
echo "The installation is complete and BigBlueButton should be running at your Domain."
echo "--- $domain ---"
echo -en "\n"


# Remove startup script from .bashrc
sed -i "/bbb_setup/d" /root/.bashrc
