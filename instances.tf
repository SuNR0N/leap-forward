resource "aws_key_pair" "deployer" {
  key_name = "${var.ssh_key_name}"
  public_key = "${file("~/.ssh/leapforward.pub")}"
}

resource "aws_instance" "norberta-node" {
  count = 3
	subnet_id = "${element(aws_subnet.norberta-subnet.*.id, count.index)}"
  private_ip = "${element(var.node_ips, count.index)}"
  associate_public_ip_address = "true"
  key_name = "${aws_key_pair.deployer.key_name}"
	ami = "${var.ami}"
	instance_type = "${var.instance_type}"
  security_groups = [
    "${aws_security_group.norberta-sg-default.id}",
    "${aws_security_group.norberta-sg-nat.id}",
    "${aws_security_group.norberta-sg-etcd.id}"
  ]
	tags {
		Name = "${var.prefix}-${var.name_tags["node"]}-${count.index + 1}"
    Owner = "${var.owner}"
	}
}
