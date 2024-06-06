# Hetzner Cloud Kollaboration Tools

> Diese App ist ab dem 05. Juni 2024 veraltet und ab dem 05. Juli 2024 nicht mehr verfügbar.
> Sollten Sie diese App weiterhin verwenden wollen, wird Ihnen [hier](https://github.com/hetznercloud/apps?tab=readme-ov-file#development) erklärt, wie Sie selbst ein App-Template Snapshot anlegen können.

Diese App enthält eine Sammlung von verschiedenen Kollaborationstools
Sie können sie über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

[![Deploy to Hetzner Cloud](../../shared/images/deploy_to_hetzner.png)](https://console.hetzner.cloud/deploy/collab-tools)

Die Kollaborationssammlung besteht aus [Transfer](https://transfer.sh/), einem File-Sharing Service welcher sowohl über die Weboberfläche als auch über die Kommandozeile verwendet werden kann, [HedgeDoc](https://hedgedoc.org/) welcher als Markdown Editor zum Brainstorming von mehreren Personen gleichzeitig verwendet werden kann und [Whiteboard](https://github.com/cracker0dks/whiteboard) um Ideen grafisch dokumentieren zu können.

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

Die Sammlung ist in Form von [Docker-Images](https://www.docker.com/) auf dem Server vorinstalliert, aber nicht aktiviert.

Um die Sammlung zu aktivieren, melden Sie sich bitte auf Ihrem Server an:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

Dies führt Sie durch einen Prozess, wobei sie anschließend alle Services aus dem Web, mit automatischer Let's Encrypt-Unterstützung, benutzen können.

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines Servers mit allen vorinstallierten Kollaborationstools auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cpx21", "image":"collab-tools"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cpx21 --image collab-tools
  ```

## Image Inhalt

### Betriebssystem

- [x] Ubuntu 22.04

### Installierte Pakete

Dieses Image enthält Docker und alle anderen aufgeführten Anwendungen als Docker Container.

| NAME               | LIZENZ             |
| ------------------ | ------------------ |
| Whiteboard         | MIT                |
| HedgeDoc           | AGPLv3             |
| Transfer           | MIT                |
| Docker             | GPLv3 (Apache 2.0) |
| Watchtower         | GPLv3 (Apache 2.0) |
| Caddy-docker-proxy | MIT                |
| PostgreSQL         | PostgreSQL Licence |

### Passwörter

Wir verwenden automatisch generierte Passwörter, die im folgenden Ordner gespeichert werden:

```
/root/.hcloud_password
```

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [Whiteboard](https://github.com/cracker0dks/whiteboard)
- [HedgeDoc](https://hedgedoc.org/)
- [Transfer](https://transfer.sh/)
- [Docker](https://www.docker.com/)
- [Caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy/)
- [Watchtower](https://containrrr.dev/watchtower/)
- [PostgreSQL](https://www.postgresql.org/)

- [Let’s Encrypt](https://letsencrypt.org/de/docs/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
