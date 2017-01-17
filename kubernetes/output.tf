output "elb_dns" {
  value = "${aws_elb.elb.dns_name}"
}

output "kube_ctl_public_dns" {
  value = ["${aws_instance.kube_ctl.*.public_dns}"]
}

output "kube_ctl_public_ips" {
  value = ["${aws_instance.kube_ctl.*.public_ip}"]
}

output "kube_ctl_private_ips" {
  value = ["${aws_instance.kube_ctl.*.private_ip}"]
}

output "kube_worker_public_dns" {
  value = ["${aws_instance.kube_worker.*.public_dns}"]
}

output "kube_worker_public_ips" {
  value = ["${aws_instance.kube_worker.*.public_ip}"]
}

output "kube_worker_private_ips" {
  value = ["${aws_instance.kube_worker.*.private_ip}"]
}
