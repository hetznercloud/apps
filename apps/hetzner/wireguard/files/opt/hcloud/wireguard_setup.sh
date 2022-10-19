#!/bin/bash

cat <<EOF
 _________________________________________________________________________
|                                                                         |
|   Welcome to the WireGuard One-Click-App configuration.                 |
|                                                                         |
|   In this process WireGuard and the management UI will be set up        |
|   accordingly. You only need to set your desired domain which will      |
|   be used to configure the reverse proxy and to obtain Let's Encrypt    |
|   certificates.                                                         |
|                                                                         |
|   ATTENTION: Please make sure your domain exists and points to the      |
|              IPv4/IPv6 address of your server!                          |
|                                                                         |
|   Please enter the domain in following pattern: wireguard.example.com   |
|_________________________________________________________________________|
EOF

user_input(){
  while [ -z $domain ]
  do
    read -p "Your domain: " domain
  done

  echo "Please enter the password that should be used to protect the management UI:"
  while true
  do
    read -s -p "Password: " password
    echo
    read -s -p "Password (again): " password2
    echo
    [ "$password" = "$password2" ] && break || echo "Please try again."
  done

  echo "Please enter an Email address for Let's Encrypt notifications:"
  while [ -z $email ]
  do
    read -p "Your Email address: " email
  done
}

# Generate wireguard-ui session secret (16 bytes, 32 characters)
session_secret=$(openssl rand -hex 16)

# Build the list of subnets to be used for WireGuard, depending on whether the
# VM has a IPv6 subnet assigned or not.
# IPv4 is always enabled by default, even when the VM has no public IPv4 address,
# because this could still be useful for connecting to private networks.
wg_interface_addresses=172.30.0.1/24
host_ipv6_subnet=$(ip addr show eth0 | grep "inet6\b.*global" | head -n1 | awk '{print $2}')
if [ ! -z $host_ipv6_subnet ]
then
  host_ipv6_address=$(echo $host_ipv6_subnet | cut -d/ -f1)
  wg_interface_addresses=$wg_interface_addresses,${host_ipv6_address%::1}:ac1e::1/120
fi

echo -en "\n"
echo "Please enter your details to set up your new WireGuard instance."

user_input

while true
do
  echo -en "\n"
  read -p "Is everything correct? [Y/n] " confirm
  : ${confirm:="Y"}

  case $confirm in
    [yY][eE][sS]|[yY] ) break;;
    [nN][oO]|[nN] ) unset domain password email; user_input;;
    * ) echo "Please type y or n.";;
  esac
done

echo "Installing. Please wait..."

# Hash password
password_hash=$(caddy hash-password -algorithm bcrypt -plaintext "$password")

# Populate the wireguard-ui default config
sed -i "s/\$session_secret/$session_secret/g" /etc/default/wireguard-ui
sed -i "s/\$admin_password_hash/${password_hash//\//\\/}/g" /etc/default/wireguard-ui
sed -i "s/\$domain/$domain/g" /etc/default/wireguard-ui
sed -i "s/\$wg_interface_addresses/${wg_interface_addresses//\//\\/}/g" /etc/default/wireguard-ui

# Populate the caddy config
sed -i "s/\$domain/$domain/g" /etc/caddy/Caddyfile
sed -i "s/\$email/$email/g" /etc/caddy/Caddyfile

# Start wireguard-ui and caddy
systemctl enable wireguard-ui.service caddy.service &> /dev/null
systemctl start wireguard-ui.service caddy.service &> /dev/null

# Wait until wireguard-ui generated the WireGuard config
until [ -f /etc/wireguard/wg0.conf ]
do
  sleep 0.1
done
sleep 0.1

# Start wireguard and watch for config changes
systemctl enable wg-quick@wg0.service &> /dev/null
systemctl start wg-quick@wg0.service &> /dev/null
systemctl enable wg-quick-watcher@wg0.{path,service} &> /dev/null
systemctl start wg-quick-watcher@wg0.{path,service} &> /dev/null

# Enable the firewall
systemctl enable nftables.service &> /dev/null
systemctl start nftables.service &> /dev/null

# Enable IP forwarding
sed -i '/net.ipv4.ip_forward=1/s/^#//g' /etc/sysctl.conf
sed -i '/net.ipv6.conf.all.forwarding=1/s/^#//g' /etc/sysctl.conf
sysctl -p &> /dev/null

echo -en "\n\n"
echo "The installation is complete and WireGuard should be ready to use."
echo "Please go to https://$domain and log in with the user \"admin\" and your password to configure WireGuard clients."
echo -en "\n"

# Remove startup script from .bashrc
sed -i "/wireguard_setup/d" ~/.bashrc

# Remove startup scripts
rm -r /opt/hcloud
