# Hetzner Cloud GitLab

<img src="images/gitlab-logo.png" height="97px">
<br>

Diese App enthält eine fertige GitLab-Installation.
Sie können sie über die [Hetzner Cloud Console](https://console.hetzner.cloud) oder die [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server) installieren.

[GitLab](https://about.gitlab.com/) ist eine Open-Source DevOps-Plattform. Ziel der Anwendung ist es die Zusammenarbeit bei der Softwareentwicklung in Teams zu vereinfachen und einen Ort zur Verfügung zu stellen, an dem jeder etwas zum Projekt beitragen kann. Mit dieser App ist es unter anderem möglich Änderungen an Dokumenten oder Dateien zu erfassen.

## Getting Started

Erstellen Sie sich Ihren Server wie gewohnt über die [Hetzner Cloud Console](https://console.hetzner.cloud). Alternativ zum Betriebssystem können Sie eine App wählen, die Sie gerne vorinstalliert hätten.

GitLab ist vorinstalliert, wenn das Image gebootet wird, aber nicht aktiviert.

Um GitLab zu aktivieren, melden Sie sich bitte auf Ihrem Server an:

- Per _SSH-Key_, falls Sie beim Erstellen Ihres Servers einen angegeben haben
- Per _root-Passwort_, das Sie beim Erstellen Ihres Servers per E-Mail von uns erhalten haben, wenn kein SSH-Key angegeben wurde

Dies führt Sie durch den Prozess, ermöglicht zusätzliche Let's Encrypt-Unterstützung und anschließend können Sie GitLab wie gewohnt aus dem Web nutzen. Sollten Sie _Let's Encrypt_ beim ersten Mal anmelden überspringen, ist es später immer noch möglich das Zertifikat zu aktivieren (siehe _Let's Encrypt nachträglich aktivieren_).

## Hetzner Cloud API

Anstelle der Hetzner Cloud Console kann zum Einrichten eines Servers mit vorinstalliertem GitLab auch die Hetzner Cloud API genutzt werden.

- Zum Beispiel per Curl-Befehl über die Kommandozeile

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cx31", "image":"gitlab"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Oder über [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cx31 --image gitlab
  ```

## Let's Encrypt nachträglich aktivieren

Let’s Encrypt stellt kostenfrei digitale Zertifikate zur Verfügung. Diese werden auf Webseiten zur Aktivierung von HTTPS (SSL/TLS) benötigt.

Um Let's Encrypt nachträglich zu aktivieren, führen Sie bitte folgende Schritte aus:

1. Ändern Sie `external_url` in

   ```
   /etc/gitlab/gitlab.rb
   ```

   von `http://[Domain]` zu `https://[Domain]`

   Nutzen Sie dafür einen beliebigen Text-Editor (z.B. Vim).

2. GitLab neu konfigurieren

   ```
   gitlab-ctl reconfigure
   ```

Gitlab stellt automatisiert alles auf SSL um und bezieht ein gültiges Let's Encrypt Zertifikat.

## Image Inhalt

### Betriebssystem

- [x] Ubuntu 20.04

### Installierte Pakete

Dieses Image enthält Postfix und Perl als Pakete und GitLab aus dem Quellcode.

| NAME    | LIZENZ             |
| ------- | ------------------ |
| GitLab  | GPL (Expat)        |
| Perl    | GPL                |
| Postfix | GPL (EPL2)         |
| Apache  | GPLv3 (Apache 2.0) |

### Passwörter

Wir verwenden automatisch generierte Passwörter, die im folgenden Ordner gespeichert werden:

```
/root/.hcloud_password
```

## Links

Weitere Informationen über die installierten Pakete erhalten Sie in den offiziellen Dokumentationen:

- [GitLab](https://docs.gitlab.com/)
- [Perl](https://perldoc.perl.org/)
- [Postfix](http://www.postfix.org/documentation.html)
- [Apache](https://cwiki.apache.org/confluence/display/httpd/FAQ)

- [Let’s Encrypt](https://letsencrypt.org/de/docs/)

Weitere Informationen über Hetzner Cloud und Hetzner Cloud Apps erhalten Sie in unserer offiziellen Dokumentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
