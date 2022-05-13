#!/bin/sh
set -e

# Download given Go version and check sha256 checksum
wget "https://go.dev/dl/go${application_version}.linux-amd64.tar.gz" -O /tmp/go.tar.gz

echo "${application_checksum} /tmp/go.tar.gz" | sha256sum -c

# Install go
tar -C /usr/local -xzf /tmp/go.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.bashrc
