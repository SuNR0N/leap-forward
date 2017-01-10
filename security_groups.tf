resource "aws_security_group" "norberta-sg-default" {
  description = "Security group that allows all outbound traffic and internal HTTP traffic within the VPC"
  vpc_id = "${aws_vpc.norberta-vpc.id}"

  # HTTP access from the VPC
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Outbound internet access
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

resource "aws_security_group" "norberta-sg-nat" {
  description = "Security group for NAT instances that allows SSH from my IP"
  vpc_id = "${aws_vpc.norberta-vpc.id}"

  # SSH access from my IP
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

resource "aws_security_group" "norberta-sg-etcd" {
  description = "Security group exposing etcd client port"
  vpc_id = "${aws_vpc.norberta-vpc.id}"

  ingress {
    from_port = 2379
    to_port = 2379
    protocol = "tcp"
    cidr_blocks = ["${var.my_cidr}"]
  }

  tags {
		Name = "${var.prefix}-${var.name_tags["sg"]}"
		Owner =	"${var.owner}"
	}
}
