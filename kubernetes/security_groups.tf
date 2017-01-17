resource "aws_security_group" "sg_kubernetes" {
    name = "${var.prefix}-${var.tags["sg"]}"
    description = "Kubernetes security group"
    vpc_id = "${aws_vpc.vpc.id}"

    # Allow all inbound traffic from sources within the VPC
    ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["${var.cidrs["vpc"]}"]
    }

    # Allow SSH from the outside world
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${var.my_cidr}"]
    }

    # Allow inbound traffic on TCP 6443 from the outside world
    ingress {
      from_port = 6443
      to_port = 6443
      protocol = "tcp"
      cidr_blocks = ["${var.my_cidr}"]
    }

    # Allow all inbound traffic from nodes within the same security group
    ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
    }

    # Allow all outbound traffic
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["${var.cidrs["all"]}"]
    }

    tags {
  		Name = "${var.prefix}-${var.tags["kubernetes"]}-${var.tags["sg"]}"
  		Owner =	"${var.owner}"
  	}
}
