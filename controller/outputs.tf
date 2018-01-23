output "private-ip" {
  value = "${aws_instance.aviatrixcontroller.private_ip}"
}

output "public-ip" {
  value = "${aws_instance.aviatrixcontroller.public_ip}"
}
