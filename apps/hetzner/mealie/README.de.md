# Hetzner Cloud Mealie

Mit dieser App wird Ihr Server zu einem selbstgehostetem Rezeptmanager und Essensplaner mit einem RestAPI-Backend und einer in Vue entwickelten Frontend-Anwendung für eine angenehme Benutzererfahrung für die ganze Familie.

Sie können Mealie über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

Die Sammlung ist in Form von [Docker-Images](https://www.docker.com/) auf dem Server vorinstalliert, aber nicht aktiviert.

Um die Sammlung zu aktivieren, melden Sie sich bitte auf Ihrem Server an:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

Dies führt Sie durch einen Prozess, wobei sie anschließend alle Services aus dem Web, mit automatischer Let's Encrypt-Unterstützung, benutzen können.

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines Mealie Servers auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-mealie-server", "server_type":"cpx11", "image":"mealie"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-mealie-server --type cpx11 --image mealie
  ```

## Image Inhalt

### Betriebssystem

- [x] Ubuntu 22.04

### Installierte Pakete

Dieses Image enthält Docker und alle anderen aufgeführten Anwendungen als Docker Container.

| NAME       | LIZENZ             |
| ---------- | ------------------ |
| Docker     | GPLv3 (Apache 2.0) |
| Mealie     | AGPLv3             |
| Traefik    | MIT                |
| Watchtower | GPLv3 (Apache 2.0) |

### Passwörter

Die Email des Superusers wird bei der installation angegeben.
Das Passwort für diesen User lautet `MyPassword`.
Bitte ändern sie dieses Passwort umgehend nach der Installation.

## Konfiguration

Um den Mailversand zu nuzten wird ein SMTP Server benötigt.
Die Zugangsdaten zu ihren Mailserver können in der Datei `/opt/containers/mealie/docker-compose.yml` geändert werden.

## Updates installieren

Die Version des Mealie Containers kann mit der Variable `MEALIE_VERSION` in der Datei `/opt/containers/mealie/.env` geändert werden.
Im Anschluss müssen die Container mit dem Befehl `docker compose down && docker compose up -d` neu gestartet werden.

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [Docker](https://www.docker.com/)
- [Mealie](https://github.com/hay-kot/mealie/)
- [Traefik](https://github.com/traefik/traefik/)
- [Watchtower](https://containrrr.dev/watchtower/)
- [Let's Encrypt](https://letsencrypt.org/de/docs/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
