#!/bin/bash
set -uexo pipefail

docker compose -f /opt/containers/prometheus-grafana/docker-compose.yml up -d
[[ "$(docker run -i busybox /bin/ash -c 'echo -n hello world')" == "hello world" ]] || exit 1
[[ "$(docker run -i --network prometheus-grafana_monitoring alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s prometheus:9090/-/healthy')" == "Prometheus Server is Healthy." ]] || exit 1
[[ "$(docker run -i --network prometheus-grafana_monitoring  alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s prometheus:9090/api/v1/query?query=node_os_version | grep -q Ubuntu')" ]] || exit 1
[[ "$(docker run -i --network prometheus-grafana_monitoring  alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s prometheus:9090/api/v1/query?query=machine_cpu_cores | grep -q cadvisor')" ]] || exit 1
[[ "$(docker run --env-file=/opt/containers/prometheus-grafana/.env -i --network prometheus-grafana_monitoring alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s -u $ADMIN_USER:$ADMIN_PASSWORD grafana:3000/metrics | grep -q prometheus_template_text_expansions_total')" ]] || exit 1
docker compose -f /opt/containers/prometheus-grafana/docker-compose.yml down -v
