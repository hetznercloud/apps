#!/bin/bash
set -uexo pipefail

docker compose -f /opt/containers/collab-tools/docker-compose.yml up -d

[[ "$(docker run --network collab-tools_proxy -i alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s transfer:8080')" ]] || exit 1
[[ "$(docker run --network collab-tools_proxy -i alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s whiteboard:8080')" ]] || exit 1
[[ "$(docker run --network collab-tools_proxy -i alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s hedgedoc:3000')" ]] || exit 1
