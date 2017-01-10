# Internet Gateway
resource "aws_internet_gateway" "norberta-ig" {
  vpc_id = "${aws_vpc.norberta-vpc.id}"
}

# Internet Gateway Route Table
resource "aws_route_table" "norberta-ig-rt" {
  vpc_id = "${aws_vpc.norberta-vpc.id}"
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.norberta-ig.id}"
  }
  tags {
    Name = "${var.prefix}-${var.name_tags["rt"]}"
    Owner = "${var.owner}"
  }
}

# Subnets
resource "aws_subnet" "norberta-subnet" {
  count = 3
  vpc_id = "${aws_vpc.norberta-vpc.id}"
  cidr_block = "${element(var.subnet_cidrs, count.index)}"
  availability_zone = "${element(var.subnet_azones, count.index)}"
  depends_on = ["aws_internet_gateway.norberta-ig"]
  tags {
    Name = "${var.prefix}-${var.name_tags["subnet"]}-${count.index + 1}"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table_association" "norberta-rta" {
  count = 3
  subnet_id = "${element(aws_subnet.norberta-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.norberta-ig-rt.id}"
}
