#!/bin/bash

cat <<EOF
 _________________________________________________________________________________
|                                                                                 |
|   Welcome to the Photoprism configuration.                                      |
|                                                                                 |
|   In this process a Traefik, Photoprism, MariaDB and Watchtower will be set up  |
|   accordingly together with all necessary dependencies. You only need to        |
|   set your desired Domain and Email which will be used to configure             |
|   the reverse proxy and to obtain Let's Encrypt Certificates.                   |
|                                                                                 |
|   ATTENTION: Please make sure your Domain exists first!                         |
|                                                                                 |
|   Please enter the Domain in following pattern: photoprism.example.com          |
|_________________________________________________________________________________|
EOF

user_input(){

  while [ -z $domain ]
  do
    read -p "Your Photoprism Domain: " domain
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
docker compose -f /opt/containers/photoprism/docker-compose.yml pull &>/dev/null &


echo -en "\n"
echo "Please enter your details to set up your Photoprism Instance."

user_input

while true
do
    echo -en "\n"
    read -p "Is the Domain correct? [Y/n] " confirm
    : ${confirm:="Y"}

    case $confirm in
      [yY][eE][sS]|[yY] ) sed -i "s/PHOTOPRISM_DOMAIN_DUMMY/${domain}/g" /opt/containers/photoprism/.env; break;;
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
      [yY][eE][sS]|[yY] ) sed -i "s/LETSENCRYPT_MAIL_DUMMY/${email}/g" /opt/containers/photoprism/.env; break;;
      [nN][oO]|[nN] ) unset email; user_input;;
      * ) echo "Please type y or n.";;
    esac
done


# Generate passwords
photoprism_password=$(openssl rand -hex 32)
mariadb_password=$(openssl rand -hex 32)
mariadb_root_password=$(openssl rand -hex 32)


# Save the passwords
cat > /root/.hcloud_password <<EOM
photoprism_password="${photoprism_password}"
mariadb_password="${mariadb_password}"
mariadb_root_password="${mariadb_root_password}"
EOM

sed -i "s/PHOTOPRISM_PASSWORD_DUMMY/$photoprism_password/g"  /opt/containers/photoprism/.env
sed -i "s/MARIADB_PASSWORD_DUMMY/$mariadb_password/g"  /opt/containers/photoprism/.env
sed -i "s/MARIADB_ROOT_PASSWORD_DUMMY/$mariadb_root_password/g"  /opt/containers/photoprism/.env


echo "The installation is being performed. This can take some time..."
{
docker compose -f /opt/containers/photoprism/docker-compose.yml up -d
} &> /dev/null & progress

echo -en "\n\n"
echo "The installation is complete and photoprism should be running at your domain."
echo "Your credentials were saved to /root/.hcloud_password"
echo "--- https://${domain} ---"
echo "User: photo_admin"
echo "Pass: ${photoprism_password}"
echo -en "\n"

# Remove startup script from .bashrc
sed -i "/photoprism/d" ~/.bashrc

# Remove startup scripts
rm -r /opt/hcloud
