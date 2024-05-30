# Hetzner Cloud WireGuard

<img src="images/wireguard-logo.png" height="100px">
<br>

Mit dieser App wird Ihr Server zu einem einfach zu verwendenen WireGuard VPN-Server, inklusive Management-Webinterface. Durch diesen VPN können Ihre Geräte auf das Internet zugreifen, sowie auf alle privaten Netzwerke, die mit dem Server verbunden sind.
Sie können sie über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

[WireGuard](https://www.wireguard.com/) ist eine sehr einfache, aber schnelle und moderne VPN-Lösung, die state-of-the-art Kryptographie verwendet. Es zielt darauf an, schneller, einfacher, schlanker und nützlicher als IPsec zu sein. Es ist außerdem wesentlich performanter als OpenVPN.

[WireGuard UI](https://github.com/ngoduykhanh/wireguard-ui) ist eine einfache, web-basierte Management-UI für WireGuard.

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

Nun, wo Sie die IP-Adressen wissen, die dem Server zugeordnet wurden, konfigurieren Sie die Domain, die Sie für die WireGuard App nutzen möchten, mit den folgenden DNS Einträgen:

- **A**-Record mit der IPv4-Adresse des Servers, falls vorhanden
- **AAAA**-Record mit der IPv6-Adresse des Servers, falls vorhanden

Möglicherweise müssen Sie ein paar Minuten warten, bis die DNS-Änderungen übernommen wurden.

Anschließend melden Sie sich bitte auf Ihrem server an:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

Dies führt Sie durch einen Prozess, wobei Sie Angaben wie die Domain und Admin-Zugangsdaten konfigurieren können, welche Sie anschließend nutzen können, um die Management-UI zu erreichen. TLS mittels Let's Encrypt wird automatisch für Sie konfiguriert.

Wenn Sie fertig sind, können Sie sich an der Management-UI anmelden und Ihre ersten WireGuard Clients anlegen.

Im untenstehenden Video wird der gesamte Prozess, vom Erstellen eines Servers in der Cloud Console, über das Konfigurieren von Domain und Admin-Passwort, bis hin zum Anlegen eines ersten Clients (siehe "[VPN-Clients verbinden](#vpn-clients-verbinden)"), Schritt für Schritt gezeigt.

<video src="https://user-images.githubusercontent.com/84835304/189129284-4b3792bb-41ea-48b2-8f95-55dec36ab8c8.mp4" width="100%" controls>
  Hetzner App WireGuard
</video>

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines Servers mit vorinstalliertem WireGuard auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cpx11", "image":"wireguard"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cpx11 --image wireguard
  ```

## VPN-Clients verbinden

Um einen neuen VPN-Client zu verbinden, sollten Sie zunächst einen neuen Client in der Management-UI anlegen. Sie müssen dazu nur das _Name_-Feld ausfüllen, die anderen können Sie auf ihrem Standardwert belassen.

**Wichtig:** Denken Sie immer daran, _Apply config_ zu klicken, nachdem Sie Clients hinzugefügt oder Änderungen in der Management-UI vorgenommen haben. Ansonsten werden sich die neuen Clients nicht verbinden können.

Nun können Sie den _QR code_-Button benutzen, um einen QR-Code zu generieren, welchen Sie mit der WireGuard App für [Android](https://play.google.com/store/apps/details?id=com.wireguard.android) oder [iOS](https://itunes.apple.com/us/app/wireguard/id1441195209?ls=1&mt=8) scannen können. Oder Sie nutzen _Download_, um eine Konfigurationsdatei herunterzuladen, welche Sie zum Verbinden eines PCs oder MACs nutzen können. [Hier](https://www.wireguard.com/install/) finden Sie eine Liste aller verfügbaren WireGuard Client-Anwendungen.

Die einzelnen Schritte zum Verbinden eines Clients können Sie sich zur Veranschaulichung auch im oberen Video ab 1:35 Minuten ansehen.

## Funktionsweise dieser App

### Reverse-Proxy

Diese App richtet als Reverse-Proxy automatisch einen Caddy Webserver mit automatischem HTTPS über Let's Encrypt ein. Die Konfiguration befindet sich unter `/etc/caddy/Caddyfile`. Aus diesem Grund ist WireGuard UI so konfiguriert, dass es nur lokal unter dem Port 5000 erreichbar ist.

### WireGuard-Konfiguration

Beim ersten Start, und jedes Mal, wenn in der Management-UI _Apply config_ betätigt wird, wird die WireGuard-Konfiguration unter `/etc/wireguard/wg0.conf` neugeschrieben. Es existiert eine `wg-quick-watcher@wg0.path` Systemd Unit, die jedes Mal, wenn die Konfiguration verändert wird, ein `systemctl restart wg-quick@wg0` auslöst. Auf diese Weise werden Änderungen angewendet.

Wenn Sie die `wg0.conf` manuell anpassen wollen, sollten Sie vorher WireGuard UI deaktivieren, um sicherzustellen, dass Ihre Anpassungen nicht überschrieben werden.

### Firewall

Während der Installation wird das IPv4- und IPv6-Forwarding im Kernel aktiviert. Um dieses mit einer Firewall einzuschränken, wird nftables verwendet.

Sie finden die Firewall- und NAT-Konfiguration unter `/etc/nftables.conf`. Änderungen können mit `systemctl restart nftables` angewendet werden.

## Passwort ändern

Das Benutzer-Passwort lässt sich über die Management-UI ändern, nachdem Sie eingeloggt sind und auf Ihren aktuellen Nutzernamen klicken. Falls Sie aber Ihr Passwort vergessen haben, oder eine ältere Version der App benutzen, folgen Sie bitte diesen Schritten:

1. Generieren Sie einen bcrypt Passwort-Hash für das neue Passwort. Sie können dafür die Caddy CLI benutzen:

   ```
   caddy hash-password --algorithm bcrypt | tr -d '\n' | base64 -w0 && echo
   ```

2. Bearbeiten Sie `/usr/local/share/wireguard-ui/db/server/users.json` und ersetzen Sie den `password_hash` mit dem soeben generierten, neuen Hash.
  - Bei neueren Versionen von wireguard-ui (seit v0.5.0) lautet der Pfad stattdessen `/usr/local/share/wireguard-ui/db/users/{username}.json`.

3. Starten Sie WireGuard UI neu:

   ```
   systemctl restart wireguard-ui
   ```

## Weitere Konfigurationsoptionen

Die meisten Konfigurationsoptionen sind über die Management-UI sichtbar und können dort angepasst werden. Einige weitere, sind aber nicht herausgeführt. Wenn Sie sich für diese interessieren, werfen Sie bitte einen Blick in die Datei `/etc/default/wireguard-ui`.

## Updates installieren

WireGuard und die WireGuard CLI-Tools können Sie regulär über `apt update` und `apt upgrade` aktualisieren. Für den Caddy Webserver und WireGuard UI reicht dies aber nicht aus, da diese manuell installiert sind.

Für Caddy können Sie die aktuellste `caddy_*_linux_amd64.tar.gz` von der [Release-Seite des Projektes](https://github.com/caddyserver/caddy/releases) herunterladen und wie folgt entpacken:

```
tar -C /usr/local/bin -xzf caddy_*_linux_amd64.tar.gz caddy
```

Um WireGuard UI zu aktualisieren, laden Sie bitte das neueste Release-Archiv von deren [Release-Seite](https://github.com/ngoduykhanh/wireguard-ui/releases) herunter und entpacken Sie die `wireguard-ui` Binärdatei nach `/usr/local/bin`, ähnlich wie oben gezeigt. Aufgrund von jüngsten Patches, die noch nicht in den offiziellen WireGuard UI Releases angekommen sind, finden Sie [hier](https://github.com/MarcusWichelmann/wireguard-ui/releases) möglicherweise aktuellere Builds. Wenn dies der Fall ist, nutzen Sie bitte diese.

Nachdem alles wieder auf dem neuesten Stand ist, können Sie die betroffenen Dienste neustarten:

```
systemctl restart wireguard-ui caddy
```

## Image-Inhalt

### Betriebssystem

- [x] Ubuntu 22.04

### Installierte Pakete

| NAME         | LIZENZ             |
| ------------ | ------------------ |
| WireGuard    | GPLv2              |
| WireGuard UI | MIT                |
| Caddy        | Apache License 2.0 |

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [WireGuard](https://www.wireguard.com/)
- [WireGuard UI](https://github.com/ngoduykhanh/wireguard-ui/blob/master/README.md)
- [Caddy](https://caddyserver.com/docs/)

- [Let’s Encrypt](https://letsencrypt.org/docs/)
- [nftables](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
