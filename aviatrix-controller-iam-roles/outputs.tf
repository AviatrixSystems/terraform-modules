
output "aws-account" {
  value       = data.aws_caller_identity.current.account_id
  description = "AWS account Id"
}

output "aviatrix-role-ec2-name" {
  value       = aws_iam_role.aviatrix-role-ec2.name
  description = "Aviatrix role for EC2"
}

output "aviatrix-role-app-name" {
  value       = aws_iam_role.aviatrix-role-app.name
  description = "Aviatrix role for application"
}

output "name_prefix" {
  value = var.name_prefix
}