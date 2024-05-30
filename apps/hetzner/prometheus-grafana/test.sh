#!/bin/bash
set -uexo pipefail

docker compose -f /opt/containers/prometheus-grafana/docker-compose.yml up -d

[[ "$(docker run -i busybox /bin/ash -c 'echo -n hello world')" == "hello world" ]] || exit 1


failed="0"
echo "Waiting for prometheus to become healthy: ..."
for i in {1..60}; do
  failed=1
  if [[ "$(docker run -i --network prometheus-grafana_monitoring alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s prometheus:9090/-/healthy')" == "Prometheus Server is Healthy." ]]; then
      failed="0"
      break
  fi
  sleep 2
  echo -n .
done
[[ "$failed" == "1" ]] && exit 1

echo "Waiting for prometheus-node-exporter to become ready: ..."
for i in {1..60}; do
  failed=1
  if [[ "$(docker run -i --network prometheus-grafana_monitoring alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s prometheus:9090/api/v1/query?query=node_os_version | grep Ubuntu')"u ]]; then
      failed="0"
      break
  fi
  sleep 2
  echo -n .
done
[[ "$failed" == "1" ]] && exit 1

echo "Waiting for cadvisor to become ready: ..."
for i in {1..60}; do
  failed=1
  if [[ "$(docker run -i --network prometheus-grafana_monitoring alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s prometheus:9090/api/v1/query?query=machine_cpu_cores | grep cadvisor')" ]]; then
      failed="0"
      break
  fi
  sleep 2
  echo -n .
done
[[ "$failed" == "1" ]] && exit 1

echo "Waiting for grafana to become ready: ..."
for i in {1..60}; do
  failed=1
  if [[ "$(docker run --env-file=/opt/containers/prometheus-grafana/.env -i --network prometheus-grafana_monitoring alpine /bin/sh -c 'apk add curl &> /dev/null && curl -s -u $ADMIN_USER:$ADMIN_PASSWORD grafana:3000/metrics | grep prometheus_template_text_expansions_total')" ]]; then
      exit 0
  fi
  sleep 2
  echo -n .
done
exit 1
