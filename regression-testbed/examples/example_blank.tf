module "regression-testbed" {
  source = "<<module path>> ie: ./regression-testbed"
  termination_protection      = <<true/false>>
	resource_name_label					= "<<input label for all resources>>"

  # Provider
  aws_primary_acct_access_key = "<<your aws primary access key>>"
  aws_primary_acct_secret_key = "<<your aws primary secret key>>"

  # AWS VPC setup
  vpc_count                   = <<input number of vpcs to create in each region>>
  vpc_public_key              = "<<your public key to access ubuntu instances>>"
  pub_hostnum                     = <<input instance private ip hostnum>>
  pri_hostnum                     = <<input instance private ip hostnum>>

  # US West 1
  vpc_cidr_west1              = [<<insert cidrs>>]
  pub_subnet1_cidr_west1      = [<<insert cidrs>>]
  pub_subnet2_cidr_west1      = [<<insert cidrs>>]
  pri_subnet_cidr_west1       = [<<insert cidrs>>]
  pri_subnet_cidr_west1       = [<<insert cidrs>>]
  ubuntu_ami_west1            = "<<insert ami>>"

  # US West 2
  vpc_cidr_west2              = [<<insert cidrs>>]
  pub_subnet1_cidr_west2      = [<<insert cidrs>>]
  pub_subnet2_cidr_west2      = [<<insert cidrs>>]
  pri_subnet_cidr_west2       = [<<insert cidrs>>]
  ubuntu_ami_west2            = "<<insert ami>>"

  # US East 1
  vpc_cidr_east1              = [<<insert cidrs>>]
  pub_subnet1_cidr_east1      = [<<insert cidrs>>]
  pub_subnet2_cidr_east1      = [<<insert cidrs>>]
  pri_subnet_cidr_east1       = [<<insert cidrs>>]
  ubuntu_ami_east1            = "<<insert ami>>"

  vpc_cidr_east2              = [<<insert cidrs>>]
  pub_subnet1_cidr_east2      = [<<insert cidrs>>]
  pub_subnet2_cidr_east2      = [<<insert cidrs>>]
  pri_subnet_cidr_east2       = [<<insert cidrs>>]
  ubuntu_ami_east2            = "<<insert ami>>"

  # AWS VPC for controller
  controller_region           = "<<insert region to launch controller>>"
  controller_vpc_cidr         = "<<insert vpc cidr for controller>>"
  controller_subnet_cidr			= "<<insert subnet cidr for controller>>"
  controller_public_key       = "<<insert your public key to access controller and windows instance>>""
  controller_sg_source_ip     = "<<insert controller source ip>>"

  # Aviatrix controller
  admin_email                 = "<<insert your email>>"
  admin_password              = "<<insert password to access controller>>"
  access_account              = "<<insert name for access account>>"
  customer_id                 = "<<insert your license id>>"

  # Windows instance
  windows_region              = "<<insert region to launch windows instance>>"
  windows_vpc_cidr            = "<<insert vpc cidr for windows instance>>"
  windows_subnet_cidr         = "<<insert subnet cidr for windows instance>>"
  windows_public_key          = "<<insert public key to access windows instance>>"
  windows_ami                 = "<<insert windows ami>>"
  windows_sg_source_ip        = "<<insert source ip>>"
}

## Leave following provider/module commented before initial terraform apply
## After successful terraform apply, uncomment:
## provider "aviatrix"
## module "aviatrix-access-accounts"
#
#provider "aviatrix" {
#  controller_public_ip  = module.regression-testbed.controller_public_ip
#  username              = element(module.regression-testbed.controller_username_password, 0)
#  admin_password        = element(module.regression-testbed.controller_username_password, 1)
#}
#
#module "aviatrix-access-accounts" {
#  # this module is within the regression-testbed modules folder
#  source                = "./regression-testbed/modules/testbed-aviatrix-accounts"
#  aws_acc_number        = "<<input aws acc number>>"
#  aws_acc_access_key    = "<<input aws access key>>"
#  aws_acc_secret_key    = "<<input aws secret key>>"
#  arm_subscription_id   = "<<input arm subscription id>>"
#  arm_directory_id      = "<<input arm directory id>>"
#  arm_application_id    = "<<input application id>>"
#  arm_application_key   = "<<input application key>>"
#  gcp_credentials_filepath = "<<input gcp cred filepath>>"
#}
