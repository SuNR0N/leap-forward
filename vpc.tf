resource "aws_vpc" "norberta-vpc" {
	cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = "true"
	tags {
		Name = "${var.prefix}-${var.name_tags["vpc"]}"
		Owner =	"${var.owner}"
	}
}
