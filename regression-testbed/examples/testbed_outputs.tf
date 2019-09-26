# Outputs for TF Regression testbed

# AWS VPCs
output "us-west-1" {
  value = [module.regression-testbed.west1_vpc_info, module.regression-testbed.west1_subnet_info, module.regression-testbed.west1_ubuntu_info]
}
output "us-west-2" {
  value = [module.regression-testbed.west2_vpc_info, module.regression-testbed.west2_subnet_info, module.regression-testbed.west2_ubuntu_info]
}
output "us-east-1" {
  value = [module.regression-testbed.east1_vpc_info, module.regression-testbed.east1_subnet_info, module.regression-testbed.east1_ubuntu_info]
}
output "us-east-2" {
  value = [module.regression-testbed.east2_vpc_info, module.regression-testbed.east2_subnet_info, module.regression-testbed.east2_ubuntu_info]
}

# Aviatrix Controller
output "controller_public_ip" {
 value = module.regression-testbed.controller_public_ip
}
output "controller_key" {
 value = module.regression-testbed.controller_key
}
output "controller_username_password" {
 value = module.regression-testbed.controller_username_password
}

# Windows instance
output "windows_public_ip" {
 value = module.regression-testbed.windows_public_ip
}
output "windows_key" {
 value = module.regression-testbed.windows_key
}
