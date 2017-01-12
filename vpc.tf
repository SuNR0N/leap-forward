resource "aws_vpc" "norberta-vpc" {
	cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = "true"
	tags {
		Name = "${var.prefix}-${var.name_tags["vpc"]}"
		Owner =	"${var.owner}"
	}
}

# Elastic Load Balancer
resource "aws_elb" "elb" {
  name = "${var.prefix}-${var.name_tags["elb"]}"
  subnets = ["${aws_subnet.private.*.id}"]
  listener {
    instance_port = 2379
    instance_protocol = "http"
    lb_port = 2379
    lb_protocol = "http"
  }
  security_groups = [
    "${aws_security_group.sg-elb.id}"
  ]
  tags {
		Name = "${var.prefix}-${var.name_tags["elb"]}"
    Owner = "${var.owner}"
	}
}

# Internet Gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.norberta-vpc.id}"
}

# Internet Gateway Route Table
resource "aws_route_table" "rt-ig" {
  vpc_id = "${aws_vpc.norberta-vpc.id}"
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
  }
  tags {
    Name = "${var.prefix}-${var.name_tags["rt"]}"
    Owner = "${var.owner}"
  }
}
