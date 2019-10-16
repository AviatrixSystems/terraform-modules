# Outputs for TF Regression Testbed AWS VPC environment setup

output "vpc_id" {
  value   = aws_vpc.vpc[*].id
}

output "vpc_name" {
  value   = aws_vpc.vpc[*].tags.Name
}

output "subnet_name" {
  value   = concat(
    aws_subnet.public_subnet1[*].tags.Name,
    aws_subnet.public_subnet2[*].tags.Name,
    aws_subnet.private_subnet[*].tags.Name
  )
}

output "subnet_cidr" {
  value   = concat(
    aws_subnet.public_subnet1[*].cidr_block,
    aws_subnet.public_subnet2[*].cidr_block,
    aws_subnet.private_subnet[*].cidr_block
  )
}

output "ubuntu_name" {
	value		= concat(
    aws_instance.public_instance[*].tags.Name,
    aws_instance.private_instance[*].tags.Name
  )
}

output "ubuntu_public_ip" {
  value   = aws_eip.eip[*].public_ip
}

output "ubuntu_private_ip" {
  value   = concat(
    aws_instance.public_instance[*].private_ip,
    aws_instance.private_instance[*].private_ip
  )
}

output "ubuntu_id" {
	value		= concat(
    aws_instance.public_instance[*].id,
    aws_instance.private_instance[*].id
  )
}
