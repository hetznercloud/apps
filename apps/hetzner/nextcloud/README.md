# Hetzner Cloud Nextcloud

<img src="images/nextcloud-logo.png" height="97px">

This app contains a ready to use Nextcloud installation.
You can install it via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

[Nextcloud](https://nextcloud.com/) combines the convenience and ease of use of consumer-grade solutions like Dropbox and Google Drive with the security, privacy and control business needs. It is a self-hosted productivity platform that allows you to store files on your own server (file hosting) and more.

## Getting started

Create your server on our [Hetzner Cloud Console](https://console.hetzner.cloud). Instead of an image, you will be able to choose the app that you would like to have preinstalled on your server.

Nextcloud is preinstalled when the image is booted, but it is not enabled.

In order to enable Nextcloud and create your admin user, first, please log into your server:

- Via _SSH key_, if you selected one when you created the server
- Via _root password_, which will be mailed to you if you created a server without selecting an SSH key

This will guide you through the process and give you additional Let's Encrypt support. If you choose to skip _Let's Encrypt_, you will still be able to activate it another time (see _Activate Let's Encrypt post installation_).

When you are done, you will be able to use Nextcloud as usual from the web.

## Hetzner Cloud API

In addition to the Hetzner Cloud Console you can also use the Hetzner Cloud API to set up a server with pre-installed Nextcloud.

- For example with a curl command via CLI

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cx31", "image":"nextcloud"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cx31 --image nextcloud
  ```

## Activate Let's Encrypt post installation

Let’s Encrypt provides digital certificates that are needed to enable HTTPS (SSL/TLS) for websites.

To activate Let's Encrypt after the initial script has run, please follow the steps below.

1. Run Certbot (preinstalled) with the Apache plugin
   `

   ```
   certbot --apache
   ```

   It will guide you through the process of obtaining a valid SSL certificate.

2. Restart Apache

   ```
   systemctl restart apache2
   ```

## Image content

### Base OS

- [x] Ubuntu 20.04

### Installed packages

This image contains Apache, MySQL and PHP as packages and Nextcloud from source.

| NAME      | LICENSE            |
| --------- | ------------------ |
| Nextcloud | AGPLv3             |
| Apache    | GPLv3 (Apache 2.0) |
| MySQL     | GPL                |
| PHP       | GPL (Expat)        |
| Certbot   | GPL (Apache 2.0)   |

### Passwords

We use auto-generated passwords which are stored in:

```
/root/.hcloud_password
```

## Links

For more information about the installed packages, please refer to their official documentation:

- [Nextcloud](https://nextcloud.com/support/)
- [Apache](https://cwiki.apache.org/confluence/display/httpd/FAQ)
- [MySQL](https://dev.mysql.com/doc/)
- [PHP](https://www.php.net/manual/en/)
- [Certbot](https://certbot.eff.org/docs/)

- [Let’s Encrypt](https://letsencrypt.org/docs/)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please refer to our official documentation:

- [Hetzner Cloud Documentation](https://docs.hetzner.com/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
