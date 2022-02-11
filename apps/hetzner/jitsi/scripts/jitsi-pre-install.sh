#!/bin/sh

echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/jitsi-archive-keyring.gpg] https://download.jitsi.org stable/" | tee /etc/apt/sources.list.d/jitsi-stable.list
