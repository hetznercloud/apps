# Hetzner Cloud Prometheus Grafana

<img src="images/prometheus-grafana-logo.png" height="97px">
<br>

Diese App enthält eine fertige Prometheus und Grafana Installation.
Sie können sie über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

[![Deploy to Hetzner Cloud](../../shared/images/deploy_to_hetzner.png)](https://console.hetzner.cloud/deploy/prometheus-grafana)

[Grafana](https://grafana.com/) ist eine Open-Source Software zur Visualisierung von Metriken. Diese Metriken werden von der Anwendung [Prometheus](https://prometheus.io/) zur Verfügung gestellt.

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

Prometheus und Grafana ist vorinstalliert, wenn das Image gebootet wird, aber nicht aktiviert.

Um Prometheus und Grafana zu aktivieren, melden Sie sich bitte auf Ihrem Server an:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

Dies führt Sie durch einen Prozess, wobei sie anschließend Grafana wie gewohnt aus dem Web, mit automatischer Let's Encrypt-Unterstützung, benutzen können.

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines Servers mit vorinstalliertem Prometheus und Grafana auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cpx21", "image":"prometheus-grafana"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cpx21 --image prometheus-grafana
  ```

## Image Inhalt

### Betriebssystem

- [x] Ubuntu 22.04

### Installierte Pakete und Container

Dieses Image enthält Docker und alle anderen aufgeführten Anwendungen als Docker Container.

| NAME               | LIZENZ              |
| ------------------ | ------------------- |
| Prometheus         | GGPLv3 (Apache 2.0) |
| Grafana            | AGPLv3              |
| Node-Exporter      | GPLv3 (Apache 2.0)  |
| Cadvisor           | GPLv3 (Apache 2.0)  |
| Docker             | GPLv3 (Apache 2.0)  |
| Watchtower         | GPLv3 (Apache 2.0)  |
| Caddy-docker-proxy | MIT                 |

### Passwörter

Wir verwenden automatisch generierte Passwörter, die im folgenden Ordner gespeichert werden:

```
/root/.hcloud_password
```

## Nützliche Befehle

### Passwort zurücksetzen

#### Grafana

Im Falle eines Verlust des Passworts für den Benutzer `admin` können sie dieses über die `grafana-cli` zurücksetzen. Melden sie sich hierfür zunächst an dem Server an.
Anschließend führen sie folgenden Befehl auf dem Server aus und setzen hierbei das von ihnen gewünschte Passwort ein:

```bash
docker exec -it grafana grafana-cli --homepath "/usr/share/grafana" admin reset-admin-password <password>
```

Das Passwort für den Benutzer `admin` wurde nun zurückgesetzt.

#### Prometheus

Insofern sie das Passwort für die Prometheus Basic Auth ändern möchten, können sie zunächst einen neuen Passwort-Hash mit folgendem Befehl generieren.

```bash
docker exec -it caddy caddy hash-password -plaintext <password>
```

Anschließend ändern sie den Hashwert für die Variable `PROMETHEUS_ADMIN_PASSWORD` in der Datei `/opt/containers/prometheus-grafana/.env`. Stoppen sie nun den Caddy Container und starten sie ihn anschließend wieder um die Änderung des Passworts abzuschließen.

```bash
docker compose -f /opt/containers/prometheus-grafana/docker-compose.yml stop caddy
docker compose -f /opt/containers/prometheus-grafana/docker-compose.yml start caddy
```

## Links

Weitere Informationen über die installierten Pakete und Container erhalten Sie in den offiziellen Dokumentationen:

- [Grafana](https://grafana.com/)
- [Prometheus](https://prometheus.io/)
- [Node-Exporter](https://github.com/prometheus/node_exporter)
- [Cadvisor](https://github.com/google/cadvisor)
- [Caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy/)
- [Docker](https://www.docker.com/)
- [Watchtower](https://containrrr.dev/watchtower/)

- [Let’s Encrypt](https://letsencrypt.org/de/docs/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
