#!/bin/bash

DEBARCH='amd64'

ARCH=$(uname -i)
if [ "$ARCH" == 'aarch64' ]; then
    DEBARCH='arm64'
fi

echo \
    "deb [arch=$DEBARCH signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

cat <<EOT >> /etc/apt/preferences.d/docker-ce.pref
Package: *
Pin: origin download.docker.com
Pin-Priority: 1

Package: docker-ce
Pin: origin download.docker.com
Pin-Priority: 500
EOT

apt-get -y update
apt-get -y install docker-ce docker-compose-plugin

systemctl enable docker
systemctl start docker
