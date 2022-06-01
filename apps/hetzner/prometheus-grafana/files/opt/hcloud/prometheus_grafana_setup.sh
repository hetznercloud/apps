#!/bin/bash
#
# This will enable Grafana, configure it with user input
# and optionally set up LE.
#
docker compose -f /opt/containers/prometheus-grafana/docker-compose.yml pull -q &
cat <<EOF
 ______________________________________________________________________
|                                                                      |
|   Welcome to the Prometheus-Grafana One-Click-App configuration.     |
|                                                                      |
|   In this process Prometheus and Grafana will be set up accordingly. |
|   You only need to set your desired Domain which will be used        |
|   to configure Grafana and allow Let's Encrypt to obtain a           |
|   valid SSL Certificate.                                             |
|   Please make sure your Domain exists first.                         |
|                                                                      |
|   Please enter the Domain in following pattern: grafana.example.com  |
|______________________________________________________________________|
EOF

user_input(){

  local service="$1"

  while [ -z $domain ]
  do
    echo "Note that the Domain needs to exist."
    read -p "Your $service Domain: " domain
  done

}

ask_domain(){

  local address=$1

  user_input "${address}"
  while true
  do
      echo -en "\n"
      read -p "Is the Domain correct? [Y/n] " confirm
      : ${confirm:="Y"}

      case $confirm in
        [yY][eE][sS]|[yY] ) sed -i "s/${address}_SITE_ADDRESS/$domain/g" /opt/containers/prometheus-grafana/.env; break;;
        [nN][oO]|[nN] ) unset domain; user_input ${address};;
        * ) echo "Please type y or n.";;
      esac
  done
}

progress(){

  while [ "$(ps a | awk '{print $1}' | grep $!)" ]
  do
    for X in '-' '/' '|' '\'
      do
        echo -en "\b$X"
        sleep 0.1
      done
  done

}

echo -en "\n"
echo "Please enter your details to set up your new Prometheus-Grafana Instance."

ask_domain "GRAFANA"
grafana_domain="${domain}"; unset domain

read -p "Do you want to expose Prometheus with a Basic Auth? [Y/n] " ask_prometheus
  : ${ask_prometheus:="Y"}
    case $ask_prometheus in
	      [Yy][eE][sS]|[yY] ) ask_domain "PROMETHEUS"; prometheus_domain="${domain}";sed -i 's/#caddy/caddy/g' /opt/containers/prometheus-grafana/docker-compose.yml; unset domain;;
        [nN][oO]|[nN] ) echo "Prometheus is only reachable via the internal network";;
        * ) echo "Please type y or n.";;
    esac

echo -en "\n\n"

echo "The Installation is beeing performed. This can take some time..."
{
apt purge -y apache2-utils
rm /var/lib/cloud/scripts/per-instance/001_onboot
docker compose -f /opt/containers/prometheus-grafana/docker-compose.yml up -d
} &> /dev/null & progress

source /root/.hcloud_password
echo -en "\n\n"
if [ -n "${prometheus_domain}" ]; then
  echo "The installation is complete and Grafana+Prometheus should be running at your Domain."
  echo "--- $grafana_domain ---"
  echo -en "\n"
  echo "Please use the following user to log in to your new instance."
  echo "Grafana_User: admin"
  echo "Grafana_Password: $grafana_initial_pass"
  echo -en "\n"
  echo "--- $prometheus_domain ---"
  echo -en "\n"
  echo "Please use the following user to log in to your new instance."
  echo "Prometheus_User: admin"
  echo "Prometheus_Password: $prometheus_initial_pass"
  echo -en "\n"
else
  echo "The installation is complete and Grafana should be running at your Domain."
  echo "--- $grafana_domain ---"
  echo -en "\n"
  echo "Please use the following user to log in to your new instance."
  echo "Grafana_User: admin"
  echo "Grafana_Password: $grafana_initial_pass"
  echo -en "\n"
fi

# Remove startup script from .bashrc
sed -i "/prometheus_grafana_setup/d" ~/.bashrc

# Remove startup scripts
rm -r /opt/hcloud
