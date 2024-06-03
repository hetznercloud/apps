# Hetzner Cloud LAMP

<img src="images/lamp-logo.png" height="97px">
<br>

This app contains a ready to use LAMP installation.
You can install it via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

[![Deploy to Hetzner Cloud](../../shared/images/deploy_to_hetzner.png)](https://console.hetzner.cloud/deploy/lamp)

LAMP describes a system which provides a Linux based Apache web server with PHP and MySQL database. All four components are open source projects.

L - [Linux](https://www.kernel.org/) is the operating system.

A - [Apache](https://apache.org/) is the web server.

M - [MySQL](https://www.mysql.com/) is the database system.

P - [PHP](https://www.php.net/) is the programming language.

## Getting started

Create your server on our [Hetzner Cloud Console](https://console.hetzner.cloud). Instead of an image, you will be able to choose the app that you would like to have preinstalled on your server.

LAMP is preinstalled when the image is booted, but it is not enabled.

In order to enable LAMP, first, please log into your server:

- Via _SSH key_, if you selected one when you created the server
- Via _root password_, which will be mailed to you if you created a server without selecting an SSH key

This will guide you through the process and give you additional Let's Encrypt support. If you choose to skip _Let's Encrypt_, you will still be able to activate it another time (see _Activate Let's Encrypt post installation_).

## Hetzner Cloud API

In addition to the Hetzner Cloud Console you can also use the Hetzner Cloud API to set up a server with pre-installed LAMP stack.

- For example with a curl command via CLI

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cpx21", "image":"lamp"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cpx21 --image lamp
  ```

## Activate Let's Encrypt post installation

Let’s Encrypt provides digital certificates that are needed to enable HTTPS (SSL/TLS) for websites.

To activate Let's Encrypt after the initial script has run, please follow the steps below.

1. Run Certbot (preinstalled) with the Apache plugin

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

- [x] Ubuntu 24.04

### Installed packages

| NAME    | LICENSE            |
| ------- | ------------------ |
| Apache  | GPLv3 (Apache 2.0) |
| MySQL   | GPL                |
| PHP     | GPL (Expat)        |
| Certbot | GPL (Apache 2.0)   |
| Perl    | GPL                |

### Passwords

We use auto-generated passwords which are stored in:

```
/root/.hcloud_password
```

## Links

For more information about the installed packages, please refer to their official documentation:

- [Linux](https://www.kernel.org/doc/html/latest/) / [Ubuntu](https://help.ubuntu.com/?_ga=2.73622737.2143576050.1623226390-1046440168.1622099723)
- [Apache](https://cwiki.apache.org/confluence/display/httpd/FAQ)
- [MySQL](https://dev.mysql.com/doc/)
- [PHP](https://www.php.net/manual/en/)
- [Certbot](https://certbot.eff.org/docs/)
- [Perl](https://perldoc.perl.org/)

- [Let’s Encrypt](https://letsencrypt.org/docs/)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please refer to our official documentation:

- [Hetzner Cloud Documentation](https://docs.hetzner.com/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
