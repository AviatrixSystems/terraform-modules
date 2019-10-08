# Outputs for TF Regression Testbed Aviatrix Controller setup

output "vpc" {
	value				= aws_vpc.vpc[0].id
	description	= "VPC ID the Aviatrix controller is contained in."
}
output "subnet" {
	value				= aws_subnet.public_subnet[0].id
	description	= "Public subnet ID the Aviatrix controller is contained in."
}
output "keypair_name" {
	value				= aws_key_pair.key_pair[0].key_name
	description	= "Name of key pair to access Aviatrix controller."
}
output "private_ip" {
  value				= aws_instance.aviatrixcontroller[0].private_ip
	description	= "Private IP of the Aviatrix controller"
}
output "public_ip" {
  value				= aws_eip.controller_eip[0].public_ip
	description	= "Public IP of the Aviatrix controller"
}
output "username_password" {
	value				= ["admin", var.admin_password]
	description	= "Username (1st value) and password (2nd value) to login to Aviatrix controller."
}
output "result" {
  value				= data.aws_lambda_invocation.example[0].result
	description	=	"Result of initializing the Aviatrix controller."
}
