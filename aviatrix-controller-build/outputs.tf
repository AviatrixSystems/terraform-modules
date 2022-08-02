output "private_ip" {
  value       = length(aws_instance.aviatrixcontroller) > 0 ? aws_instance.aviatrixcontroller.*.private_ip[0] : ""
  description = "Private IP for the first aviatrix conroller"
}

output "public_ip" {
  value       = length(aws_eip.controller_eip) > 0 ? aws_eip.controller_eip.*.public_ip[0] : ""
  description = "Public IP for the first aviatrix conroller"
}

output "vpc_id" {
  value       = var.vpc
  description = "VPC where Aviatrix controller was built"
}

output "subnet_id" {
  value       = var.subnet
  description = "Subnet where Aviatrix controller was built"
}

output "security_group_id" {
  value       = aws_security_group.AviatrixSecurityGroup.id
  description = "Security group id used by Aviatrix controller"
}

output "name_prefix" {
  value = var.name_prefix
}

output "private_ip_list" {
  value       = aws_instance.aviatrixcontroller.*.private_ip
  description = "List of Private IP addresses of all the Aviatrix controllers launched on the same VPC"
}

output "public_ip_list" {
  value       = aws_eip.controller_eip.*.public_ip
  description = "List of Public IP addresses of all the Aviatrix controllers launched on the same VPC"
}