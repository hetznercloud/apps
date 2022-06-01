#!/bin/sh
set -e
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sh /tmp/get-docker.sh
docker network create proxy
docker compose -f /opt/containers/prometheus-grafana/docker-compose.yml up -d
docker compose -f /opt/containers/prometheus-grafana/docker-compose.yml -v down
