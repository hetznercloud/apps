#!/bin/sh

echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/jitsi-archive-keyring.gpg] https://download.jitsi.org stable/" | tee /etc/apt/sources.list.d/jitsi-stable.list

# Pin Package version
cat << EOF >> /etc/apt/preferences.d/jitsi-meet
Package: *
Pin: origin download.jitsi.org
Pin-Priority: 1

Package: jitsi-meet
Pin: version ${application_version}*
Pin: origin download.jitsi.org
Pin-Priority: 500
EOF
