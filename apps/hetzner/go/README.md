# Hetzner Cloud Go

> Starting on 5 June 2024, this App will be deprecated. Starting on 5 July 2024, this App will no longer be available.
> If you want to use it after that, you can create your own App template snapshot as described [here](https://github.com/hetznercloud/apps?tab=readme-ov-file#development)

<img src="images/go-logo.png" height="97px">
<br>

This app contains a ready to use Go installation.
You can install it via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

[![Deploy to Hetzner Cloud](../../shared/images/deploy_to_hetzner.png)](https://console.hetzner.cloud/deploy/go)

[Go](https://go.dev/) is an open source programming language that makes it easy to build simple, reliable, and efficient software.

## Getting started

Create your server on our [Hetzner Cloud Console](https://console.hetzner.cloud). Instead of an image, you will be able to choose the app that you would like to have preinstalled on your server.

Go is preinstalled when the image is booted.

You can log into your server as usual:

- Via _SSH key_, if you selected one when you created the server
- Via _root password_, which will be mailed to you if you created a server without selecting an SSH key

## Hetzner Cloud API

In addition to the Hetzner Cloud Console you can also use the Hetzner Cloud API to set up a server with pre-installed Go.

- For example with a curl command via CLI

  ```
  curl \
  	-X POST \
  	-H "Authorization: Bearer $API_TOKEN" \
  	-H "Content-Type: application/json" \
  	-d '{"name":"my-server", "server_type":"cpx21", "image":"go"}' \
  	'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cpx21 --image go
  ```

## Image content

### Base OS

- [x] Ubuntu 22.04

### Installed packages

| NAME | LICENSE      |
| ---- | ------------ |
| Go   | 3-clause BSD |

## Links

For more information about the installed packages, please refer to their official documentation:

- [Go](https://go.dev/)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please refer to our official documentation:

- [Hetzner Cloud Documentation](https://docs.hetzner.com/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
