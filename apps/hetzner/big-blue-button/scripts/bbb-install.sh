#!/bin/bash

# Add needed apt-repositories
add-apt-repository ppa:bigbluebutton/support -y
add-apt-repository ppa:rmescandon/yq -y
yes | add-apt-repository ppa:libreoffice/ppa

apt-get update && apt-get dist-upgrade -y


# install mongodb 4.2.13
echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg] https://repo.mongodb.org/apt/ubuntu \
    $(lsb_release -cs)/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list

cat <<EOT >> /etc/apt/preferences.d/mongodb-org.pref
Package: *
Pin: origin repo.mongodb.org
Pin-Priority: 1

Package: mongodb-org
Pin: origin repo.mongodb.org
Pin-Priority: 500
EOT

apt-get update && apt-get install -y mongodb-org


# install nodejs 12.22.1
curl -sL https://deb.nodesource.com/setup_12.x | bash -

cat <<EOT >> /etc/apt/preferences.d/nodejs.pref
Package: *
Pin: origin deb.nodesource.com
Pin-Priority: 1

Package: nodejs
Pin: origin deb.nodesource.com
Pin-Priority: 500
EOT

apt-get install -y nodejs


# install kurento media server 6.15.0
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5AFA7A83

tee "/etc/apt/sources.list.d/kurento.list" >/dev/null <<EOF
# Kurento Media Server - Release packages
deb [arch=amd64] http://ubuntu.openvidu.io/6.15.0 $(lsb_release -cs) kms6
EOF

apt-get update && apt-get install -y kurento-media-server


# install big blue button 2.3.0
echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/bigbluebutton-archive-keyring.gpg] https://ubuntu.bigbluebutton.org/bionic-230 \
    bigbluebutton-bionic main" | tee /etc/apt/sources.list.d/bigbluebutton.list

cat <<EOT >> /etc/apt/preferences.d/bigbluebutton.pref
Package: *
Pin: origin ubuntu.bigbluebutton.org
Pin-Priority: 1

Package: bigbluebutton
Pin: origin ubuntu.bigbluebutton.org
Pin-Priority: 500
EOT

apt-get update && apt-get install -y bigbluebutton=1:${application_version}*


## Greenlight Frontend
# install Docker
echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

cat <<EOT >> /etc/apt/preferences.d/docker-ce.pref
Package: *
Pin: origin download.docker.com
Pin-Priority: 1

Package: docker-ce
Pin: origin download.docker.com
Pin-Priority: 500
EOT

apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# install Docker Compose 1.24.0
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create greenlight directory
mkdir -p /root/greenlight

# download greenlight image and create greenlight files
docker pull bigbluebutton/greenlight:v2
docker pull postgres:13.2-alpine
docker run --rm bigbluebutton/greenlight:v2 cat ./sample.env > /root/greenlight/.env
docker run --rm bigbluebutton/greenlight:v2 cat ./docker-compose.yml > /root/greenlight/docker-compose.yml
docker run --rm bigbluebutton/greenlight:v2 cat ./greenlight.nginx | tee /etc/bigbluebutton/nginx/greenlight.nginx > /dev/null

cat > /etc/bigbluebutton/nginx/greenlight-redirect.nginx << EOF
location = / {
  return 307 /b;
}
EOF
