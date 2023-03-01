#!/bin/bash

cat <<EOF
 _________________________________________________________________________________
|                                                                                 |
|   Welcome to the RustDesk configuration.                                        |
|                                                                                 |
|   In this process a RustDesk server will be set up                              |
|   accordingly together with all necessary dependencies.                         |
|   You only need to set your desired Domain to configure RustDesk                |
|                                                                                 |
|   ATTENTION: Please make sure your Domain exists first!                         |
|                                                                                 |
|   Please enter the Domain in following pattern: rustdesk.example.com            |
|_________________________________________________________________________________|
EOF

user_input(){

  while [ -z $domain ]
  do
    read -p "Your RustDesk Domain: " domain
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
docker compose -f /opt/containers/rustdesk/docker-compose.yml pull &>/dev/null &


echo -en "\n"
echo "Please enter your details to set up your RustDesk Instance."

user_input

while true
do
    echo -en "\n"
    read -p "Is the Domain correct? [Y/n] " confirm
    : ${confirm:="Y"}

    case $confirm in
      [yY][eE][sS]|[yY] ) sed -i "s/RUSTDESK_DOMAIN_DUMMY/${domain}/g" /opt/containers/rustdesk/.env; break;;
      [nN][oO]|[nN] ) unset domain; user_input;;
      * ) echo "Please type y or n.";;
    esac
done


echo "The installation is being performed. This can take some time..."
{
docker compose -f /opt/containers/rustdesk/docker-compose.yml up -d
} &> /dev/null & progress

echo -en "\n\n"
echo "The installation is complete and RustDesk should be running at your domain."
echo "--- ${domain} ---"
echo "ID Server: ${domain}:21116"
echo "Key: $(cat /opt/containers/rustdesk/data/id_ed25519.pub)"
echo -en "\n"

# Remove startup script from .bashrc
sed -i "/rustdesk/d" ~/.bashrc

# Remove startup scripts
rm -r /opt/hcloud
