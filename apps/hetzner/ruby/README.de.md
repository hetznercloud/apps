# Hetzner Cloud Ruby

<img src="images/ruby-logo.png" height="97px">
<br>

Diese App enthält eine fertige Ruby-Installation.
Sie können sie über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

[Ruby](https://www.ruby-lang.org/de/) ist eine dynamische, freie Programmiersprache, die sich einfach anwenden und produktiv einsetzen lässt. Sie hat eine elegante Syntax, die man leicht lesen und schreiben kann.

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

Ruby ist vorinstalliert, wenn das Image gebootet wird.

Sie können sich wie gewohnt auf Ihrem Server anmelden:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben oder später einen hinzugefügt haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines Servers mit vorinstalliertem Ruby auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
  	-X POST \
  	-H "Authorization: Bearer $API_TOKEN" \
  	-H "Content-Type: application/json" \
  	-d '{"name":"my-server", "server_type":"cpx21", "image":"ruby"}' \
  	'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cpx21 --image ruby
  ```

## Image Inhalt

### Betriebssystem

- [x] Ubuntu 22.04

### Installierte Pakete

| NAME | LIZENZ  |
| ---- | ------- |
| Ruby | FreeBSD |

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [Ruby](https://www.ruby-lang.org/de/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
