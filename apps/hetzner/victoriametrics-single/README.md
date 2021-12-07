## Application summary

VictoriaMetrics is a fast and scalable open source time series database and monitoring solution.

## Description

VictoriaMetrics is a free [open source time series database](https://en.wikipedia.org/wiki/Time_series_database) (TSDB) and monitoring solution, designed to collect, store and process real-time metrics. 

It supports the [Prometheus](https://en.wikipedia.org/wiki/Prometheus_(software)) pull model and various push protocols ([Graphite](https://en.wikipedia.org/wiki/Graphite_(software)), [InfluxDB](https://en.wikipedia.org/wiki/InfluxDB), OpenTSDB) for data ingestion. It is optimized for storage with high-latency IO, low IOPS and time series with [high churn rate](https://docs.victoriametrics.com/FAQ.html#what-is-high-churn-rate). 

For reading the data and evaluating alerting rules, VictoriaMetrics supports the PromQL, [MetricsQL](https://docs.victoriametrics.com/MetricsQL.html) and Graphite query languages. VictoriaMetrics Single is fully autonomous and can be used as a long-term storage for time series.

[VictoriaMetrics Single](https://docs.victoriametrics.com/Single-server-VictoriaMetrics.html) = Hassle-free monitoring solution. Easily handles 10M+ of active time series on a single instance. Perfect for small and medium environments.

## Getting started after deploying VictoriaMetrics Single

This One Click app uses 8424, 2003, 4242 and 8089 ports to accept metrics from different protocols. 

VictoriaMetrics provides a [User Interface](https://docs.victoriametrics.com/Single-server-VictoriaMetrics.html#vmui) (UI) for query troubleshooting and exploration. The UI is available at `http://your_server_public_ipv4:8428/vmui`. The UI lets users explore query results via graphs and tables.

Run the following command to query and retrieve a result from VictoriaMetrics:

```bash
curl -sg http://your_server_public_ipv4:8428/api/v1/query_range?query=vm_app_uptime_seconds | jq
```

You can open in browser `http://your_server_public_ipv4:8428/vmui` , enter `vm_app_uptime_seconds` to the Query Field and Execute Query.

Once the Server is created, you can use web console to start a session or you can SSH directly to the server as root:

```bash
ssh root@your_server_public_ipv4
```

VictoriaMetrics is configured via a config file which is located at `/etc/victoriametrics/single/scrape.yml` on the droplet. Feel free to edit and add new targets for scraping. 

It's recommended to disable ports for protocols which are not needed. [Ubuntu firewall](https://help.ubuntu.com/community/UFW) can be used to easily disable access for specific ports.

For further documentation visit: https://docs.victoriametrics.com/Single-server-VictoriaMetrics.html#how-to-start-victoriametrics