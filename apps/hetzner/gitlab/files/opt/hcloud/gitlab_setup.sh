#!/bin/bash
#
# This will enable GitLab, configure it with user input
# and optionally set up LE.
#
cat <<EOF
 ______________________________________________________________________
|                                                                      |
|   Welcome to the GitLab One-Click-App configuration.                 |
|                                                                      |
|   In this process GitLab will be set up accordingly.                 |
|   You only need to set your desired Domain which will be used        |
|   to configure Gitlab and allow Let's Encrypt to obtain a            |
|   valid SSL Certificate.                                             |
|   Please make sure your Domain exists first.                         |
|                                                                      |
|   Please enter the Domain in following pattern: gitlab.example.com   |
|______________________________________________________________________|
EOF

user_input(){

  while [ -z $domain ]
  do
    read -p "Your Domain: " domain
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

echo -en "\n"
echo "Please enter your details to set up your new GitLab Instance."

user_input

while true
do
    echo -en "\n"
    read -p "Is the Domain correct? [Y/n] " confirm
    : ${confirm:="Y"}

    case $confirm in
      [yY][eE][sS]|[yY] ) break;;
      [nN][oO]|[nN] ) unset domain; user_input;;
      * ) echo "Please type y or n.";;
    esac
done


echo -en "\n\n"
  echo -en "Do you want to create a Let's Encrypt Certificate for Domain $domain? \n"
  read -p "Note that the Domain needs to exist. [Y/n]: " le
  : ${le:="Y"}
    case $le in
        [Yy][eE][sS]|[yY] ) sed -i "s/\$domain/https:\/\/$domain/g"  /etc/gitlab/gitlab.rb;;
        [nN][oO]|[nN] ) sed -i "s/\$domain/http:\/\/$domain/g"  /etc/gitlab/gitlab.rb; echo -en "\nSkipping Let's Encrypt.\n";;
        * ) echo "Please type y or n.";;
    esac


echo -en "\n\n"
echo -en "The Hetzner Static Page will be removed &\n"
echo "GitLab is being installed. This can take some time..."
{

# Remove Apache and Static Page
if [[ -d /var/www/html ]]
then
  systemctl stop apache2
  systemctl disable apache2
  rm -rf /var/www/html
  apt purge -y apache2*
fi

# Reconfigure gitlab
gitlab-ctl reconfigure

} &> /var/log/hcloud-gitlab-setup.log & progress

source /root/.hcloud_password
echo -en "\n\n"
echo "The installation is complete and GitLab should be running at your Domain."
echo "--- $domain ---"
echo -en "\n"
echo "Please use the following user to log in to your new instance."
echo "User: root"
echo "Password: $gitlab_initial_pass"
echo -en "\n"


# Remove startup script from .bashrc
sed -i "/gitlab_setup/d" ~/.bashrc
