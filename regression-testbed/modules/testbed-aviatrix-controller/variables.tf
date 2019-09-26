# Variable declarations for TF Regression Testbed Aviatrix Controller setup

# Controller VPC Set up
variable "vpc_cidr" {
	type					= string
	description		= "AWS VPC cidr being created for the Aviatrix controller."
}
variable "subnet_cidr" {
	type					= string
	description		= "Public subnet cidr of the vpc being created for the Aviatrix controller."
}
variable "public_key" {
	type					= string
	description		= "Public key to create a new key pair for the controller."
}
variable "sg_source_ip" {
  type          = string
  description   = "Source IP that AWS security group will allow for controller."
}

# Controller set up for build
variable "termination_protection" {
	type					= bool
	description		= "Whether termination protection is enabled for the controller."
}
variable "resource_name_label" {
  type					= string
  description		= "The label for the resource name."
}

# Controller set up for initialization
variable "admin_email" {
	type					= string
	description		= "Admin email to be used for the Aviatrix controller."
}
variable "admin_password" {
	type					= string
	description		= "Admin password to be used for logging into the Aviatrix controller."
}
variable "access_account" {
	type					= string
	description		= "Account name for this AWS access account to be used for the Aviatrix controller."
}
variable "customer_id" {
	type					= string
	description		= "Customer license ID for the Aviatrix controller, if using BYOL controller."
}
