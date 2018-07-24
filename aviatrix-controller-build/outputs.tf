output "private_ip" {
  value = "${aws_instance.aviatrixcontroller.*.private_ip[0]}"
}

output "public_ip" {
  value = "${aws_eip.controller_eip.*.public_ip[0]}"
}
