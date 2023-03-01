# Hetzner Cloud RustDesk

[RustDesk](https://github.com/rustdesk/rustdesk/) turns your server into a ready-to-go remote desktop server that works out of the box, no configuration required.
You have full control of your data, with no concerns about security.

You can install RustDesk via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

## Getting Started

Create your server as usual using the [Hetzner Cloud Console](https://console.hetzner.cloud). As an alternative to the operating system, you can choose an app that you would like to have pre-installed.

The collection is preinstalled on the server in the form of [Docker images](https://www.docker.com/), but it is not activated.

To activate the collection, please login to your server:

- By _SSH key_, if you provided one when you created your server.
- By _root password_, which you received from us by email when you created your server, if no SSH key was provided.

This will take you through a process whereby you can then use any services from the web, with automatic Let's Encrypt support.

## Hetzner Cloud API

Instead of the Hetzner Cloud Console, the Hetzner Cloud API can also be used to set up a server with RustDesk.

- For example via curl command from the command line

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name": "my-rustdesk-server", "server_type": "cpx21", "image": "rustdesk"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-rustdesk-server --type cpx21 --image rustdesk
  ```

## Image content

### Operating system

- [x] Ubuntu 22.04

### Installed packages

This image contains Docker and all other listed applications as Docker containers.

| NAME       | LICENSE            |
| ---------- | ------------------ |
| Docker     | GPLv3 (Apache 2.0) |
| RustDesk   | AGPLv3             |
| Watchtower | GPLv3 (Apache 2.0) |

### Passwords

You can find your RustDesk API key at:

```
/opt/containers/rustdesk/data/id_ed25519.pub
```

## Links

For more information about the installed packages, see the official documentation:

- [Docker](https://www.docker.com/)
- [RustDesk](https://github.com/rustdesk/rustdesk/)
- [Watchtower](https://containrrr.dev/watchtower/)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please see our official documentation:

- [Hetzner Cloud Documentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
