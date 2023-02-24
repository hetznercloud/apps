#!/bin/bash
set -uexo pipefail

docker compose -f /opt/containers/photoprism/docker-compose.yml up -d

[[ "$(docker run --network photoprism_proxy -i alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s traefik:80')" ]] || exit 1
[[ "$(docker run --network photoprism_proxy -i alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s photoprism:2342')" ]] || exit 1
