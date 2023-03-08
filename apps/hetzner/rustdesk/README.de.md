# Hetzner Cloud RustDesk

<img src="images/rustdesk-logo.png" height="100px">

[RustDesk](https://github.com/rustdesk/rustdesk/) verwandelt Ihren Server in einen sofort einsatzbereiten Remote-Desktop-Server, der ohne Konfiguration sofort funktioniert.
Sie haben die volle Kontrolle über Ihre Daten und müssen sich keine Sorgen um die Sicherheit machen.

Sie können RustDesk über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

Die Sammlung ist in Form von [Docker-Images](https://www.docker.com/) auf dem Server vorinstalliert, aber nicht aktiviert.

Um die Sammlung zu aktivieren, melden Sie sich bitte auf Ihrem Server an:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

Dies führt Sie durch einen Prozess, wobei sie anschließend alle Services aus dem Web, mit automatischer Let's Encrypt-Unterstützung, benutzen können.

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines RustDesk Servers auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-rustdesk-server", "server_type":"cpx21", "image":"rustdesk"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-rustdesk-server --type cpx21 --image rustdesk
  ```

## Image Inhalt

### Betriebssystem

- [x] Ubuntu 22.04

### Installierte Pakete

Dieses Image enthält Docker und alle anderen aufgeführten Anwendungen als Docker Container.

| NAME       | LIZENZ             |
| ---------- | ------------------ |
| Docker     | GPLv3 (Apache 2.0) |
| RustDesk   | AGPLv3             |
| MariaDB    | GPLv2              |
| Traefik    | MIT                |
| Watchtower | GPLv3 (Apache 2.0) |

### Passwörter

Ihren RustDesk API key finden Sie unter:

```
/opt/containers/rustdesk/data/id_ed25519.pub
```

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [Docker](https://www.docker.com/)
- [RustDesk](https://github.com/rustdesk/rustdesk/)
- [Watchtower](https://containrrr.dev/watchtower/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
