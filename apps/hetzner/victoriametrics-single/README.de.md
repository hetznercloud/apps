## Zusammenfassung der Anwendung

VictoriaMetrics ist eine schnelle und skalierbare Open-Source-Zeitreihendatenbank und Überwachungslösung.

## Beschreibung

VictoriaMetrics ist eine kostenlose [Open-Source-Zeitreihendatenbank](https://en.wikipedia.org/wiki/Time_series_database) (TSDB) und Überwachungslösung, die zum Sammeln, Speichern und Verarbeiten von Echtzeitmetriken entwickelt wurde.

Es unterstützt das Pull-Modell von [Prometheus](https://de.wikipedia.org/wiki/Prometheus_(Software)) und verschiedene Push-Protokolle ([Graphite](https://en.wikipedia.org/wiki/Graphite_(software)), [InfluxDB](https://de.wikipedia.org/wiki/InfluxDB), OpenTSDB) für die Datenaufnahme. Es ist für die Speicherung mit IO mit hoher Latenz, niedrigen IOPS und Zeitreihen mit [hoher Abwanderungsrate](https://docs.victoriametrics.com/FAQ.html#what-is-high-churn-rate) optimiert.

Zum Auslesen der Daten und Auswerten von Alerting-Regeln unterstützt VictoriaMetrics die PromQL, [MetricsQL](https://docs.victoriametrics.com/MetricsQL.html) und Graphite Abfragesprachen. VictoriaMetrics Single ist vollständig autonom und kann als Langzeitspeicher für Zeitreihen verwendet werden.

VictoriaMetrics Single = Problemlose Überwachungslösung. Es verarbeitet problemlos über 10 Millionen aktiver Zeitreihen in einer einzigen Instanz. Es ist perfekt für kleine und mittlere Umgebungen.

## Erste Schritte nach der Bereitstellung von VictoriaMetrics Single

### Konfiguration

Die VictoriaMetrics-Konfiguration befindet sich unter /etc/victoriametrics/single/scrape.yml auf dem Droplet. Diese One Click App verwendet die Ports 8428, 2003, 4242 und 8089, um Metriken von verschiedenen Protokollen zu akzeptieren. Es wird empfohlen, Ports für Protokolle, die nicht benötigt werden, zu deaktivieren. Die [Ubuntu-Firewall](https://help.ubuntu.com/community/UFW) kann verwendet werden, um den Zugriff auf bestimmte Ports einfach zu deaktivieren.

### Scraping von Metriken

VictoriaMetrics unterstützt das Scraping von Metriken auf dieselbe Weise wie Prometheus. Überprüfen Sie die Konfigurationsdatei, um Scraping-Ziele zu bearbeiten. Weitere Details zum Scraping finden Sie unter Wie man Prometheus-Exporteure scrapen kann.

### Senden von Metriken

Neben Scraping akzeptiert VictoriaMetrics auch Schreibanfragen für verschiedene Ingestion-Protokolle. Diese One Click App unterstützt die folgenden Protokolle:

- [Datadog](https://docs.victoriametrics.com/Single-server-VictoriaMetrics.html#how-to-send-data-from-datadog-agent), 
- [Influx (telegraph)](https://docs.victoriametrics.com/Single-server-VictoriaMetrics.html#how-to-send-data-from-influxdb-compatible-agents-such-as-telegraf), [JSON](https://docs.victoriametrics.com/Single-server-VictoriaMetrics.html#how-to-import-data-in-json-line-format), [CSV](https://docs.victoriametrics.com/Single-server-VictoriaMetrics.html#how-to-import-csv-data), [Prometheus](https://docs.victoriametrics.com/Single-server-VictoriaMetrics.html#how-to-import-data-in-prometheus-exposition-format) auf Port :8428
- [Graphite (statsd)](https://docs.victoriametrics.com/Single-server-VictoriaMetrics.html#how-to-send-data-from-graphite-compatible-agents-such-as-statsd) :2003 tcp/udp
- [OpenTSDB](https://docs.victoriametrics.com/Single-server-VictoriaMetrics.html#how-to-send-data-from-opentsdb-compatible-agents) :4242
- Influx (telegraph) auf Anschluss :8089 tcp/udp
Weitere Details und Beispiele finden Sie in der offiziellen Dokumentation.

### UI

VictoriaMetrics bietet eine Benutzeroberfläche (UI) für die Fehlersuche und Erkundung von Abfragen. Die Benutzeroberfläche ist verfügbar unter `http://your_droplet_public_ipv4:8428/vmui`. Sie ermöglicht es den Benutzern, Abfrageergebnisse über Diagramme und Tabellen zu untersuchen.

Um es zu überprüfen, öffnen Sie die folgende Seite in Ihrem Browser `http://your_droplet_public_ipv4:8428/vmui` und geben Sie dann `vm_app_uptime_seconds` in das Abfragefeld ein, um die Abfrage auszuführen.

Führen Sie den folgenden Befehl aus, um ein Ergebnis von VictoriaMetrics Single mit curl abzufragen und abzurufen:

```bash
curl -sg http://your_droplet_public_ipv4:8428/api/v1/query_range?query=vm_app_uptime_seconds | jq
```

### Zugriff auf
Sobald der Cloud-Server erstellt ist, können Sie die Webkonsole von Hetzner verwenden, um eine Sitzung zu starten, oder sich per SSH direkt als root auf den Server einwählen:

```bash
ssh root@dein_droplet_public_ipv4
```