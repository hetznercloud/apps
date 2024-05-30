#!/bin/sh
set -e
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sh /tmp/get-docker.sh

mkdir -p /opt/containers/whiteboard
git clone -n https://github.com/cracker0dks/whiteboard /opt/containers/whiteboard
cd /opt/containers/whiteboard
git checkout 336de8b3ef87ed964f0780206fd7f5dd5bd5b99a
