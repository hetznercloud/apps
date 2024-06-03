# Hetzner Cloud Docker

<img src="images/docker-logo.png" height="97px">
<br>

Diese App enthält eine fertige Docker-Installation.
Sie können sie über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

[![Deploy to Hetzner Cloud](../../shared/images/deploy_to_hetzner.png)](https://console.hetzner.cloud/deploy/docker-ce)

[Docker](https://www.docker.com/) ist ein Open-Source-Projekt zur Isolierung von Anwendungen mit Hilfe von Containervirtualisierung. Mit dieser App ist es möglich Anwendungen in unterschiedlichen Umgebungen zu nutzen.

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

Docker ist vorinstalliert, wenn das Image gebootet wird.

Sie können sich wie gewohnt auf Ihrem Server anmelden:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben oder später einen hinzugefügt haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines Servers mit vorinstalliertem Docker auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
  	-X POST \
  	-H "Authorization: Bearer $API_TOKEN" \
  	-H "Content-Type: application/json" \
  	-d '{"name":"my-server", "server_type":"cpx21", "image":"docker-ce"}' \
  	'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cpx21 --image docker-ce
  ```

## Image Inhalt

### Betriebssystem

- [x] Ubuntu 24.04

### Installierte Pakete

| NAME                  | LIZENZ             |
| --------------------- | ------------------ |
| Docker                | GPLv3 (Apache 2.0) |
| Docker Compose Plugin |                    |

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [Docker](https://docs.docker.com/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
