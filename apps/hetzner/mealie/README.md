# Hetzner Cloud Mealie

With this app, your server becomes a self-hosted recipe manager and meal planner with a RestAPI backend and a reactive frontend application built in Vue for a pleasant user experience for the whole family.

You can install Mealie via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

## Getting Started

Create your server as usual using the [Hetzner Cloud Console](https://console.hetzner.cloud). As an alternative to the operating system, you can choose an app that you would like to have pre-installed.

The collection is preinstalled on the server in the form of [Docker images](https://www.docker.com/), but it is not activated.

To activate the collection, please login to your server:

- By _SSH key_, if you provided one when you created your server.
- By _root password_, which you received from us by email when you created your server, if no SSH key was provided.

This will take you through a process whereby you can then use any services from the web, with automatic Let's Encrypt support.

## Hetzner Cloud API

Instead of the Hetzner Cloud Console, the Hetzner Cloud API can also be used to set up a server with Mealie.

- For example via curl command from the command line

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name": "my-mealie-server", "server_type": "cpx11", "image": "mealie"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-mealie-server --type cpx11 --image mealie
  ```

## Image content

### Operating system

- [x] Ubuntu 22.04

### Installed packages

This image contains Docker and all other listed applications as Docker containers.

| NAME       | LICENSE            |
| ---------- | ------------------ |
| Docker     | GPLv3 (Apache 2.0) |
| Mealie     | AGPLv3             |
| Traefik    | MIT                |
| Watchtower | GPLv3 (Apache 2.0) |

### Passwords

The email of the superuser is specified during installation.
The password for this user is `MyPassword`.
Please change this password immediately after installation.

## Configuration

In order to use the mail dispatch an SMTP server is needed.
The access data to your mail server can be changed in the file `/opt/containers/mealie/docker-compose.yml`.

## Updating

The version of the Mealie container can be changed with the variable `MEALIE_VERSION` in the file `/opt/containers/mealie/.env`.
Afterwards, the containers must be restarted with the command `docker compose down && docker compose up -d`.

## Links

For more information about the installed packages, see the official documentation:

- [Docker](https://www.docker.com/)
- [Mealie](https://github.com/hay-kot/mealie/)
- [Traefik](https://github.com/traefik/traefik/)
- [Watchtower](https://containrrr.dev/watchtower/)
- [Let's Encrypt](https://letsencrypt.org/de/docs/)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please see our official documentation:

- [Hetzner Cloud Documentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
