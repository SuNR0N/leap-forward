# Subnets
resource "aws_subnet" "public" {
  count = 3
  vpc_id = "${aws_vpc.norberta-vpc.id}"
  cidr_block = "${element(var.public_subnets_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  depends_on = ["aws_internet_gateway.ig"]
  tags {
    Name = "${var.prefix}-${var.name_tags["subnet-pub"]}-${count.index + 1}"
    Owner = "${var.owner}"
  }
}

resource "aws_subnet" "private" {
  count = 3
  vpc_id = "${aws_vpc.norberta-vpc.id}"
  cidr_block = "${element(var.private_subnets_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  depends_on = ["aws_nat_gateway.nat"]
  tags {
    Name = "${var.prefix}-${var.name_tags["subnet-pri"]}-${count.index + 1}"
    Owner = "${var.owner}"
  }
}

# Elastic IPs
resource "aws_eip" "eip" {
  count = 3
  vpc = true
  depends_on = ["aws_internet_gateway.ig"]
}

# NAT Gateways within the public subnets
resource "aws_nat_gateway" "nat" {
  count = 3
  allocation_id = "${element(aws_eip.eip.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  depends_on = ["aws_internet_gateway.ig"]
}

resource "aws_route_table" "private" {
  count = 3
  vpc_id = "${aws_vpc.norberta-vpc.id}"
  route = {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  }
  tags {
    Name = "${var.prefix}-${var.name_tags["rt-pri"]}"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table_association" "rta-ig-public" {
  count = 3
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "rta-nat-private" {
  count = 3
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
