# Hetzner Cloud Coolify

<img src="images/coolify-logo.png" height="100px">
<br>

[Coolify](https://github.com/coollabsio/coolify) verwandelt Ihren Server in eine Open-Source & selbst-hostbare Heroku / Netlify / Vercel Alternative.

[![Deploy to Hetzner Cloud](../../shared/images/deploy_to_hetzner.png)](https://console.hetzner.cloud/deploy/coolify)

Sie können Coolify über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

Die Sammlung ist in Form von [Docker-Images](https://www.docker.com/) auf dem Server vorinstalliert, aber nicht aktiviert.

Um die Sammlung zu aktivieren, melden Sie sich bitte auf Ihrem Server an:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

Dies führt Sie durch einen Prozess, wobei sie anschließend alle Services aus dem Web, mit automatischer Let's Encrypt-Unterstützung, benutzen können.

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines Coolify Servers auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-coolify-server", "server_type":"cpx11", "image":"coolify"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-coolify-server --type cpx11 --image coolify
  ```

## Image Inhalt

### Betriebssystem

- [x] Ubuntu 24.04

### Installierte Pakete

Dieses Image enthält Docker und alle anderen aufgeführten Anwendungen als Docker Container.

| NAME       | LICENSE            |
| ---------- | ------------------ |
| Docker     | GPLv3 (Apache 2.0) |
| Coolify    | AGPLv3             |

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [Docker](https://www.docker.com/)
- [Coolify](https://github.com/coolify/coolify/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
