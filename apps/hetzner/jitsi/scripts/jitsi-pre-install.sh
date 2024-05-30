#!/bin/bash
DEBARCH='amd64'

ARCH=$(uname -i)
if [ "$ARCH" == 'aarch64' ]; then
    DEBARCH='arm64'
fi

echo \
    "deb [arch=$DEBARCH signed-by=/usr/share/keyrings/jitsi-archive-keyring.gpg] https://download.jitsi.org stable/" | tee /etc/apt/sources.list.d/jitsi-stable.list
echo \
    "deb [arch=$DEBARCH signed-by=/usr/share/keyrings/prosody-archive-keyring.gpg] http://packages.prosody.im/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/prosody.list
