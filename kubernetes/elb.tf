resource "aws_elb" "elb" {
    name = "${var.prefix}-${var.tags["elb"]}"
    subnets = ["${aws_subnet.subnet.id}"]
    instances = ["${aws_instance.kube_ctl.*.id}"]
    security_groups = ["${aws_security_group.sg_kubernetes.id}"]
    listener {
      instance_port = "${var.ports["kubernetes"]}"
      instance_protocol = "tcp"
      lb_port = "${var.ports["kubernetes"]}"
      lb_protocol = "tcp"
    }
}
