#!/bin/bash
set -e

GOARCH='amd64'

ARCH=$(uname -i)
if [ "$ARCH" == 'aarch64' ]; then
    GOARCH='arm64'
fi

# Download the given version of wireguard-ui
# Note, that we're using a fork of wireguard-ui here, so we have more control about the applied patches and releases.
wget "https://github.com/MarcusWichelmann/wireguard-ui/releases/download/v${wireguard_ui_version}/wireguard-ui-v${wireguard_ui_version}-linux-${GOARCH}.tar.gz" -O /tmp/wireguard-ui.tar.gz

# Unpack wireguard-ui
tar -C /usr/local/bin -xzf /tmp/wireguard-ui.tar.gz wireguard-ui

# Create the data directory
mkdir -p /usr/local/share/wireguard-ui

# Download the given version of caddy
wget "https://github.com/caddyserver/caddy/releases/download/v${caddy_version}/caddy_${caddy_version}_linux_${GOARCH}.tar.gz" -O /tmp/caddy.tar.gz

# Unpack caddy
tar -C /usr/local/bin -xzf /tmp/caddy.tar.gz caddy

# Create the caddy user
groupadd --system caddy
useradd --system --gid caddy --create-home --home-dir /var/lib/caddy --shell /usr/sbin/nologin --comment "Caddy web server" caddy
