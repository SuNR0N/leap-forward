output "elb_dns" {
  value = "${aws_elb.elb.dns_name}"
}

output "ovpn_public_ip" {
  value = "${aws_instance.ovpn-node.public_ip}"
}

output "etcd_private_ips" {
  value = ["${aws_instance.etcd-node.*.private_ip}"]
}
