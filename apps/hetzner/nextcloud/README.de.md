# Hetzner Cloud Nextcloud

<img src="images/nextcloud-logo.png" height="97px">
<br>

Diese App enthält eine fertige Nextcloud-Installation.
Sie können sie über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

[Nextcloud](https://nextcloud.com/de/) vereint die Einfachheit mit der sich Dienste wie Dropbox und Google Drive nutzen lassen mit Sicherheit, Privatsphäre und Kontrolle. Es ist eine freie Software, mit der man unter anderem Daten auf einem eigenen Server speichern kann (Filehosting).

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

Nextcloud ist vorinstalliert, wenn das Image gebootet wird, aber nicht aktiviert.

Um Nextcloud zu aktivieren und Ihren Admin-Benutzer anzulegen, melden Sie sich bitte auf Ihrem Server an:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

Dies führt Sie durch den Prozess, ermöglicht zusätzliche Let's Encrypt-Unterstützung und anschließend können Sie Nextcloud wie gewohnt aus dem Web nutzen. Sollten Sie _Let's Encrypt_ beim ersten Mal anmelden überspringen, ist es später immer noch möglich das Zertifikat zu aktivieren (siehe _Let's Encrypt nachträglich aktivieren_).

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines Servers mit vorinstalliertem Nextcloud auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cx31", "image":"nextcloud"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cx31 --image nextcloud
  ```

## Let's Encrypt nachträglich aktivieren

Let’s Encrypt stellt kostenfrei digitale Zertifikate zur Verfügung. Diese werden auf Webseiten zur Aktivierung von HTTPS (SSL/TLS) benötigt.

Um Let's Encrypt nachträglich zu aktivieren, führen Sie bitte folgende Schritte aus:

1. Certbot (vorinstalliert) mit Apache-Plugin ausführen

   ```
   certbot --apache
   ```

   Sie werden durch den Prozess geleitet, durch den Sie ein gültiges SSL-Zertifikat erhalten.

2. Apache neustarten

   ```
   systemctl restart apache2
   ```

## Image Inhalt

### Betriebssystem

- [x] Ubuntu 20.04

### Installierte Pakete

Dieses Image enthält Apache, MySQL and PHP als Pakete und Nextcloud aus dem Quellcode.

| NAME      | LIZENZ             |
| --------- | ------------------ |
| Nextcloud | AGPLv3             |
| Apache    | GPLv3 (Apache 2.0) |
| MySQL     | GPL                |
| PHP       | GPL (Expat)        |
| Certbot   | GPL (Apache 2.0)   |

### Passwörter

Wir verwenden automatisch generierte Passwörter, die im folgenden Ordner gespeichert werden:

```
/root/.hcloud_password
```

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [Nextcloud](https://nextcloud.com/de/support/)
- [Apache](https://cwiki.apache.org/confluence/display/httpd/FAQ)
- [MySQL](https://dev.mysql.com/doc/)
- [PHP](https://www.php.net/manual/de/)
- [Certbot](https://certbot.eff.org/docs/)

- [Let’s Encrypt](https://letsencrypt.org/de/docs/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
