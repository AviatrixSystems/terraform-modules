module "regression-testbed" {
  source = "./regression-testbed"
	termination_protection			= false
  resource_name_label         = "regression"

  # Provider
  # AWS Primary
  aws_primary_acct_access_key = ""
  aws_primary_acct_secret_key = ""

  # AWS Cross
  cross_aws_acct_access_key   = ""
  cross_aws_acct_secret_key   = ""

  # ARM
  arm_subscription_id         = ""
  arm_tenant_id              = ""
  arm_client_id               = ""
  arm_client_secret           = ""

  # AWS VPC setup
	# example for 2 vpcs
  vpc_public_key              = ""
  pub_hostnum                 = 20
  pri_hostnum                 = 30

  # US West 1
	# each variable for the cidr are lists
	# because vpc_count is set to 2,
	# make sure there are 2 elements in each list
  vpc_count_west1             = 2
  vpc_cidr_west1              = ["10.1.0.0/16", "10.2.0.0/16"]
  pub_subnet1_cidr_west1      = ["10.1.1.0/24", "10.2.1.0/24"]
  pub_subnet2_cidr_west1      = ["10.1.10.0/24", "10.2.10.0/24"]
  pri_subnet_cidr_west1       = ["10.1.2.0/24", "10.2.2.0/24"]
  pub_subnet1_az_west1        = ["us-west-1a", "us-west-1b"]
  pub_subnet2_az_west1        = ["us-west-1a", "us-west-1b"]
  pri_subnet_az_west1         = ["us-west-1a", "us-west-1b"]
  ubuntu_ami_west1            = "ami-0acfa9d37b413b160"

  # US West 2
  vpc_count_west2             = 2
  vpc_cidr_west2              = ["10.3.0.0/16", "10.4.0.0/16"]
  pub_subnet1_cidr_west2      = ["10.3.1.0/24", "10.4.1.0/24"]
  pub_subnet2_cidr_west2      = ["10.3.10.0/24", "10.4.10.0/24"]
  pri_subnet_cidr_west2       = ["10.3.2.0/24", "10.4.2.0/24"]
  pub_subnet1_az_west1        = ["us-west-2a", "us-west-2b"]
  pub_subnet2_az_west1        = ["us-west-2a", "us-west-2b"]
  pri_subnet_az_west1         = ["us-west-2a", "us-west-2b"]
  ubuntu_ami_west2            = "ami-0eaedb5f9e4e556f4"

  # US East 1
  vpc_count_east1             = 2
  vpc_cidr_east1              = ["10.5.0.0/16", "10.6.0.0/16"]
  pub_subnet1_cidr_east1      = ["10.5.1.0/24", "10.6.1.0/24"]
  pub_subnet2_cidr_east1      = ["10.5.10.0/24", "10.6.10.0/24"]
  pri_subnet_cidr_east1       = ["10.5.2.0/24", "10.6.2.0/24"]
  pub_subnet1_az_east1        = ["us-east-1a", "us-east-1b"]
  pub_subnet2_az_east1        = ["us-east-1a", "us-east-1b"]
  pri_subnet_az_east1         = ["us-east-1a", "us-east-1b"]
  ubuntu_ami_east1            = "ami-0f40d38d3ce4a1354"

  # US East 2
  vpc_count_east2             = 2
  vpc_cidr_east2              = ["10.7.0.0/16", "10.8.0.0/16"]
  pub_subnet1_cidr_east2      = ["10.7.1.0/24", "10.8.1.0/24"]
  pub_subnet2_cidr_east2      = ["10.7.10.0/24", "10.8.10.0/24"]
  pri_subnet_cidr_east2       = ["10.7.2.0/24", "10.8.2.0/24"]
  pub_subnet1_az_west1        = ["us-east-2a", "us-east-2b"]
  pub_subnet2_az_west1        = ["us-east-2a", "us-east-2b"]
  pri_subnet_az_west1         = ["us-east-2a", "us-east-2b"]
  ubuntu_ami_east2            = "ami-09f0299359c12ab7c"

  # AWS Cross Account
  cross_aws_region            = "us-east-2"
  vpc_count_cross_aws         = 2
  vpc_cidr_cross_aws          = ["10.9.0.0/16", "10.10.0.0/16"]
  pub_subnet1_cidr_cross_aws  = ["10.9.0.0/24", "10.10.3.0/24"]
  pub_subnet2_cidr_cross_aws  = ["10.9.1.0/24", "10.10.4.0/24"]
  pri_subnet_cidr_cross_aws   = ["10.9.2.0/24", "10.10.5.0/24"]
  pub_subnet1_az_east1        = ["us-east-2a", "us-east-2b"]
  pub_subnet2_az_east1        = ["us-east-2a", "us-east-2b"]
  pri_subnet_az_east1         = ["us-east-2a", "us-east-2b"]
  ubuntu_ami_cross_aws        = "ami-09f0299359c12ab7c"

  # ARM VNET
  arm_region                  = "East US"
  vnet_count_arm              = 2
  vnet_cidr_arm               = ["10.20.0.0/16", "10.30.0.0/16"]
  pub_subnet_cidr_arm         = ["10.20.1.0/24", "10.30.3.0/24"]
  pri_subnet_cidr_arm         = ["10.20.2.0/24", "10.30.4.0/24"]

	# AWS VPC for controller
  deploy_controller           = <<true/false>>
	controller_region           = "us-west-1"
	controller_vpc_cidr         = "10.22.0.0/16"
	controller_subnet_cidr			= "10.22.23.0/24"
	controller_public_key       = ""
	controller_sg_source_ip     = "0.0.0.0/0"

	# Aviatrix controller
	admin_email                 = ""
	admin_password              = ""
	access_account              = ""
	customer_id                 = ""

	# Windows instance
  deploy_windows              = true
  windows_region              = "us-east-1"
  windows_vpc_cidr            = "20.5.0.0/16"
  windows_subnet_cidr         = "20.5.1.0/24"
  windows_public_key          = ""
  windows_ami                 = "ami-0069635df219ce9e5"
	windows_sg_source_ip        = "0.0.0.0/0"


## Leave following provider/module commented before initial terraform apply
## After successful terraform apply, uncomment:
## provider "aviatrix"
## module "aviatrix-access-accounts"
#
#provider "aviatrix" {
#	controller_ip	= module.regression-testbed.controller_public_ip
#	username			= element(module.regression-testbed.controller_username_password, 0)
#	password			= element(module.regression-testbed.controller_username_password, 1)
#}
#module "aviatrix-access-accounts" {
#  source                = "./regression-testbed/modules/testbed-aviatrix-accounts"
#  cross_aws_acc_number        = ""
#  cross_aws_acc_access_key    = ""
#  cross_aws_acc_secret_key    = ""
#  arm_subscription_id   = ""
#  arm_directory_id      = ""
#  arm_application_id    = ""
#  arm_application_key   = ""
#  gcp_id                   =
#  gcp_credentials_filepath = ""
#}
