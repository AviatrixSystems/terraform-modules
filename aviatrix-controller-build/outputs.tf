output private_ip {
  value       = length(aws_instance.aviatrixcontroller) > 0 ? aws_instance.aviatrixcontroller.*.private_ip[0] : ""
  description = "Private IP for the first aviatrix conroller"
}

output public_ip {
  value       = length(aws_eip.controller_eip) > 0 ? aws_eip.controller_eip.*.public_ip[0] : ""
  description = "Public IP for the first aviatrix conroller"
}

output vpc_id {
  value       = var.vpc
  description = "VPC where Aviatrix controller was built"
}

output subnet_id {
  value       = var.subnet
  description = "Subnet where Aviatrix controller was built"
}

output security_group_id {
  value       = aws_security_group.AviatrixSecurityGroup.id
  description = "Security group id used by Aviatrix controller"
}

output name_prefix {
  value = var.name_prefix
}

output list_private_ip {
  value       = aws_instance.aviatrixcontroller.*.private_ip
  description = "List of Private IPs for all of the aviatrix conroller launched"
}

output list_public_ip {
  value       = aws_eip.controller_eip.*.public_ip
  description = "List of Public IPs for all of the aviatrix conroller launched"
}