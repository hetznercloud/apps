#!/bin/bash

cat <<EOF
 _____________________________________________________________________________
|                                                                             |
|   Welcome to the Owncast configuration.                                     |
|                                                                             |
|   In this process a Traefik Proxy, Owncast and Watchtower will be set up    |
|   accordingly together with all necessary dependencies. You only need to    |
|   set your desired Domain and Email which will be used to configure         |
|   the reverse proxy and to obtain Let's Encrypt Certificates.               |
|                                                                             |
|   ATTENTION: Please make sure your Domain exists first!                     |
|                                                                             |
|   Please enter the Domain in following pattern: owncast.example.com         |
|_____________________________________________________________________________|
EOF

user_input(){

  while [ -z $domain ]
  do
    read -p "Your Owncast Domain: " domain
  done

  echo "Please enter an Email address for Let's Encrypt notifications:"
  while [ -z $email ]
  do
    read -p "Your Email address: " email
  done
}

progress(){

  while [ "$(ps a | awk '{print $1}' | grep $!)" ]
  do
    for X in '-' '/' '|' '\'
      do
        echo -en "\b$X"
        sleep 0.1
      done
  done

}

# already start to pull the docker images
docker compose -f /opt/containers/owncast/docker-compose.yml pull &>/dev/null &

echo -en "\n"
echo "Please enter your details to set up your Owncast Instance."

user_input

while true
do
    echo -en "\n"
    read -p "Is the Domain correct? [Y/n] " confirm
    : ${confirm:="Y"}

    case $confirm in
      [yY][eE][sS]|[yY] ) sed -i "s/OWNCAST_DOMAIN_DUMMY/${domain}/g" /opt/containers/owncast/.env; break;;
      [nN][oO]|[nN] ) unset domain; user_input;;
      * ) echo "Please type y or n.";;
    esac
done

while true
do
    echo -en "\n"
    read -p "Is the Email correct? [Y/n] " confirm
    : ${confirm:="Y"}

    case $confirm in
      [yY][eE][sS]|[yY] ) sed -i "s/LETSENCRYPT_MAIL_DUMMY/${email}/g" /opt/containers/owncast/.env; break;;
      [nN][oO]|[nN] ) unset email; user_input;;
      * ) echo "Please type y or n.";;
    esac
done

echo "The installation is being performed. This can take some time..."
{
docker compose -f /opt/containers/owncast/docker-compose.yml up -d
} &> /dev/null & progress

echo -en "\n\n"
echo "The installation is complete and Owncast should be running at your domain."
echo "Please change your password as now"
echo "--- https://${domain} ---"
echo "User: admin"
echo "Pass: abc123"
echo -en "\n"

# Remove startup script from .bashrc
sed -i "/owncast/d" ~/.bashrc

# Remove startup scripts
rm -r /opt/hcloud
