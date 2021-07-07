# Hetzner Cloud Jitsi

<img src="images/jitsi-logo.png" height="97px">

Diese App enthält eine fertige Jitsi-Installation.
Sie können sie über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

[Jitsi](https://jitsi.org/) ist eine Sammlung an Open Source Projekten, die es Ihnen ermöglichen sichere Videokonferenzlösungen einfach zu bauen und anzuwenden. Das Herz von Jitsi bilden Jitsi Videobridge und Jitsi Meet, die es Ihnen ermöglichen Konferenzen im Internet abzuhalten.

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

Jitsi ist vorinstalliert, wenn das Image gebootet wird, aber nicht aktiviert.

Um Jitsi zu aktivieren, melden Sie sich bitte auf Ihrem Server an:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

Dies führt Sie durch den Prozess, ermöglicht zusätzliche Let's Encrypt-Unterstützung und anschließend können Sie Jitsi wie gewohnt aus dem Web nutzen. Sollten Sie _Let's Encrypt_ beim ersten Mal anmelden überspringen, ist es später immer noch möglich das Zertifikat zu aktivieren (siehe _Let's Encrypt nachträglich aktivieren_).

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines Servers mit vorinstalliertem Jitsi auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
  	-X POST \
  	-H "Authorization: Bearer $API_TOKEN" \
  	-H "Content-Type: application/json" \
  	-d '{"name":"my-server", "server_type":"cx31", "image":"jitsi"}' \
  	'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cx31 --image jitsi
  ```

## Let's Encrypt nachträglich aktivieren

Let’s Encrypt stellt kostenfrei digitale Zertifikate zur Verfügung. Diese werden auf Webseiten zur Aktivierung von HTTPS (SSL/TLS) benötigt.

Um Let's Encrypt nachträglich zu aktivieren, führen Sie bitte folgendes Skript aus:

```
/usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
```

Dieses stellt Jitsi auf SSL um und bezieht ein gültiges Let's Encrypt Zertifikat.

## Image Inhalt

### Betriebssystem

- [x] Ubuntu 20.04

### Installierte Pakete

| NAME      | LIZENZ             |
| --------- | ------------------ |
| Jitsi     | GPLv3 (Apache 2.0) |
| Nginx     | GPL (BSD)          |
| Certbot   | GPLv3 (Apache 2.0) |
| OpenJDK11 | GPL                |

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [Jitsi](https://jitsi.github.io/handbook/docs/intro)
- [Nginx](http://nginx.org/en/docs/)
- [Certbot](https://certbot.eff.org/docs/)
- [OpenJDK8](https://openjdk.java.net/projects/jdk8/)

- [Let’s Encrypt](https://letsencrypt.org/de/docs/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
