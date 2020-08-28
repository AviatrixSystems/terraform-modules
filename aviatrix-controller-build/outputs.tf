output private_ip {
  value       = length(aws_instance.aviatrixcontroller) > 0 ? aws_instance.aviatrixcontroller.*.private_ip[0] : ""
  description = "Private IPs for first aviatrix conroller"
}

output public_ip {
  value       = length(aws_instance.aviatrixcontroller) > 0 ? aws_instance.aviatrixcontroller.*.public_ip[0] : ""
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
