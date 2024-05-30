#!/bin/bash
set -uxo pipefail

docker compose -f /opt/containers/collab-tools/docker-compose.yml up -d

assert_connectivity() {
  for i in {1..3}; do
      result=$(docker run --network collab-tools_proxy -i alpine \
            /bin/sh -c "apk add curl &> /dev/null && curl --max-time 1 $1")
      if [ -n "$result" ]; then
          return
      fi
      sleep 2
  done

  if [ -z "$result" ]; then
      echo "$1: empty ..."
      exit 1
  fi
}

assert_connectivity http://transfer:8080
assert_connectivity http://whiteboard:8080
assert_connectivity http://hedgedoc:3000
