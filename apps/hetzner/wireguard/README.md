# Hetzner Cloud WireGuard

<img src="images/wireguard-logo.png" height="100px">
<br>

With this app, your server becomes a ready to use WireGuard VPN server, combined with a webinterface to manage it. Through this VPN, your devices can reach the internet as well as all private networks connected to the server.
You can install it via the [Hetzner Cloud Console](https://console.hetzner.cloud) or the [Hetzner Cloud API](https://docs.hetzner.cloud/#servers-create-a-server).

[WireGuard](https://www.wireguard.com/) is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography. It aims to be faster, simpler, leaner, and more useful than IPsec, while avoiding the massive headache. It intends to be considerably more performant than OpenVPN.

[WireGuard UI](https://github.com/ngoduykhanh/wireguard-ui) is a simple, web-based management UI for WireGuard.

## Getting Started

Create your server as usual using the [Hetzner Cloud Console](https://console.hetzner.cloud). As an alternative to the operating system, you can choose an app that you would like to have pre-installed.

Now, that you know, which IP addresses are assigned to your server, configure a domain with the following DNS records, so you can use it for this WireGuard app:

- **A** record with the IPv4 address of the server, if it has one
- **AAAA** record with the IPv6 address of the server, if it has one

You may need to wait a few minutes until the DNS changes are propagated.

After that, please login to your server:

- By _SSH key_, if you provided one when you created your server.
- By _root password_, which you received from us by email when you created your server, if no SSH key was provided.

This will guide you through a process where you can configure the domain and admin credentials, that you can later use to reach the management UI. TLS will be automatically set up using Let's Encrypt.

When you are done, you will be able to login to the management UI and configure the first WireGuard clients.

Check out the video below to see the entire process, from creating a server via Cloud Console to configuring the domain and admin password via a CLI. It also shows how to configure the first client (see "[Connecting VPN clients](#connecting-vpn-clients)").

<video src="https://user-images.githubusercontent.com/84835304/189336266-c34aa7c6-a6ea-4809-b72e-78bcd5afe1d6.mp4" width="100%" controls>
  Hetzner App WireGuard
</video>

## Hetzner Cloud API

Instead of the Hetzner Cloud Console, the Hetzner Cloud API can also be used to set up a server with pre-installed WireGuard.

- For example via curl command from the command line

  ```
  curl \
     -X POST \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name": "my-server", "server_type":"cpx11", "image":"wireguard"}' \
     'https://api.hetzner.cloud/v1/servers'
  ```

- Or via [hcloud-cli](https://github.com/hetznercloud/cli)

  ```
  hcloud server create --name my-server --type cpx11 --image wireguard
  ```

## Connecting VPN clients

To connect a new client, you should create a new client in the management UI first. Only the _Name_ field needs to be filled in, the others can be left untouched.

**Important:** Always remember to click _Apply config_ after adding clients or doing changes in the management UI. Otherwise new clients won't be able to connect.

Now you can use the _QR code_ button to generate a QR code, which can be scanned with the WireGuard app for [Android](https://play.google.com/store/apps/details?id=com.wireguard.android) or [iOS](https://itunes.apple.com/us/app/wireguard/id1441195209?ls=1&mt=8). Or you _Download_ the client config, to connect from a PC or Mac. You can find a list of all available WireGuard clients [here](https://www.wireguard.com/install/).

For a quick demonstration, take a look at the video above. Starting at 1:35 minutes, it will guide you through the steps to connect your first client.

## How this app works

### Reverse proxy

This app automatically sets up a Caddy webserver as reverse proxy with automatic HTTPS using Let's Encrypt. You can find its configuration at `/etc/caddy/Caddyfile`. That's why WireGuard UI is configured to only bind locally on port 5000.

### WireGuard config

On first start, and each time the _Apply config_ button in the management UI is clicked, the WireGuard configuration at `/etc/wireguard/wg0.conf` is rewritten. There is a `wg-quick-watcher@wg0.path` systemd unit, that triggers a `systemctl restart wg-quick@wg0` each time, the WireGuard config file is modified. That's how changes get applied.

If you want to modify the `wg0.conf` manually, you should disable WireGuard UI to make sure, that your changes do not get overwritten.

### Firewall

During installation, all IPv4 and IPv6 forwarding gets enabled in the kernel. To restrict this using a firewall, nftables is used.

You can find the firewall and NAT configuration at `/etc/nftables.conf`. Changes can be applied with `systemctl restart nftables`.

## Changing the password

The user password can be changed over the management UI after logging in and clicking on the current username. If you have forgotten your password or use an older version of the app, please follow these steps:

1. Generate a bcrypt password hash of the new password, you can use the caddy cli for that:

   ```
   caddy hash-password --algorithm bcrypt | tr -d '\n' | base64 -w0 && echo
   ```

2. Edit `/usr/local/share/wireguard-ui/db/server/users.json` and replace the `password_hash` with the newly generated hash.
   - On newer versions of wireguard-ui (since v0.5.0), the path is `/usr/local/share/wireguard-ui/db/users/{username}.json` instead.

3. Restart WireGuard UI:

   ```
   systemctl restart wireguard-ui
   ```

## Additional configuration

Most configuration options are available in the management webinterface and can be modified there, but there are some settings which aren't exposed. For these, please take a look at the `/etc/default/wireguard-ui` file.

## Updating

While WireGuard and the WireGuard cli tools can be regularly updated using `apt update` and `apt upgrade`, the Caddy webserver and WireGuard UI are manually installed.

You can download the latest Caddy `caddy_*_linux_amd64.tar.gz` from their [releases page](https://github.com/caddyserver/caddy/releases) and extract it:

```
tar -C /usr/local/bin -xzf caddy_*_linux_amd64.tar.gz caddy
```

To update WireGuard UI, please download the latest release from their [releases page](https://github.com/ngoduykhanh/wireguard-ui/releases) and extract the `wireguard-ui` binary to `/usr/local/bin` like shown above. Because of some recent patches, that did not make it into the latest WireGuard UI release yet, you might find more up to date builds [here](https://github.com/MarcusWichelmann/wireguard-ui/releases). If this is the case, please use these.

After everything is up to date again, please restart the affected systemd services:

```
systemctl restart wireguard-ui caddy
```

## Image content

### Operating system

- [x] Ubuntu 22.04

### Installed packages

| NAME         | LICENSE            |
| ------------ | ------------------ |
| WireGuard    | GPLv2              |
| WireGuard UI | MIT                |
| Caddy        | Apache License 2.0 |

## Links

For more information about the installed packages, please refer to their official documentation:

- [WireGuard](https://www.wireguard.com/)
- [WireGuard UI](https://github.com/ngoduykhanh/wireguard-ui/blob/master/README.md)
- [Caddy](https://caddyserver.com/docs/)

- [Let’s Encrypt](https://letsencrypt.org/docs/)
- [nftables](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)

For more information about Hetzner Cloud and Hetzner Cloud Apps, please refer to our official documentation:

- [Hetzner Cloud Documentation](https://docs.hetzner.com/cloud/)
- [Hetzner Cloud API](https://docs.hetzner.cloud/)
