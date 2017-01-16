resource "aws_key_pair" "kp" {
  key_name = "${var.ssh_key_name}"
  public_key = "${file("~/.ssh/leapforward.pub")}"
}

resource "aws_instance" "etcd-node" {
  count = 3
	subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  private_ip = "${element(var.node_ips, count.index)}"
  key_name = "${aws_key_pair.kp.key_name}"
	ami = "${var.amis["centos"]}"
	instance_type = "${var.instance_type}"
  security_groups = [
    "${aws_security_group.sg-etcd.id}"
  ]
	tags {
		Name = "${var.prefix}-${var.name_tags["etcd"]}-${count.index + 1}"
    Owner = "${var.owner}"
    Type = "${var.name_tags["etcd"]}"
	}
}

resource "aws_instance" "ovpn-node" {
	subnet_id = "${aws_subnet.public.0.id}"
  private_ip = "${var.ovpn_ip}"
  associate_public_ip_address = "true"
  source_dest_check = false
  key_name = "${aws_key_pair.kp.key_name}"
	ami = "${var.amis["ubuntu"]}"
	instance_type = "${var.instance_type}"
  security_groups = [
    "${aws_security_group.sg-ovpn.id}"
  ]
	tags {
		Name = "${var.prefix}-${var.name_tags["ovpn"]}"
    Owner = "${var.owner}"
    Type = "${var.name_tags["ovpn"]}"
	}
}
