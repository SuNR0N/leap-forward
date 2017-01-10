variable "access_key" {}
variable "secret_key" {}
variable "ssh_key_name" {}
variable "my_cidr" {}

variable "prefix" {
  default = "norberta"
}
variable "region" {
  default = "eu-west-1"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "name_tags" {
  type = "map"
  default = {
    "vpc" = "vpc"
    "rt" = "route-table"
    "subnet" = "subnet"
    "node" = "node"
    "sg" = "security-group"
  }
}
variable "subnet_azones" {
  type = "list"
  default = [
    "eu-west-1a",
    "eu-west-1b",
    "eu-west-1c"
  ]
}
variable "subnet_cidrs" {
  type = "list"
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}
variable "owner" {
  default = "Norbert"
}
variable "node_ips" {
  type = "list"
  default = [
    "10.0.1.10",
  	"10.0.2.10",
  	"10.0.3.10"
  ]
}
variable "ami" {
  description = "CentOS Image"
  default = "ami-7abd0209"
}
variable "instance_type" {
  default = "t2.micro"
}
