resource "aws_vpc" "norberta-vpc" {
	cidr_block = "${var.vpc_cidr}"
	tags {
		Name = "${var.prefix}-${var.name_tags["vpc"]}"
		Owner =	"${var.owner}"
	}
}
