#!/bin/bash
set -e

GOARCH='amd64'
application_checksum=${application_checksum_amd64}

ARCH=$(uname -i)
if [ "$ARCH" == 'aarch64' ]; then
    GOARCH='arm64'
    application_checksum=${application_checksum_arm64}
fi

# Download given Go version and check sha256 checksum
wget "https://go.dev/dl/go${application_version}.linux-${GOARCH}.tar.gz" -O /tmp/go.tar.gz

echo "${application_checksum} /tmp/go.tar.gz" | sha256sum -c

# Install go
tar -C /usr/local -xzf /tmp/go.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.profile
