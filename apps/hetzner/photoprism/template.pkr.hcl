variable "app_name" {
  type    = string
  default = "photoprism"
}

variable "app_version" {
  type    = string
  default = "latest"
}

variable "hcloud_image" {
  type    = string
  default = "ubuntu-22.04"
}

variable "hcloud_server_type" {
  type    = string
  default = "cpx11"
}

build {
  sources = ["source.hcloud.autogenerated_1"]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  provisioner "file" {
    destination = "/opt/"
    source      = "apps/hetzner/photoprism/files/opt/"
  }

  provisioner "file" {
    destination = "/var/"
    source      = "apps/hetzner/photoprism/files/var/"
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive", "LC_ALL=C", "LANG=en_US.UTF-8", "LC_CTYPE=en_US.UTF-8"]
    scripts          = ["apps/shared/scripts/apt-upgrade.sh", "apps/hetzner/photoprism/scripts/install.sh", "apps/shared/scripts/cleanup.sh"]
  }
}
