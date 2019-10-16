#Output values for Terraform Regression testbed-basic module

# AWS VPC environment
# US West 1

output "west1_vpc_info" {
	value = [
		module.aws-vpc-west1.vpc_name,
		module.aws-vpc-west1.vpc_id
	]
}
output "west1_subnet_info" {
	value = [
		module.aws-vpc-west1.subnet_name,
		module.aws-vpc-west1.subnet_cidr
	]
}
output "west1_ubuntu_info" {
	value = [
		module.aws-vpc-west1.ubuntu_name,
		module.aws-vpc-west1.ubuntu_id,
		module.aws-vpc-west1.ubuntu_public_ip,
		module.aws-vpc-west1.ubuntu_private_ip
	]
}

# US West 2
output "west2_vpc_info" {
	value = [
		module.aws-vpc-west2.vpc_name,
		module.aws-vpc-west2.vpc_id
	]
}
output "west2_subnet_info" {
	value = [
		module.aws-vpc-west2.subnet_name,
		module.aws-vpc-west2.subnet_cidr
	]
}
output "west2_ubuntu_info" {
	value = [
		module.aws-vpc-west2.ubuntu_name,
		module.aws-vpc-west2.ubuntu_id,
		module.aws-vpc-west2.ubuntu_public_ip,
		module.aws-vpc-west2.ubuntu_private_ip
	]
}

# US East 1
output "east1_vpc_info" {
	value = [
		module.aws-vpc-east1.vpc_name,
		module.aws-vpc-east1.vpc_id
	]
}
output "east1_subnet_info" {
	value = [
		module.aws-vpc-east1.subnet_name,
		module.aws-vpc-east1.subnet_cidr
	]
}
output "east1_ubuntu_info" {
	value = [
		module.aws-vpc-east1.ubuntu_name,
		module.aws-vpc-east1.ubuntu_id,
		module.aws-vpc-east1.ubuntu_public_ip,
		module.aws-vpc-east1.ubuntu_private_ip
	]
}

# US East 2
output "east2_vpc_info" {
	value = [
		module.aws-vpc-east2.vpc_name,
		module.aws-vpc-east2.vpc_id
	]
}
output "east2_subnet_info" {
	value = [
		module.aws-vpc-east2.subnet_name,
		module.aws-vpc-east2.subnet_cidr
	]
}
output "east2_ubuntu_info" {
	value = [
		module.aws-vpc-east2.ubuntu_name,
		module.aws-vpc-east2.ubuntu_id,
		module.aws-vpc-east2.ubuntu_public_ip,
		module.aws-vpc-east2.ubuntu_private_ip
	]
}

# Aviatrix Controller
output "controller_public_ip" {
	value = module.aviatrix-controller.public_ip
}
output "controller_key" {
	value = module.aviatrix-controller.keypair_name
}
output "controller_username_password" {
	value = module.aviatrix-controller.username_password
}
output "primary_access_account" {
	value = var.access_account
}

# Windows instance
output "windows_public_ip" {
	value	= module.windows-instance.public_ip
}
output "windows_key" {
	value	= module.windows-instance.key
}
