resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.vpc.id}"
  	tags {
  		Name = "${var.prefix}-${var.tags["igw"]}"
  		Owner =	"${var.owner}"
  	}
}

resource "aws_route_table" "rt_igw" {
    vpc_id = "${aws_vpc.vpc.id}"
    route = {
      cidr_block = "${var.cidrs["all"]}"
      gateway_id = "${aws_internet_gateway.igw.id}"
    }
    tags {
      Name = "${var.prefix}-${var.tags["rt_igw"]}"
      Owner = "${var.owner}"
    }
}

resource "aws_route_table_association" "rta_igw_subnet" {
    subnet_id = "${aws_subnet.subnet.id}"
    route_table_id = "${aws_route_table.rt_igw.id}"
}
