
variable "app_name" {
  type    = string
  default = "wordpress"
}

variable "app_version" {
  type    = string
  default = "5.8.1"
}

variable "app_checksum" {
  type    = string
  default = "21e50add5a51cd9a18610244c942c08f7abeccd8"
}

variable "hcloud_image" {
  type    = string
  default = "ubuntu-20.04"
}

variable "apt_packages" {
  type    = string
  default = "apache2 libapache2-mod-php mysql-server php php-apcu php-bz2 php-curl php-gd php-gmp php-intl php-json php-mbstring php-mysql php-pspell php-soap php-tidy php-xml php-xmlrpc php-xsl php-zip postfix python3-certbot-apache software-properties-common unzip"
}

variable "git-sha" {
  type    = string
  default = "${env("GITHUB_SHA")}"
}

variable "hcloud_api_token" {
  type      = string
  default   = "${env("HCLOUD_API_TOKEN")}"
  sensitive = true
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "hcloud" "autogenerated_1" {
  image       = "${var.hcloud_image}"
  location    = "ash"
  server_name = "hcloud-app-builder-${var.app_name}-${local.timestamp}"
  server_type = "cx11"
  snapshot_labels = {
    app       = "${var.app_name}"
    git-sha   = "${var.git-sha}"
    version   = "${var.app_version}"
    slug      = "oneclick-${var.app_name}-${var.app_version}-${var.hcloud_image}"
  }
  snapshot_name = "hcloud-app-${var.app_name}-${local.timestamp}"
  ssh_username  = "root"
  token         = "${var.hcloud_api_token}"
}

build {
  sources = ["source.hcloud.autogenerated_1"]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  provisioner "file" {
    destination = "/etc/"
    source      = "apps/hetzner/wordpress/files/etc/"
  }

  provisioner "file" {
    destination = "/opt/"
    source      = "apps/hetzner/wordpress/files/opt/"
  }

  provisioner "file" {
    destination = "/var/"
    source      = "apps/hetzner/wordpress/files/var/"
  }

  provisioner "file" {
    destination = "/var/www/"
    source      = "apps/shared/www/"
  }

  provisioner "file" {
    destination = "/var/www/html/assets/"
    source      = "apps/hetzner/wordpress/images/"
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive", "LC_ALL=C", "LANG=en_US.UTF-8", "LC_CTYPE=en_US.UTF-8"]
    scripts          = ["apps/shared/scripts/apt-upgrade.sh"]
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive", "LC_ALL=C", "LANG=en_US.UTF-8", "LC_CTYPE=en_US.UTF-8"]
    inline           = ["apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install ${var.apt_packages}"]
  }

  provisioner "shell" {
    environment_vars = ["application_name=${var.app_name}", "application_version=${var.app_version}", "application_checksum=${var.app_checksum}", "DEBIAN_FRONTEND=noninteractive", "LC_ALL=C", "LANG=en_US.UTF-8", "LC_CTYPE=en_US.UTF-8"]
    scripts          = ["apps/shared/scripts/apt-upgrade.sh", "apps/hetzner/wordpress/scripts/wp-install.sh", "apps/shared/scripts/cleanup.sh"]
  }

}
