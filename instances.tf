resource "aws_key_pair" "kp_etcd" {
  key_name = "${var.ssh_key_name_etcd}"
  public_key = "${file("~/.ssh/leapforward_etcd.pub")}"
}

resource "aws_key_pair" "kp_ovpn" {
  key_name = "${var.ssh_key_name_ovpn}"
  public_key = "${file("~/.ssh/leapforward_ovpn.pub")}"
}

resource "aws_instance" "etcd-node" {
  count = 3
	subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  private_ip = "${element(var.node_ips, count.index)}"
  key_name = "${aws_key_pair.kp_etcd.key_name}"
	ami = "${var.amis["centos"]}"
	instance_type = "${var.instance_type}"
  security_groups = [
    "${aws_security_group.sg-etcd.id}",
    "${aws_security_group.sg-default.id}"
  ]
	tags {
		Name = "${var.prefix}-${var.name_tags["node"]}-${count.index + 1}"
    Owner = "${var.owner}"
	}
}

resource "aws_instance" "ovpn-node" {
	subnet_id = "${aws_subnet.public.0.id}"
  private_ip = "${var.ovpn_ip}"
  associate_public_ip_address = "true"
  key_name = "${aws_key_pair.kp_etcd.key_name}"
	ami = "${var.amis["ubuntu"]}"
	instance_type = "${var.instance_type}"
  security_groups = [
    "${aws_security_group.sg-ovpn.id}",
    "${aws_security_group.sg-default.id}"
  ]
	tags {
		Name = "${var.prefix}-${var.name_tags["ovpn"]}"
    Owner = "${var.owner}"
	}
}
