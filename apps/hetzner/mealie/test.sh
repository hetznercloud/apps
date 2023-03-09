#!/bin/bash
set -uexo pipefail

docker compose -f /opt/containers/mealie/docker-compose.yml up -d

[[ "$(docker run --network mealie_proxy -i alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s traefik:80')" ]] || exit 1
[[ "$(docker run --network mealie_proxy -i alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s mealie-frontend:3000')" ]] || exit 1
[[ "$(docker run --network mealie_backend -i alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s mealie-api:9000')" ]] || exit 1
