# Hetzner Cloud PhotoPrism

<img src="images/photoprism-logo.png" height="100px">
<br>

[PhotoPrism](https://github.com/photoprism/photoprism/) turns your server into a ready-to-go photo solution with AI functionality.
It uses the latest technologies to automatically tag and find images without getting in your way.

You can install PhotoPrism via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

[![Deploy to Hetzner Cloud](../../shared/images/deploy_to_hetzner.png)](https://console.hetzner.cloud/deploy/photoprism)

## Getting Started

Create your server as usual using the [Hetzner Cloud Console](https://console.hetzner.cloud). As an alternative to the operating system, you can choose an app that you would like to have pre-installed.

The collection is preinstalled on the server in the form of [Docker images](https://www.docker.com/), but it is not activated.

To activate the collection, please login to your server:

- By _SSH key_, if you provided one when you created your server.
- By _root password_, which you received from us by email when you created your server, if no SSH key was provided.

This will take you through a process whereby you can then use any services from the web, with automatic Let's Encrypt support.

After successful setup, the generated account details will be printed to your console. For reference, the admin user name by default is `photos_admin`.

## Hetzner Cloud API

Instead of the Hetzner Cloud Console, the Hetzner Cloud API can also be used to set up a server with PhotoPrism.

- For example via curl command from the command line

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-photoprism-server", "server_type":"cpx21", "image":"photoprism"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-photoprism-server --type cpx21 --image photoprism
  ```

## Image content

### Operating system

- [x] Ubuntu 24.04

### Installed packages

This image contains Docker and all other listed applications as Docker containers.

| NAME       | LICENSE            |
| ---------- | ------------------ |
| Docker     | GPLv3 (Apache 2.0) |
| PhotoPrism | AGPLv3             |
| MariaDB    | GPLv2              |
| Traefik    | MIT                |
| Watchtower | GPLv3 (Apache 2.0) |

### Passwords

We use automatically generated passwords that are stored in the following folder:

```
/root/.hcloud_password
```

The PhotoPrism admin user name is `photos_admin` by default.

## Links

For more information about the installed packages, see the official documentation:

- [Docker](https://www.docker.com/)
- [PhotoPrism](https://github.com/photoprism/photoprism/)
- [MariaDB](https://mariadb.com)
- [Traefik](https://github.com/traefik/traefik/)
- [Watchtower](https://containrrr.dev/watchtower/)
- [Let's Encrypt](https://letsencrypt.org/de/docs/)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please see our official documentation:

- [Hetzner Cloud Documentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
