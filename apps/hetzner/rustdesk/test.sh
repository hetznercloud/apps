#!/bin/bash
set -uexo pipefail

docker compose -f /opt/containers/rustdesk/docker-compose.yml up -d

[[ "$(docker run --network rustdesk_backend -i alpine /bin/sh -c 'apk add netcat-openbsd  && nc -z hbbr 21117')" ]] || exit 1
[[ "$(docker run --network rustdesk_backend -i alpine /bin/sh -c 'apk add netcat-openbsd  && nc -z hbbs 21115')" ]] || exit 1
