# Hetzner Cloud WordPress

<img src="images/wordpress-logo.png" height="97px">
<br>

Diese App enthält eine fertige WordPress-Installation inklusive MySQL und Apache2.
Sie können sie über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

[WordPress](https://wordpress.com/de/) ist ein Open Source Content-Management-System (CMS), mit dem es möglich ist innerhalb von wenigen Minuten eine Webseite oder einen Blog zu erstellen.

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

WordPress ist vorinstalliert, wenn das Image gebootet wird, aber nicht aktiviert.

Um WordPress zu aktivieren und Ihren Admin-Benutzer anzulegen, melden Sie sich bitte auf Ihrem Server an:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

Dies führt Sie durch den Prozess, ermöglicht zusätzliche Let's Encrypt-Unterstützung und anschließend können Sie WordPress wie gewohnt aus dem Web nutzen. Sollten Sie _Let's Encrypt_ beim ersten Mal anmelden überspringen, ist es später immer noch möglich das Zertifikat zu aktivieren (siehe _Let's Encrypt nachträglich aktivieren_).

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines Servers mit vorinstalliertem WordPress auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cpx21", "image":"wordpress"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cpx21 --image wordpress
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

Dieses Image enthält MySQL, Apache2 und verschiedene PHP-Erweiterungen als Pakete und WordPress aus dem Quellcode.

| NAME         | LIZENZ                   |
| ------------ | ------------------------ |
| WordPress    | GPL 2                    |
| Apache       | Apache 2                 |
| MySQL Server | GPL 2 mit Modifikationen |

verschiedene PHP Erweiterungen als Pakete

### Passwörter

Wir verwenden automatisch generierte Passwörter, die im folgenden Ordner gespeichert werden:

```
/root/.hcloud_password
```

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [WordPress](https://wordpress.org/support/)
- [Apache](https://cwiki.apache.org/confluence/display/httpd/FAQ)
- [MySQL server](https://dev.mysql.com/doc/)

- [Let’s Encrypt](https://letsencrypt.org/de/docs/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
