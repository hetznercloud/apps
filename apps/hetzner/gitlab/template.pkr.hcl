
variable "app_name" {
  type    = string
  default = "gitlab"
}

variable "app_version" {
  type    = string
  default = "15.3"
}

variable "hcloud_image" {
  type    = string
  default = "ubuntu-20.04"
}

variable "apt_packages" {
  type    = string
  default = "openssh-server ca-certificates tzdata perl postfix apache2"
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

variable "snapshot_name" {
  type = string
  default = "packer-{{timestamp}}"
}

source "hcloud" "autogenerated_1" {
  image       = "${var.hcloud_image}"
  location    = "nbg1"
  server_name = "hcloud-app-builder-${var.app_name}-{{timestamp}}"
  server_type = "cx11"
  snapshot_labels = {
    git-sha   = "${var.git-sha}"
    version   = "${var.app_version}"
    slug      = "oneclick-${var.app_name}-${var.app_version}-${var.hcloud_image}"
  }
  snapshot_name = "${var.snapshot_name}"
  ssh_username  = "root"
  token         = "${var.hcloud_api_token}"
}

build {
  sources = ["source.hcloud.autogenerated_1"]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  provisioner "file" {
    destination = "/opt/"
    source      = "apps/hetzner/gitlab/files/opt/"
  }

  provisioner "file" {
    destination = "/var/"
    source      = "apps/hetzner/gitlab/files/var/"
  }

  provisioner "file" {
    destination = "/var/www/"
    source      = "apps/shared/www/"
  }

  provisioner "file" {
    destination = "/var/www/html/assets/"
    source      = "apps/hetzner/gitlab/images/"
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive", "LC_ALL=C", "LANG=en_US.UTF-8", "LC_CTYPE=en_US.UTF-8"]
    scripts          = ["apps/shared/scripts/apt-upgrade.sh"]
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive", "LC_ALL=C", "LANG=en_US.UTF-8", "LC_CTYPE=en_US.UTF-8"]
    inline           = ["curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash"]
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive", "LC_ALL=C", "LANG=en_US.UTF-8", "LC_CTYPE=en_US.UTF-8"]
    inline           = ["apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install ${var.apt_packages} gitlab-ce=${var.app_version}*"]
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive", "LC_ALL=C", "LANG=en_US.UTF-8", "LC_CTYPE=en_US.UTF-8"]
    scripts          = ["apps/shared/scripts/cleanup.sh"]
  }

  provisioner "file" {
    destination = "/etc/"
    source      = "apps/hetzner/gitlab/files/etc/"
  }

}
