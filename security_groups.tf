resource "aws_security_group" "sg-default" {
  description = "Security group that allows all outbound traffic and ICMP traffic within the VPC"
  vpc_id = "${aws_vpc.norberta-vpc.id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
    self = true
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
		Name = "${var.prefix}-${var.name_tags["sg"]}"
		Owner =	"${var.owner}"
	}
}

resource "aws_security_group" "sg-ovpn" {
  description = "Security group that allows SSH from my IP and incoming OVPN traffic from the world"
  vpc_id = "${aws_vpc.norberta-vpc.id}"

  ingress {
    from_port = 1194
    to_port = 1194
    protocol = "tcp"
    cidr_blocks = ["${var.my_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.my_cidr}"]
  }

  tags {
		Name = "${var.prefix}-${var.name_tags["sg"]}"
		Owner =	"${var.owner}"
	}
}

resource "aws_security_group" "sg-elb" {
  description = "Security group that forwards TCP traffic on port 2379"
  vpc_id = "${aws_vpc.norberta-vpc.id}"

  ingress {
    from_port = 2379
    to_port = 2379
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 2379
    to_port = 2379
    protocol = "tcp"
    cidr_blocks = "${var.private_subnets_cidr}"
  }

  tags {
		Name = "${var.prefix}-${var.name_tags["sg"]}"
		Owner =	"${var.owner}"
	}
}

resource "aws_security_group" "sg-etcd" {
  description = "Security group that allows TCP traffic on port 2379 and 2380 and allowing SSH access from OVPN node"
  vpc_id = "${aws_vpc.norberta-vpc.id}"

  ingress {
    from_port = 2379
    to_port = 2380
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
    self = true
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.ovpn_cidr}"]
  }

  tags {
		Name = "${var.prefix}-${var.name_tags["sg"]}"
		Owner =	"${var.owner}"
	}
}
