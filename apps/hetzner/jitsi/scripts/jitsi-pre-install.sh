#!/bin/sh

echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/jitsi-archive-keyring.gpg] https://download.jitsi.org stable/" | tee /etc/apt/sources.list.d/jitsi-stable.list
echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/prosody-archive-keyring.gpg] http://packages.prosody.im/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/prosody.list
