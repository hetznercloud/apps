#!/bin/bash
set -uexo pipefail

docker compose -f /opt/containers/photoprism/docker-compose.yml up -d


echo "Waiting for traefik: ..."
for i in {1..60}; do
  if [[ "$(docker run --network photoprism_proxy -i alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s traefik:80')" ]]; then
    echo "Waiting for photoprism: ..."
    for i in {1..60}; do
      if [[ "$(docker run --network photoprism_proxy -i alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s photoprism:2342')" ]]; then
        exit 0
      fi
      sleep 2
      echo -n .
    done

    exit 1
  fi
  sleep 2
  echo -n .
done

exit 1
