# Hetzner Cloud Jitsi

<img src="images/jitsi-logo.png" height="97px">
<br>

This app contains a ready to use Jitsi installation.
You can install it via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

[![Deploy to Hetzner Cloud](../../shared/images/deploy_to_hetzner.png)](https://console.hetzner.cloud/deploy/jitsi)

[Jitsi](https://jitsi.org/) is a set of open source projects that allows you to easily build and deploy secure video conferencing solutions. At the heart of Jitsi are Jitsi Videobridge and Jitsi Meet, which let you have conferences on the internet.

## Getting started

Create your server on our [Hetzner Cloud Console](https://console.hetzner.cloud). Instead of an image, you will be able to choose the app that you would like to have preinstalled on your server.

Jitsi is preinstalled when the image is booted, but it is not enabled.

In order to enable Jitsi, first, please log into your server:

- Via _SSH key_, if you selected one when you created the server
- Via _root password_, which will be mailed to you if you created a server without selecting an SSH key

This will guide you through the process and give you additional Let's Encrypt support. If you choose to skip _Let's Encrypt_, you will still be able to activate it another time (see _Activate Let's Encrypt post installation_).

When you are done, you will be able to use Jitsi as usual from the web.

## Hetzner Cloud API

In addition to the Hetzner Cloud Console you can also use the Hetzner Cloud API to set up a server with pre-installed Jitsi.

- For example with a curl command via CLI

  ```
  curl \
  	-X POST \
  	-H "Authorization: Bearer $API_TOKEN" \
  	-H "Content-Type: application/json" \
  	-d '{"name":"my-server", "server_type":"cpx21", "image":"jitsi"}' \
  	'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cpx21 --image jitsi
  ```

## Activate Let's Encrypt post installation

Let’s Encrypt provides digital certificates that are needed to enable HTTPS (SSL/TLS) for websites.

To activate Let's Encrypt after the initial script has run, please run the following script:

```
/usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
```

It will configure Jitsi to use SSL and it will obtain a valid Let's Encrypt certificate.

## Image content

### Base OS

- [x] Ubuntu 24.04

### Installed packages

| NAME      | LICENSE            |
| --------- | ------------------ |
| Jitsi     | GPLv3 (Apache 2.0) |
| Nginx     | GPL (BSD)          |
| Certbot   | GPLv3 (Apache 2.0) |
| OpenJDK11 | GPL                |

## Links

For more information about the installed packages, please refer to their official documentation:

- [Jitsi](https://jitsi.github.io/handbook/docs/intro)
- [Nginx](http://nginx.org/en/docs/)
- [Certbot](https://certbot.eff.org/docs/)
- [OpenJDK8](https://openjdk.java.net/projects/jdk8/)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please refer to our official documentation:

- [Hetzner Cloud Documentation](https://docs.hetzner.com/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
