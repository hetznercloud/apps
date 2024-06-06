# Hetzner Cloud PhotoPrism

<img src="images/photoprism-logo.png" height="100px">
<br>

Mit [PhotoPrism](https://github.com/photoprism/photoprism/) wird Ihr Server zu einer einsatzbereiten Foto Lösung mit AI Funktionalität.
Sie nutzt die neuesten Technologien, um Bilder automatisch zu markieren und zu finden, ohne Ihnen im Weg zu stehen.

Sie können PhotoPrism über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

[![Deploy to Hetzner Cloud](../../shared/images/deploy_to_hetzner.png)](https://console.hetzner.cloud/deploy/photoprism)

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

Die Sammlung ist in Form von [Docker-Images](https://www.docker.com/) auf dem Server vorinstalliert, aber nicht aktiviert.

Um die Sammlung zu aktivieren, melden Sie sich bitte auf Ihrem Server an:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

Dies führt Sie durch einen Prozess, wobei sie anschließend alle Services aus dem Web, mit automatischer Let's Encrypt-Unterstützung, benutzen können.

Nach erfolgreich abgeschlossenem Setup werden die generierten Accountdetails auf der Console ausgegeben. Der Default-Admin User ist `photos_admin`.

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines PhotoPrism Servers auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-photoprism-server", "server_type":"cpx21", "image":"photoprism"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-photoprism-server --type cpx21 --image photoprism
  ```

## Image Inhalt

### Betriebssystem

- [x] Ubuntu 24.04

### Installierte Pakete

Dieses Image enthält Docker und alle anderen aufgeführten Anwendungen als Docker Container.

| NAME       | LIZENZ             |
| ---------- | ------------------ |
| Docker     | GPLv3 (Apache 2.0) |
| PhotoPrism | AGPLv3             |
| MariaDB    | GPLv2              |
| Traefik    | MIT                |
| Watchtower | GPLv3 (Apache 2.0) |

### Passwörter

Wir verwenden automatisch generierte Passwörter, die im folgenden Ordner gespeichert werden:

```
/root/.hcloud_password
```

Der Default-Admin User ist `photos_admin`.

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [Docker](https://www.docker.com/)
- [PhotoPrism](https://github.com/photoprism/photoprism/)
- [MariaDB](https://mariadb.com)
- [Traefik](https://github.com/traefik/traefik/)
- [Watchtower](https://containrrr.dev/watchtower/)
- [Let's Encrypt](https://letsencrypt.org/de/docs/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
