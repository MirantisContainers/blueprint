variable "cluster_name" {
  type    = string
  default = "k0sctl"
}

variable "controller_count" {
  type    = number
  default = 1
}

variable "worker_count" {
  type    = number
  default = 1
}

variable "cluster_flavor" {
  type    = string
  default = "t3.large"
}

variable "region" {
  type    = string
  default = "us-east-1"  
}