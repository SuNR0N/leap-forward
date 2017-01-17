resource "aws_key_pair" "kp" {
    key_name = "${var.ssh_key_name}"
    public_key = "${file("~/.ssh/leapforward_kubernetes.pub")}"
}

resource "aws_instance" "kube_ctl" {
    count = "${var.node_count["kube_ctl"]}"
    subnet_id = "${aws_subnet.subnet.id}"
    private_ip = "${element(var.kube_ctl_ips, count.index)}"
    associate_public_ip_address = true
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${aws_key_pair.kp.key_name}"
    security_groups = [
      "${aws_security_group.sg_kubernetes.id}"
    ]
    source_dest_check = false
    tags {
  		Name = "${var.prefix}-${var.tags["kube_ctl"]}-${count.index}"
      Owner = "${var.owner}"
      Type = "${var.tags["kube_ctl"]}"
  	}
}

resource "aws_instance" "kube_worker" {
    count = "${var.node_count["kube_worker"]}"
    subnet_id = "${aws_subnet.subnet.id}"
    private_ip = "${element(var.kube_worker_ips, count.index)}"
    associate_public_ip_address = true
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${aws_key_pair.kp.key_name}"
    security_groups = [
      "${aws_security_group.sg_kubernetes.id}"
    ]
    source_dest_check = false
    tags {
  		Name = "${var.prefix}-${var.tags["kube_worker"]}-${count.index}"
      Owner = "${var.owner}"
      Type = "${var.tags["kube_worker"]}"
  	}
}
