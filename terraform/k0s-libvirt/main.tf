terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "ubuntu-base" {
  name   = "boundless-ubuntu-base.qcow2"
  pool   = "default"
  source = var.img_source
  format = var.img_format
}

resource "libvirt_volume" "boundless_volume" {
  name           = "${var.cluster_name}.${var.img_format}"
  pool           = "default"
  format         = var.img_format
  size           = var.disk_size * 1000000000
  base_volume_id = libvirt_volume.ubuntu-base.id
}

resource "libvirt_domain" "guest" {
  name   = "${var.cluster_name}_ubuntu"
  memory = var.mem_size
  vcpu   = var.cores

  disk {
    volume_id = libvirt_volume.boundless_volume.id
  }

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = data.template_file.user_data.rendered
  pool      = "default"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    user_account = var.user_account
    public_key   = var.ssh_public_key
  }
}

locals {
  k0s_tmpl = {
    apiVersion = "boundless.mirantis.com/v1alpha1"
    kind       = "Blueprint"
    metadata = {
      name = var.cluster_name
    }
    spec = {
      kubernetes = {
        provider = "k0s"
        version = "1.30.0+k0s.0"
        config = {
        }
        infra = {
          hosts = [
              {
                  role = "single"
                  ssh = {
                      address = libvirt_domain.guest.network_interface[0].addresses[0]
                      user = var.user_account
                      keyPath = var.ssh_key_path
                      port = 22
                  }
              }
          ]
        }
      }
      components = {
        addons = []
      }
    }
  }
}

output "k0s_cluster" {
  value = yamlencode(local.k0s_tmpl)
}
