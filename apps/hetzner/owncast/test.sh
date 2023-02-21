#!/bin/bash
set -uexo pipefail

docker compose -f /opt/containers/owncast/docker-compose.yml up -d

[[ "$(docker run --network owncast_proxy -i alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s traefik:80')" ]] || exit 1
[[ "$(docker run --network owncast_proxy -i alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s owncast:8080')" ]] || exit 1
