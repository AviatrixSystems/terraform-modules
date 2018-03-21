output "private-ips" {
  value = "${aws_instance.aviatrixcontroller.*.private_ip}"
}

output "public-ips" {
  value = "${aws_instance.aviatrixcontroller.*.public_ip}"
}
