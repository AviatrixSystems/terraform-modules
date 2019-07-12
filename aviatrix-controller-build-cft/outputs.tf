output "private_ip" {
  value = "${aws_cloudformation_stack.controller_quickstart.outputs["AviatrixControllerPrivateIP"]}"
}

output "public_ip" {
  value = "${aws_cloudformation_stack.controller_quickstart.outputs["AviatrixControllerEIP"]}"
}
