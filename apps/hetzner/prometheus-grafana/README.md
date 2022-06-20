# Hetzner Cloud Prometheus Grafana

<img src="images/prometheus-grafana-logo.png" height="97px">

This app contains a ready Prometheus and Grafana installation.
You can install it via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

[Grafana](https://grafana.com/) is an open source software for visualization of metrics. These metrics are provided by the application [Prometheus](https://prometheus.io/).

## Getting Started

Create your server as usual via the [Hetzner Cloud Console](https://console.hetzner.cloud). As an alternative to the operating system, you can select an app that you would like to have pre-installed.

Grafana and Prometheus is pre-installed when the image is booted, but not activated.

To activate Prometheus and Grafana, please log in to your server:

- By _SSH-Key_, if you provided one when you created your server.
- By _root password_, which you received from us by email when you created your server, if no SSH key was provided.

This will take you through a process where you can then use Grafana as usual from the web, with automatic Let's Encrypt support. It is also possible to access Prometheus via Web afterwards as well, depending on the installation choices.

## Hetzner Cloud API

Instead of the Hetzner Cloud Console, the Hetzner Cloud API can also be used to set up a server with preinstalled Prometheus and Grafana.

- For example via curl command from the command line

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cpx21", "image":"prometheus-grafana"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cpx21 --image prometheus-grafana
  ```

## Image Content

### Base OS

- [x] Ubuntu 22.04

### Installed packages and containers

This image contains Docker and all other listed applications as Docker containers.

| NAME               | LICENSE             |
| ------------------ | ------------------- |
| Prometheus         | GGPLv3 (Apache 2.0) |
| Grafana            | AGPLv3              |
| Node-Exporter      | GPLv3 (Apache 2.0)  |
| Cadvisor           | GPLv3 (Apache 2.0)  |
| Docker             | GPLv3 (Apache 2.0)  |
| Watchtower         | GPLv3 (Apache 2.0)  |
| Caddy-docker-proxy | MIT                 |

### Passwords

We use auto-generated passwords which are stored in:

```
/root/.hcloud_password
```

## Useful Commands

### Reset your password

#### Grafana

In case of loss of the password for the user `admin` you can reset it via the `grafana-cli`. To do this, first log on to the server.
Then execute the following command on the server and enter the password you want:

```bash
docker exec -it grafana grafana-cli --homepath "/usr/share/grafana" admin reset-admin-password <password>
```

The password for the user `admin` has now been reset.

#### Prometheus

If you want to change the password for the Prometheus Basic Auth, you can first generate a new password hash with the following command.

```bash
docker exec -it caddy caddy hash-password -plaintext <password>
```

Then change the hash value for the variable `PROMETHEUS_ADMIN_PASSWORD` in the file `/opt/containers/prometheus-grafana/.env`. Now stop the caddy container and start it again to finish the password change.

```bash
docker compose -f /opt/containers/prometheus-grafana/docker-compose.yml stop caddy
docker compose -f /opt/containers/prometheus-grafana/docker-compose.yml start caddy
```

## Links

For more information about the installed packages and containers, please refer to their official documentation:

- [Grafana](https://grafana.com/)
- [Prometheus](https://prometheus.io/)
- [Node-Exporter](https://github.com/prometheus/node_exporter)
- [Cadvisor](https://github.com/google/cadvisor)
- [Caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy/)
- [Docker](https://www.docker.com/)
- [Watchtower](https://containrrr.dev/watchtower/)

- [Let’s Encrypt](https://letsencrypt.org/de/docs/)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please refer to our official documentation:

- [Hetzner Cloud Dokumentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
