variable "access_key" {}
variable "secret_key" {}
variable "ssh_key_name" {}
variable "my_cidr" {}

variable "prefix" {
  default = "norberta"
}
variable "owner" {
  default = "Norbert"
}
variable "instance_count" {
  default = 3
}
variable "region" {
  default = "eu-west-1"
}
variable "cidrs" {
  type = "map"
  default = {
    "all" = "0.0.0.0/0"
    "vpc" = "10.0.0.0/16"
    "ovpn" = "10.0.101.10/32"
  }
}
variable "ports" {
  type = "map"
  default = {
    "ssh" = 22
    "etcd-client" = 2379
    "etcd-peer" = 2380
    "ovpn" = 1194
  }
}
variable "ovpn_ip" {
  default = "10.0.101.10"
}
variable "etcd_ips" {
  type = "list"
  default = [
    "10.0.1.10",
  	"10.0.2.10",
  	"10.0.3.10"
  ]
}
variable "name_tags" {
  type = "map"
  default = {
    "vpc" = "vpc"
    "rt-pri" = "private-route-table"
    "rt-pub" = "public-route-table"
    "subnet-pri" = "private-subnet"
    "subnet-pub" = "public-subnet"
    "etcd" = "etcd"
    "sg" = "security-group"
    "elb" = "elastic-load-balancer"
    "ovpn" = "ovpn"
    "ig" = "internet-gateway"
  }
}
variable "availability_zones" {
  type = "list"
  default = [
    "eu-west-1a",
    "eu-west-1b",
    "eu-west-1c"
  ]
}
variable "public_subnets_cidr" {
  type = "list"
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]
}
variable "private_subnets_cidr" {
  type = "list"
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}
variable "amis" {
  type = "map"
  default = {
    "centos" = "ami-7abd0209"
    "ubuntu" = "ami-1967056a"
  }
}
variable "instance_type" {
  default = "t2.micro"
}
