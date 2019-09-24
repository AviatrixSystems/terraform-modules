# Outputs for TF Regression Testbed Aviatrix Controller setup

output "vpc" {
	value				= aws_vpc.vpc.id
	description	= "VPC ID the Aviatrix controller is contained in."
}
output "subnet" {
	value				= aws_subnet.public_subnet.id
	description	= "Public subnet ID the Aviatrix controller is contained in."
}
output "keypair_name" {
	value				= aws_key_pair.key_pair.key_name
	description	= "Name of key pair to access Aviatrix controller."
}
output "private_ip" {
  value				= module.aviatrix-controller-build.private_ip
	description	= "Private IP of the Aviatrix controller"
}
output "public_ip" {
  value				= module.aviatrix-controller-build.public_ip
	description	= "Public IP of the Aviatrix controller"
}
output "username_password" {
	value				= ["admin", var.admin_password]
	description	= "Username (1st value) and password (2nd value) to login to Aviatrix controller."
}
output "result" {
  value				= module.aviatrix-controller-init.result
	description	=	"Result of initializing the Aviatrix controller."
}
