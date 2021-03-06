
variable "app_name" {
  type    = string
  default = "ruby"
}

variable "app_version" {
  type    = string
  default = "3"
}

variable "hcloud_image" {
  type    = string
  default = "ubuntu-22.04"
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

  # Workaround until https://github.com/hashicorp/packer/issues/11733 is released
  user_data = "#!/bin/sh\necho PubkeyAcceptedKeyTypes=+ssh-rsa >> /etc/ssh/sshd_config; service ssh reload"

  token         = "${var.hcloud_api_token}"
}

build {
  sources = ["source.hcloud.autogenerated_1"]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive", "LC_ALL=C", "LANG=en_US.UTF-8", "LC_CTYPE=en_US.UTF-8"]
    scripts          = ["apps/shared/scripts/apt-upgrade.sh", "apps/hetzner/ruby/scripts/ruby.sh", "apps/shared/scripts/cleanup.sh"]
  }

}
