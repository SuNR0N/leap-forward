resource "aws_subnet" "subnet" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.cidrs["subnet"]}"
    tags {
      Name = "${var.prefix}-${var.tags["subnet"]}"
      Owner = "${var.owner}"
    }
}
