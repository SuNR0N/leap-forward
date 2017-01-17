resource "aws_security_group" "sg-default" {
  description = "Security group for the VPC"
  vpc_id = "${aws_vpc.norberta-vpc.id}"

  # Allows all inbound traffic within the VPC
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }

  # Allows all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.cidrs["all"]}"]
  }

  tags {
		Name = "${var.prefix}-${var.name_tags["vpc"]}-${var.name_tags["sg"]}"
		Owner =	"${var.owner}"
	}
}

resource "aws_security_group" "sg-ovpn" {
  description = "Security group for the OVPN box"
  vpc_id = "${aws_vpc.norberta-vpc.id}"

  # Allows incoming OVPN traffic from my IP address
  ingress {
    from_port = "${var.ports["ovpn"]}"
    to_port = "${var.ports["ovpn"]}"
    protocol = "tcp"
    cidr_blocks = ["${var.my_cidr}"]
  }

  # Allows incoming SSH traffic from my IP address
  ingress {
    from_port = "${var.ports["ssh"]}"
    to_port = "${var.ports["ssh"]}"
    protocol = "tcp"
    cidr_blocks = ["${var.my_cidr}"]
  }

  # Allows all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.cidrs["all"]}"]
  }

  tags {
		Name = "${var.prefix}-${var.name_tags["ovpn"]}-${var.name_tags["sg"]}"
		Owner =	"${var.owner}"
	}
}

resource "aws_security_group" "sg-elb" {
  description = "Security group for the load balancer"
  vpc_id = "${aws_vpc.norberta-vpc.id}"

  # Allows incoming TCP traffic on port 2379 (etcd) from the outside world
  ingress {
    from_port = "${var.ports["etcd-client"]}"
    to_port = "${var.ports["etcd-client"]}"
    protocol = "tcp"
    cidr_blocks = ["${var.my_cidr}"]
  }

  # Allows outgoing TCP traffic on port 2379 (etcd) within the VPC
  egress {
    from_port = "${var.ports["etcd-client"]}"
    to_port = "${var.ports["etcd-client"]}"
    protocol = "tcp"
    cidr_blocks = "${var.private_subnets_cidr}"
  }

  tags {
		Name = "${var.prefix}-${var.name_tags["elb"]}-${var.name_tags["sg"]}"
		Owner =	"${var.owner}"
	}
}

resource "aws_security_group" "sg-etcd" {
  description = "Security group for the etcd boxes"
  vpc_id = "${aws_vpc.norberta-vpc.id}"

  # Allows incoming TCP traffic on port 2379,2380 (etcd) for all group members
  ingress {
    from_port = "${var.ports["etcd-client"]}"
    to_port = "${var.ports["etcd-client"]}"
    protocol = "tcp"
    self = true
  }

  # Allows incoming TCP traffic on port 2380 (etcd) for all group members
  ingress {
    from_port = "${var.ports["etcd-peer"]}"
    to_port = "${var.ports["etcd-peer"]}"
    protocol = "tcp"
    self = true
  }

  # Allows incoming TCP traffic on port 2379 (etcd) within the VPC
  ingress {
    from_port = "${var.ports["etcd-client"]}"
    to_port = "${var.ports["etcd-client"]}"
    protocol = "tcp"
    security_groups = ["${aws_security_group.sg-elb.id}"]
  }

  # Allows incoming SSH traffic from the OVPN box
  ingress {
    from_port = "${var.ports["ssh"]}"
    to_port = "${var.ports["ssh"]}"
    protocol = "tcp"
    cidr_blocks = ["${var.cidrs["ovpn"]}"]
  }

  # Allows all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.cidrs["all"]}"]
  }

  tags {
		Name = "${var.prefix}-${var.name_tags["etcd"]}-${var.name_tags["sg"]}"
		Owner =	"${var.owner}"
	}
}
