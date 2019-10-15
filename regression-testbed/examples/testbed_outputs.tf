## Outputs for TF Regression testbed
## Uncomment the outputs for the modules you will be using.
## Comment Aviatrix outputs after destroying the modules,
## before destroying the rest of the resources.

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# AWS Basic Creation module
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# AWS Vpcs
output "us-west-1" {
  value = concat(
    module.testbed-basic.west1_vpc_info,
    module.testbed-basic.west1_subnet_info,
    module.testbed-basic.west1_ubuntu_info
  )
}
output "us-west-2" {
  value = concat(
    module.testbed-basic.west2_vpc_info,
    module.testbed-basic.west2_subnet_info,
    module.testbed-basic.west2_ubuntu_info
  )
}
output "us-east-1" {
  value = concat(
    module.testbed-basic.east1_vpc_info,
    module.testbed-basic.east1_subnet_info,
    module.testbed-basic.east1_ubuntu_info
  )
}
output "us-east-2" {
  value = concat(
    module.testbed-basic.east2_vpc_info,
    module.testbed-basic.east2_subnet_info,
    module.testbed-basic.east2_ubuntu_info
  )
}

# Aviatrix Controller
output "controller_public_ip" {
 value = module.testbed-basic.controller_public_ip
}
output "controller_key" {
 value = module.testbed-basic.controller_key
}
output "controller_username_password" {
 value = module.testbed-basic.controller_username_password
}

# Windows instance
output "windows_public_ip" {
 value = module.testbed-basic.windows_public_ip
}
output "windows_key" {
 value = module.testbed-basic.windows_key
}

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## AWS Cross Account Module (Optional)
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#output "cross_aws_vpc_info" {
#	value = [
#    module.aws-cross-acct.vpc_name,
#    module.aws-cross-acct.vpc_id
#  ]
#}
#output "cross_aws_subnet_info" {
#	value = [
#    module.aws-cross-acct.subnet_name,
#    module.aws-cross-acct.subnet_cidr
#  ]
#}
#output "cross_aws_ubuntu_info" {
#	value = [
#    module.aws-cross-acct.ubuntu_name,
#    module.aws-cross-acct.ubuntu_id,
#    module.aws-cross-acct.ubuntu_public_ip,
#    module.aws-cross-acct.ubuntu_private_ip
#  ]
#}
#
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Azure Vnet Module (Optional)
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#output "arm_vnet_info" {
#	value = [
#    module.arm-vnet.vnet_name,
#    module.arm-vnet.vnet_id
#  ]
#}
#output "arm_subnet_info" {
#	value = [
#    module.arm-vnet.subnet_name,
#    module.arm-vnet.subnet_cidr
#  ]
#}
#output "arm_ubuntu_info" {
#	value = [
#    module.arm-vnet.ubuntu_name,
#    module.arm-vnet.ubuntu_id,
#    module.arm-vnet.ubuntu_public_ip,
#    module.arm-vnet.ubuntu_private_ip
#  ]
#}
#
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Aviatrix Onprem Module
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#output "onprem_vpc_info" {
#  value = module.testbed-onprem.onprem_vpc_info
#}
#output "onprem_subnet_info" {
#  value = [
#    module.testbed-onprem.onprem_public_subnet_info,
#    module.testbed-onprem.onprem_private_subnet_info
#  ]
#}
#output "onprem_ubuntu_info" {
#  value = [
#    module.testbed-onprem.onprem_public_ubuntu_info,
#    module.testbed-onprem.onprem_private_ubuntu_info
#  ]
#}
#output "onprem_aviatrix_gw_info" {
#  value = module.testbed-onprem.onprem_aviatrix_gw_info
#}
#output "onprem_aws_resource_info" {
#  value = [
#    module.testbed-onprem.onprem_vgw_info,
#    module.testbed-onprem.onprem_cgw_info,
#    module.testbed-onprem.onprem_vpn_info
#  ]
#}
#output "onprem_s2c_info" {
#  value = module.testbed-onprem.onprem_s2c_info
#}
