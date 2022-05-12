# Hetzner Cloud Docker

<img src="images/docker-logo.png" height="97px">

This app contains a ready to use Docker installation.
You can install it via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

[Docker](https://www.docker.com/) is an open source project that uses OS-level virtualization to deliver software in packages called containers. This app allows you to deploy applications in any environment.

## Getting started

Create your server on our [Hetzner Cloud Console](https://console.hetzner.cloud). Instead of an image, you will be able to choose the app that you would like to have preinstalled on your server.

Docker is preinstalled when the image is booted.

You can log into your server as usual:

- Via _SSH key_, if you selected one when you created the server
- Via _root password_, which will be mailed to you if you created a server without selecting an SSH key

## Hetzner Cloud API

In addition to the Hetzner Cloud Console you can also use the Hetzner Cloud API to set up a server with pre-installed Docker.

- For example with a curl command via CLI

  ```
  curl \
  	-X POST \
  	-H "Authorization: Bearer $API_TOKEN" \
  	-H "Content-Type: application/json" \
  	-d '{"name":"my-server", "server_type":"cx31", "image":"docker-ce"}' \
  	'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cx31 --image docker-ce
  ```

## Image content

### Base OS

- [x] Ubuntu 20.04

### Installed packages

| NAME   | LICENSE            |
| ------ | ------------------ |
| Docker | GPLv3 (Apache 2.0) |

## Links

For more information about the installed packages, please refer to their official documentation:

- [Docker](https://docs.docker.com/)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please refer to our official documentation:

- [Hetzner Cloud Documentation](https://docs.hetzner.com/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
