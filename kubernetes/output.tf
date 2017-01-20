output "elb_dns" {
  value = "${aws_elb.elb.dns_name}"
}

output "kubernetes_controller_public_dns" {
  value = ["${aws_instance.kube_ctl.*.public_dns}"]
}

output "kubernetes_controller_public_ips" {
  value = ["${aws_instance.kube_ctl.*.public_ip}"]
}

output "kubernetes_controller_private_ips" {
  value = ["${aws_instance.kube_ctl.*.private_ip}"]
}

output "kubernetes_worker_public_dns" {
  value = ["${aws_instance.kube_worker.*.public_dns}"]
}

output "kubernetes_worker_public_ips" {
  value = ["${aws_instance.kube_worker.*.public_ip}"]
}

output "kubernetes_worker_private_ips" {
  value = ["${aws_instance.kube_worker.*.private_ip}"]
}
