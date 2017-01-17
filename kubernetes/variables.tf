variable "access_key" {}
variable "secret_key" {}
variable "ssh_key_name" {}
variable "my_cidr" {}

variable "region" {
  default = "eu-west-1"
}

variable "cidrs" {
  default = {
    "all" = "0.0.0.0/0"
    "vpc" = "10.240.0.0/16"
    "subnet" = "10.240.0.0/24"
  }
}

variable "kube_ctl_ips" {
  default = [
    "10.240.0.10",
    "10.240.0.11",
    "10.240.0.12"
  ]
}

variable "kube_worker_ips" {
  default = [
    "10.240.0.20",
    "10.240.0.21",
    "10.240.0.22"
  ]
}

variable "ports" {
  default = {
    "kubernetes" = 6443
  }
}

variable "domain_name" {
  default = "eu-west-1.compute.internal"
}

variable "owner" {
  default = "Norbert"
}
variable "prefix" {
  default = "nk"
}

variable "tags" {
  default = {
    "vpc" = "vpc"
    "kubernetes" = "kubernetes"
    "dhcp" = "dhcp-options"
    "igw" = "internet-gateway"
    "rt_igw" = "route-table-igw"
    "sg" = "security-group"
    "elb" = "elastic-load-balancer"
    "kube_ctl" = "kubernetes-controller"
    "kube_worker" = "kubernetes-worker"
    "subnet" = "subnet"
  }
}

variable "ami" {
  # Ubuntu 16.04
  default = "ami-6f587e1c"
}

variable "instance_type" {
  default = "t2.small"
}

variable "node_count" {
  default = {
    "kube_ctl" = 3
    "kube_worker" = 3
  }
}
