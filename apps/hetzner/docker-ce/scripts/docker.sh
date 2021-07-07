#!/bin/sh

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

apt-get -y update
apt-get -y install docker-ce

systemctl enable docker
systemctl start docker
