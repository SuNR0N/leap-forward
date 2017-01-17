resource "aws_vpc" "vpc" {
    cidr_block = "${var.cidrs["vpc"]}"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
      Name = "${var.prefix}-${var.tags["vpc"]}"
      Owner = "${var.owner}"
    }
}
