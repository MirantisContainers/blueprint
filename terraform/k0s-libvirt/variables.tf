variable "cluster_name" {
  description = "Name of cluster"
  type = string
  default = "boundless"
}

variable "img_source" {
  description = "Ubuntu 20.04 LTS Cloud Image"
  default = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-disk-kvm.img"
}

variable "img_format" {
  description = "QCow2 UEFI/GPT Bootable disk image"
  type = string
  default = "qcow2"
}

variable "mem_size" {
  description = "Amount of RAM (in MiB) for the vm"
  type        = string
  default     = "2048"
}

variable "cores" {
  description = "Number of CPU cores for the vm"
  type        = number
  default     = 2
}

variable "disk_size" {
  description = "Amount of disk space (in GB) for the vm"
  type        = number
  default     = 20
}

variable user_account {
  description = "User account name"
  type = string
  default = "user"
}

variable ssh_public_key {
  description = "ssh public key for user account"
  type = string
  default = ""
}

variable ssh_key_path {
  description = "Path of local ssh private key"
  type = string
  default = ""
}
