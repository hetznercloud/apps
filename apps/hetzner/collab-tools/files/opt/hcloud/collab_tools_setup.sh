#!/bin/bash

cat <<EOF
 _____________________________________________________________________________
|                                                                             |
|   Welcome to the collab-tools configuration.                                |
|                                                                             |
|   In this process HedgeDoc, transfer.sh and Whiteboard will be set up       |
|   accordingly together with all necessary dependencies. You only need to    |
|   set your desired Domain which will be used to configure the reverse proxy |
|   and to obtain Let's Encrypt Certificates.                                 |
|                                                                             |
|   ATTENTION: Please make sure your Domain exists first!                     |
|                                                                             |
|   Please enter the Domain in following pattern: hedgedoc.example.com        |
|_____________________________________________________________________________|
EOF

user_input(){
  local service="$1"
  while [ -z ${domain} ]
  do
    echo "Note that the domain needs to exist."
    read -p "Your ${service} domain: " domain
  done
}

ask_domain(){
  local address=$1

  user_input "${address}"
  while true
  do
    echo -en "\n"
    read -p "Is the domain ${domain} correct? [Y/n] " confirm
    : ${confirm:="Y"}

    case $confirm in
      [yY][eE][sS]|[yY] ) sed -i "s/${address}_DOMAIN_DUMMY/${domain}/g" /opt/containers/collab-tools/.env; break;;
      [nN][oO]|[nN] ) unset domain; user_input ${address};;
      * ) echo "Please type y or n.";;
    esac
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

countdown(){
  count=0
  while [ $count -lt 16 ]; do
    count=$(( $count + 1 ))
    for X in '-' '/' '|' '\'
    do
      echo -en "\b$X"
      sleep 0.1
    done
  done
}

# already start to pull the docker images
docker pull lucaslorentz/caddy-docker-proxy:ci-alpine &>/dev/null &
docker compose -f /opt/containers/collab-tools/docker-compose.yml pull &>/dev/null &

echo -en "\n"
echo "Please enter your details to set up your new hedgedoc instance."

ask_domain "HEDGEDOC"
hedgedoc_domain="${domain}"; unset domain
hedgedoc_pass=$(openssl rand -hex 24)
echo -en "hedgedoc_default_user=docs@local.host\nhedgedoc_default_pass=${hedgedoc_pass}\n" >> /root/.hcloud_password

ask_domain "TRANSFER"
transfer_domain="${domain}"; unset domain
transfer_pass=$(openssl rand -hex 24)
echo -en "transfer_basic_auth_user=transfer\ntransfer_basic_auth_pass=${transfer_pass}\n" >> /root/.hcloud_password
transfer_pass_bcrypt=$(docker run lucaslorentz/caddy-docker-proxy:ci-alpine hash-password -plaintext $transfer_pass 2>/dev/null)
sed -i "s/TRANSFER_PASS_DUMMY/$transfer_pass_bcrypt/g"  /opt/containers/collab-tools/.env

ask_domain "WHITEBOARD"
whiteboard_domain="${domain}"; unset domain
whiteboard_pass=$(openssl rand -hex 24)
echo -en "whiteboard_basic_auth_user=whiteboard\nwhiteboard_basic_auth_pass=${whiteboard_pass}\n" >> /root/.hcloud_password
whiteboard_pass_bcrypt=$(docker run lucaslorentz/caddy-docker-proxy:ci-alpine hash-password -plaintext $whiteboard_pass 2>/dev/null)
sed -i "s/WHITEBOARD_PASS_DUMMY/$whiteboard_pass_bcrypt/g"  /opt/containers/collab-tools/.env

echo "The installation is being performed. This can take some time..."
{
docker compose -f /opt/containers/collab-tools/docker-compose.yml up -d
} &> /dev/null & progress

countdown

# wait until the setup is up before injecting the user
docker compose -f /opt/containers/collab-tools/docker-compose.yml exec hedgedoc bin/manage_users --add docs@local.host --pass $hedgedoc_pass &> /dev/null

source /root/.hcloud_password
echo -en "\n\n"
echo "The installation is complete and Hedgedoc, Transfer and Whiteboard should be running at your domain."
echo "--- ${hedgedoc_domain} ---"
echo "User: docs@local.host"
echo "Pass: ${hedgedoc_pass}"
echo -en "\n"
echo "You can add/remove users with the  'hedgedoc_users' command"
echo -en "\n"
echo "--- ${transfer_domain} ---"
echo "Please use the following details for http basic auth."
echo "User: transfer"
echo "Pass: ${transfer_pass}"
echo -en "\n"
echo "--- ${whiteboard_domain} ---"
echo "Please use the following details for http basic auth."
echo "User: whiteboard"
echo "Pass: ${whiteboard_pass}"
echo -en "\n"

# Remove startup script from .bashrc
sed -i "/collab_tools/d" ~/.bashrc

# Remove startup scripts
rm -r /opt/hcloud
