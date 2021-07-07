# Hetzner Cloud BigBlueButton

<img src="images/BigBlueButton_logo.svg.png" height="97px">

Diese App enthält eine fertige BigBlueButton-Installation mit Greenlight 2.0 Benutzeroberfläche.
Sie können sie über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

[BigBlueButton](https://bigbluebutton.org/) wurde von Lehrern für Lehrer entwickelt und ist die einzige Plattform, die von Grund auf als virtuelles Klassenzimmer aufgebaut wurde. Es stehen 65 Sprachen zur Verfügung und Lehrer aus der ganzen Welt haben zu dem Webkonferenzsystem beigetragen.

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

BigBlueButton ist vorinstalliert, wenn das Image gebootet wird, aber nicht aktiviert.

Um BigBlueButton zu aktivieren, melden Sie sich bitte auf Ihrem Server an:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

Dies führt Sie durch den Prozess, ermöglicht zusätzliche Let's Encrypt-Unterstützung und anschließend können Sie BigBlueButton wie gewohnt aus dem Web nutzen. Sollten Sie _Let's Encrypt_ beim ersten Mal anmelden überspringen, ist es später immer noch möglich das Zertifikat zu aktivieren (siehe _Let's Encrypt nachträglich aktivieren_).

### Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines Servers mit vorinstalliertem BigBlueButton auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cx31", "image":"big-blue-button"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cx31 --image big-blue-button
  ```

## BigBlueButton Aufzeichnungsfunktion

BigBlueButton bietet die Funktion, Konferenzen aufzuzeichnen. Diese Funktion ist im Image standardmäßig aktiviert.

Bitte beachten Sie, dass diese Funktion viel Speicherplatz benötigen kann.

Aufnahmen können über die Benutzeroberfläche unter **Alle Aufzeichnungen** abgespielt und gelöscht werden.

Es ist zudem möglich die Aufzeichnungen über die Kommandozeile zu löschen:

1. Aufnahmen auflisten

   ```
   bbb-record --list
   ```

2. Bestimmte Aufnahme löschen

   ```
   bbb-record --delete 6e35e3b2778883f5db637d7a5dba0a427f692e91-1379965122603
   ```

3. Alle Aufnahmen auf einmal löschen

   ```
   bbb-record --deleteall
   ```

## Let's Encrypt nachträglich aktivieren

Let’s Encrypt stellt kostenfrei digitale Zertifikate zur Verfügung. Diese werden auf Webseiten zur Aktivierung von HTTPS (SSL/TLS) benötigt.

Beachten Sie, dass selfsigned Zertifikate nicht gut mit BigBlueButton funktionieren. Wir empfehlen Let's Encrypt.

Um Let's Encrypt nachträglich zu aktivieren, führen Sie bitte folgende Schritte aus:

1. Certbot (vorinstalliert) mit Nginx-Plugin ausführen

   ```
   certbot --nginx
   ```

   Sie werden durch den Prozess geleitet, durch den Sie ein gültiges SSL-Zertifikat erhalten.

2. BBB (BigBlueButton) neustarten

   ```
   bbb-conf --restart
   ```

## Image Inhalt

### Betriebssystem

- [x] Ubuntu 18.04

### Installierte Pakete

| NAME          | LIZENZ             |
| ------------- | ------------------ |
| BigBlueButton | LGPL               |
| Docker CE     | GPLv3 (Apache-2.0) |
| Nginx         | GPL (BSD)          |
| OpenJDK8      | GPL                |
| Haveged       | GPL                |
| Certbot       | GPLv3 (Apache-2.0) |

### Passwörter

Wir verwenden automatisch generierte Passwörter, die im folgenden Ordner gespeichert werden:

```
/root/.hcloud_password
```

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [BigBlueButton](https://docs.bigbluebutton.org/)
- [Nginx](http://nginx.org/en/docs/)
- [Certbot](https://certbot.eff.org/docs/)
- [OpenJDK8](https://openjdk.java.net/projects/jdk8/)
- [Haveged](https://www.issihosts.com/haveged/index.html)

- [Let’s Encrypt](https://letsencrypt.org/de/docs/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
