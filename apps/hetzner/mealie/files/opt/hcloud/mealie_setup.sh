#!/bin/bash

cat <<EOF
 _____________________________________________________________________________
|                                                                             |
|   Welcome to the Mealie configuration.                                      |
|                                                                             |
|   In this process a Traefik Proxy, Mealie and Watchtower will be set up     |
|   accordingly together with all necessary dependencies. You only need to    |
|   set your desired Domain and Email which will be used to configure         |
|   the reverse proxy and to obtain Let's Encrypt Certificates.               |
|                                                                             |
|   ATTENTION: Please make sure your Domain exists first!                     |
|                                                                             |
|   Please enter the Domain in following pattern: mealie.example.com          |
|_____________________________________________________________________________|
EOF

user_input(){

  while [ -z $domain ]
  do
    read -p "Your Mealie Domain: " domain
  done

  echo "Please enter an Email address for Let's Encrypt notifications:"
  while [ -z $email ]
  do
    read -p "Your Email address: " email
  done

  echo "Please enter the Email address for your Mealie superuser:"
  while [ -z $default_email ]
  do
    read -p "Your Superuser Email address: " default_email
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
docker compose -f /opt/containers/mealie/docker-compose.yml pull &>/dev/null &

echo -en "\n"
echo "Please enter your details to set up your Mealie Instance."

user_input

while true
do
    echo -en "\n"
    read -p "Is the Domain correct? [Y/n] " confirm
    : ${confirm:="Y"}

    case $confirm in
      [yY][eE][sS]|[yY] ) sed -i "s/MEALIE_DOMAIN_DUMMY/${domain}/g" /opt/containers/mealie/.env; break;;
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
      [yY][eE][sS]|[yY] ) sed -i "s/LETSENCRYPT_MAIL_DUMMY/${email}/g" /opt/containers/mealie/.env; break;;
      [nN][oO]|[nN] ) unset email; user_input;;
      * ) echo "Please type y or n.";;
    esac
done

while true
do
    echo -en "\n"
    read -p "Is the Superuser Email correct? [Y/n] " confirm
    : ${confirm:="Y"}

    case $confirm in
      [yY][eE][sS]|[yY] ) sed -i "s/MEALIE_DEFAULT_EMAIL_DUMMY/${default_email}/g" /opt/containers/mealie/.env; break;;
      [nN][oO]|[nN] ) unset default_email; user_input;;
      * ) echo "Please type y or n.";;
    esac
done
echo "The installation is being performed. This can take some time..."
{
docker compose -f /opt/containers/mealie/docker-compose.yml up -d
} &> /dev/null & progress

echo -en "\n\n"
echo "The installation is complete and Mealie should be running at your domain."
echo "Please change your password now"
echo "--- https://${domain} ---"
echo "User: ${default_email}"
echo "Pass: MyPassword"
echo -en "\n"

# Remove startup script from .bashrc
sed -i "/mealie/d" ~/.bashrc

# Remove startup scripts
rm -r /opt/hcloud
