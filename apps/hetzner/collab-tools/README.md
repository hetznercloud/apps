# Hetzner Cloud Collaboration Tools

This app contains a collection of different collaboration tools.
You can install them via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

[![Deploy to Hetzner Cloud](../../shared/images/deploy_to_hetzner.png)](https://console.hetzner.cloud/deploy/collab-tools)

The collaboration collection consists of [Transfer](https://transfer.sh/), a file sharing service which can be used both via the web interface and via the command line, [HedgeDoc](https://hedgedoc.org/) which can be used as a Markdown editor for brainstorming by several people at the same time and [Whiteboard](https://github.com/cracker0dks/whiteboard) to document ideas graphically.

## Getting Started

Create your server as usual using the [Hetzner Cloud Console](https://console.hetzner.cloud). As an alternative to the operating system, you can choose an app that you would like to have pre-installed.

The collection is preinstalled on the server in the form of [Docker images](https://www.docker.com/), but it is not activated.

To activate the collection, please login to your server:

- By _SSH key_, if you provided one when you created your server.
- By _root password_, which you received from us by email when you created your server, if no SSH key was provided.

This will take you through a process whereby you can then use any services from the web, with automatic Let's Encrypt support.

## Hetzner Cloud API

Instead of the Hetzner Cloud Console, the Hetzner Cloud API can also be used to set up a server with all pre-installed collaboration tools.

- For example via curl command from the command line

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cpx21", "image":"collab-tools"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cpx21 --image collab-tools
  ```

## Image content

### Operating system

- [x] Ubuntu 22.04

### Installed packages

This image contains Docker and all other listed applications as Docker containers.

| NAME               | LICENSE            |
| ------------------ | ------------------ |
| Whiteboard         | MIT                |
| HedgeDoc           | AGPLv3             |
| Transfer           | MIT                |
| Docker             | GPLv3 (Apache 2.0) |
| Watchtower         | GPLv3 (Apache 2.0) |
| Caddy-docker-proxy | MIT                |
| PostgreSQL         | PostgreSQL Licence |

### Passwords

We use automatically generated passwords that are stored in the following folder:

```
/root/.hcloud_password
```

## Links

For more information about the installed packages, see the official documentation:

- [Whiteboard](https://github.com/cracker0dks/whiteboard)
- [HedgeDoc](https://hedgedoc.org/)
- [Transfer](https://transfer.sh/)
- [Docker](https://www.docker.com/)
- [Caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy/)
- [Watchtower](https://containrrr.dev/watchtower/)
- [PostgreSQL](https://www.postgresql.org/)

- [Let's Encrypt](https://letsencrypt.org/de/docs/)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please see our official documentation:

- [Hetzner Cloud Documentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
