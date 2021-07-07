# Hetzner Cloud GitLab

<img src="images/gitlab-logo.png" height="97px">

This app contains a ready to use GitLab installation.
You can install it via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

[GitLab](https://about.gitlab.com/) is an open-source DevOps platform. Its mission is to help teams collaborate on software development and to provide a place where everyone can contribute. This app allows you to manage changes to documents and more.

## Getting started

Create your server on our [Hetzner Cloud Console](https://console.hetzner.cloud). Instead of an image, you will be able to choose the app that you would like to have preinstalled on your server.

GitLab is preinstalled when the image is booted, but it is not enabled.

In order to enable GitLab, first, please log into your server:

- Via _SSH key_, if you selected one when you created the server
- Via _root password_, which will be mailed to you if you created a server without selecting an SSH key

This will guide you through the process and give you additional Let's Encrypt support. If you choose to skip _Let's Encrypt_, you will still be able to activate it another time (see _Activate Let's Encrypt post installation_).

When you are done, you will be able to use GitLab as usual from the web.

## Hetzner Cloud API

In addition to the Hetzner Cloud Console you can also use the Hetzner Cloud API to set up a server with pre-installed GitLab.

- For example with a curl command via CLI

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cx31", "image":"gitlab"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cx31 --image gitlab
  ```

## Activate Let's Encrypt post installation

Let’s Encrypt provides digital certificates that are needed to enable HTTPS (SSL/TLS) for websites.

To activate Let's Encrypt after the initial script has run, please follow the steps below.

1. Change the `external_url` value in

   ```
   /etc/gitlab/gitlab.rb
   ```

   from `http://[your-domain]` to `https://[your-domain]`

   You can use your favorite text editor to change the value (e.g. Vim).

2. Reconfigure Gitlab

   ```
   gitlab-ctl reconfigure
   ```

   Gitlab will change everything to SSL and obtain a valid Let's Encrypt certificate.

## Image content

### Base OS

- [x] Ubuntu 20.04

### Installed packages

This image contains Postfix and Perl as packages and GitLab from source.

| NAME    | LICENSE            |
| ------- | ------------------ |
| GitLab  | GPL (Expat)        |
| Perl    | GPL                |
| Postfix | GPL (EPL2)         |
| Apache  | GPLv3 (Apache 2.0) |

### Passwords

We use auto-generated passwords which are stored in:

```
/root/.hcloud_password
```

## Links

For more information about the installed packages, please refer to their official documentation:

- [GitLab](https://docs.gitlab.com/)
- [Perl](https://perldoc.perl.org/)
- [Postfix](http://www.postfix.org/documentation.html)
- [Apache](https://cwiki.apache.org/confluence/display/httpd/FAQ)

- [Let’s Encrypt](https://letsencrypt.org/de/docs/)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please refer to our official documentation:

- [Hetzner Cloud Documentation](https://docs.hetzner.com/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
