output aws-account {
  value       = data.aws_caller_identity.current.account_id
  description = "AWS account Id"
}

output aviatrix-role-ec2-name {
  value       = aws_iam_role.aviatrix-role-ec2.name
  description = "Aviatrix role name for EC2"
}

output aviatrix-role-ec2-arn {
  value       = aws_iam_role.aviatrix-role-ec2.arn
  description = "Aviatrix role ARN for EC2"
}

output aviatrix-role-app-name {
  value       = aws_iam_role.aviatrix-role-app.name
  description = "Aviatrix role name for application"
}

output aviatrix-role-app-arn {
  value       = aws_iam_role.aviatrix-role-app.arn
  description = "Aviatrix role ARN for application"
}

output aviatrix-assume-role-policy-arn {
  value       = aws_iam_policy.aviatrix-assume-role-policy.arn
  description = "Aviatrix assume role policy ARN"
}

output aviatrix-app-policy-arn {
  value       = aws_iam_policy.aviatrix-app-policy.arn
  description = "Aviatrix policy ARN for application"
}

output aviatrix-role-ec2_profile-arn {
  value       = aws_iam_instance_profile.aviatrix-role-ec2_profile.arn
  description = "Aviatrix role EC2 profile ARN for application"
}

output name_prefix {
  value = var.name_prefix
}