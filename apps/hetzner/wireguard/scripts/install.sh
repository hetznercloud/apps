#!/bin/sh
set -e

# Download the given version of wireguard-ui
# TODO: For now, we use a fork of wireguard-ui that contains some fixes that have not been merged into upstream yet.
# As soon as these fixes, or similar ones, are merged, we should switch back to a release by https://github.com/ngoduykhanh/wireguard-ui.
wget "https://github.com/MarcusWichelmann/wireguard-ui/releases/download/v${wireguard_ui_version}/wireguard-ui-v${wireguard_ui_version}-linux-amd64.tar.gz" -O /tmp/wireguard-ui.tar.gz

# Unpack wireguard-ui
tar -C /usr/local/bin -xzf /tmp/wireguard-ui.tar.gz wireguard-ui

# Download the given version of caddy
wget "https://github.com/caddyserver/caddy/releases/download/v${caddy_version}/caddy_${caddy_version}_linux_amd64.tar.gz" -O /tmp/caddy.tar.gz

# Unpack caddy
tar -C /usr/local/bin -xzf /tmp/caddy.tar.gz caddy

# Create the caddy user
groupadd --system caddy
useradd --system --gid caddy --create-home --home-dir /var/lib/caddy --shell /usr/sbin/nologin --comment "Caddy web server" caddy
