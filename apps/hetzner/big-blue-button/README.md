# Hetzner Cloud BigBlueButton

<img src="images/BigBlueButton_logo.svg.png" height="97px">

This app contains a ready to use BigBlueButton installation with Greenlight 2.0 User-Interface.
You can install it via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

[BigBlueButton](https://bigbluebutton.org/) is a global teaching platform that can be used for web conferences. It was developed in a school and is the only virtual classroom built from the ground up, just for teachers. It’s available in 65 languages and teachers all over the world have contributed to its design.

## Getting started

Create your server on our [Hetzner Cloud Console](https://console.hetzner.cloud). Instead of an image, you will be able to choose the app that you would like to have preinstalled on your server.

BigBlueButton is preinstalled when the image is booted, but it is not enabled.

In order to enable BigBlueButton, first, please log into your server:

- Via _SSH key_, if you selected one when you created the server
- Via _root password_, which will be mailed to you if you created a server without selecting an SSH key

This will guide you through the process and give you additional Let's Encrypt support. If you choose to skip _Let's Encrypt_, you will still be able to activate it another time (see _Activate Let's Encrypt post installation_).

When you are done, you will be able to use BigBlueButton as usual from the web.

## Hetzner Cloud API

In addition to the Hetzner Cloud Console you can also use the Hetzner Cloud API to set up a server with pre-installed BigBlueButton.

- For example with a curl command via CLI

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"my-server", "server_type":"cx31", "image":"big-blue-button"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cx31 --image big-blue-button
  ```

## BigBlueButton Recording

BigBlueButton offers a function to record and playback meetings. This function is enabled by default.

Please note that this function can take a lot of storage capacity.

To play and delete your recordings, go to the **All Recordings** tab of the User Interface.

To delete them via CLI, please use the commands below.

1. List all recordings

   ```
   bbb-record --list
   ```

2. Delete a specific recording

   ```
   bbb-record --delete 6e35e3b2778883f5db637d7a5dba0a427f692e91-1379965122603
   ```

3. Delete all recordings at once

   ```
   bbb-record --deleteall
   ```

## Activate Let's Encrypt post installation

Let’s Encrypt provides digital certificates that are needed to enable HTTPS (SSL/TLS) for websites.

Important note: Self-signed certificates will not work well with BigBlueButton. We recommend using Let's Encrypt.

To activate Let's Encrypt after the initial script has run, please follow the steps below.

1. Run Certbot (preinstalled) with the Nginx plugin

   ```
   certbot --nginx
   ```

   It will guide you through the process of obtaining a valid SSL certificate.

2. Restart BBB (BigBlueButton)

   ```
   bbb-conf --restart
   ```

## Image content

### Base OS

- [x] Ubuntu 18.04

### Installed packages

| NAME          | LICENSE            |
| ------------- | ------------------ |
| BigBlueButton | LGPL               |
| Docker CE     | GPLv3 (Apache-2.0) |
| Nginx         | GPL (BSD)          |
| OpenJDK8      | GPL                |
| Haveged       | GPL                |
| Certbot       | GPLv3 (Apache-2.0) |

### Passwords

We use auto-generated passwords which are stored in:

```
/root/.hcloud_password
```

## Links

For more information about the installed packages, please refer to their official documentation:

- [BigBlueButton](https://docs.bigbluebutton.org/)
- [Nginx](http://nginx.org/en/docs/)
- [Certbot](https://certbot.eff.org/docs/)
- [OpenJDK8](https://openjdk.java.net/projects/jdk8/)
- [Haveged](https://www.issihosts.com/haveged/index.html)

- [Let’s Encrypt](https://letsencrypt.org/docs/)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please refer to our official documentation:

- [Hetzner Cloud Documentation](https://docs.hetzner.com/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
