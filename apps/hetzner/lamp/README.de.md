# Hetzner Cloud LAMP

<img src="images/lamp-logo.png" height="97px">
<br>

Diese App enthält eine fertige LAMP-Installation.
Sie können sie über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

LAMP beschreibt ein System, das den Web-Server Apache mit PHP und den Datenbank-Server MySQL unter Linux bereitstellt. Bei allen vier Komponenten handelt es sich um Open-Source-Projekte.

L - [Linux](https://www.kernel.org/) ist das Betriebssystem.

A - [Apache](https://apache.org/) ist der Webserver.

M - [MySQL](https://www.mysql.com/de/) ist das Datenbanksystem.

P - [PHP](https://www.php.net/) ist die Programmiersprache.

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

LAMP ist vorinstalliert, wenn das Image gebootet wird, aber nicht aktiviert.

Um LAMP zu aktivieren, melden Sie sich bitte auf Ihrem Server an:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

Dies führt Sie durch den Prozess und ermöglicht zusätzliche Let's Encrypt-Unterstützung. Sollten Sie _Let's Encrypt_ beim ersten Mal anmelden überspringen, ist es später immer noch möglich das Zertifikat zu aktivieren (siehe _Let's Encrypt nachträglich aktivieren_).

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines Servers mit vorinstalliertem LAMP Stack auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cx31", "image":"lamp"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cx31 --image lamp
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

| NAME    | LIZENZ             |
| ------- | ------------------ |
| Apache  | GPLv3 (Apache 2.0) |
| MySQL   | GPL                |
| PHP     | GPL (Expat)        |
| Certbot | GPL (Apache 2.0)   |
| Perl    | GPL                |

### Passwörter

Wir verwenden automatisch generierte Passwörter, die im folgenden Ordner gespeichert werden:

```
/root/.hcloud_password
```

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [Linux](https://www.kernel.org/doc/html/latest/) / [Ubuntu](https://help.ubuntu.com/?_ga=2.73622737.2143576050.1623226390-1046440168.1622099723)
- [Apache](https://cwiki.apache.org/confluence/display/httpd/FAQ)
- [MySQL](https://dev.mysql.com/doc/)
- [PHP](https://www.php.net/manual/de/)
- [Certbot](https://certbot.eff.org/docs/)
- [Perl](https://perldoc.perl.org/)

- [Let’s Encrypt](https://letsencrypt.org/de/docs/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
