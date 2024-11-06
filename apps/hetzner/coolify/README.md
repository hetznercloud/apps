# Hetzner Cloud Coolify

<img src="images/coolify-logo.png" height="100px">
<br>

[Coolify](https://coolify.io/) turns your server into an open-source & self-hostable Heroku / Netlify / Vercel alternative.

[![Deploy to Hetzner Cloud](../../shared/images/deploy_to_hetzner.png)](https://console.hetzner.cloud/deploy/coolify)

You can install Coolify via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

## Getting Started

Create your server as usual using the [Hetzner Cloud Console](https://console.hetzner.cloud). As an alternative to the operating system, you can choose an app that you would like to have pre-installed.

Coolify will then be preinstalled on the server, but it will not yet be activated.

To activate Coolify, please log in to your server:

- Use an _SSH key_ if you were provided one when you created your server.
- Use the _root-password_ which we sent to you via email when you created your server; use this if you did not get an SSH key.

This will activate Coolify and display the URL of the administration interface.

## Hetzner Cloud API

Instead of using the Hetzner Cloud Console, you can use the Hetzner Cloud API to set up a server with Coolify.

- For example, via a curl command from the command line:

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-coolify-server", "server_type":"cpx11", "image":"coolify"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-coolify-server --type cpx11 --image coolify
  ```

## Image content

### Operating system

- [x] Ubuntu 24.04

### Installed packages

This image contains Docker and all other listed applications as Docker containers.

| NAME       | LICENSE            |
| ---------- | ------------------ |
| Docker     | GPLv3 (Apache 2.0) |
| Coolify    | AGPLv3             |

## Links

For more information about the installed packages, see the official documentation:

- [Docker](https://www.docker.com/)
- [Coolify](https://coolify.io/docs/)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please see our official documentation:

- [Hetzner Cloud Documentation](https://docs.hetzner.com/de/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
