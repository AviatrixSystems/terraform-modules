output private_ip {
  value       = aws_instance.aviatrixcontroller.*.private_ip[0]
  description = "List of private IPs for aviatrix conroller"
}

output public_ip {
  value       = aws_eip.controller_eip.*.public_ip[0]
  description = "List of public IPs for aviatrix conroller"
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

output "name_prefix" {
  value = var.name_prefix
}