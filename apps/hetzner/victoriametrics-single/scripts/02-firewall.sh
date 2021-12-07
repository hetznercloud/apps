#!/bin/sh

sed -e 's|DEFAULT_FORWARD_POLICY=.*|DEFAULT_FORWARD_POLICY="ACCEPT"|g' \
    -i /etc/default/ufw

ufw allow ssh comment "SSH port"
ufw allow http comment "HTTP port"
ufw allow https comment "HTTPS port"
ufw allow 8428 comment "VictoriaMetrics Single HTTP port"
ufw allow 8089 comment "Influx Listen port for VictoriaMetrics"
ufw allow 2003 comment "Graphite Listen port for VictoriaMetrics"
ufw allow 4242 comment "OpenTSDB Listen port for VictoriaMetrics"

ufw --force enable