# Variable declarations for TF Regression Testbed Aviatrix Controller setup

variable "deploy_controller" {
	type 					= bool
	description 	= "Whether to launch Aviatrix controller as part of regression testbed."
}

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

# Controller set up for build
variable "sg_source_ip" {
  type          = list(string)
  description   = "Source IPs that AWS security group will allow for controller."
}
variable "termination_protection" {
	type					= bool
	description		= "Whether termination protection is enabled for the controller."
}
variable "resource_name_label" {
  type					= string
  description		= "The label for the resource name."
}
# This is the default root volume size as suggested by Aviatrix
variable "root_volume_size" {
  default = 32
}
variable "root_volume_type" {
  default = "standard"
}
variable "type" {
  default = "BYOL"
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

# Local values
locals {
  images_metered = {
    us-east-1      = "ami-087b5ab4feb053b4b"
    us-east-2      = "ami-0bc1db3a5b89c6aef"
    us-west-1      = "ami-0a928ae10544ec78e"
    us-west-2      = "ami-0f5b26bac60280d69"
    ca-central-1   = "ami-031442f061af55923"
    eu-central-1   = "ami-0cf0c16d58a50f19b"
    eu-west-1      = "ami-0301c0164e6deb6df"
    eu-west-2      = "ami-04b5c38db962b3c13"
    eu-west-3      = "ami-0a11977b030622939"
    eu-north-1     = "ami-be961dc0"
    ap-east-1      = "ami-05b4cf74"
    ap-southeast-1 = "ami-02ae4a694e26953b2"
    ap-southeast-2 = "ami-06773bff73422d61d"
    ap-northeast-1 = "ami-048dff200571b34fd"
    ap-northeast-2 = "ami-0cb08d1ebcce1495f"
    ap-south-1     = "ami-09b9ca158a576fa9f"
    sa-east-1      = "ami-0f23734bcd9d53cd8"
  }
  images_byol = {
    us-east-1      = "ami-02465f499ff5092e1"
    us-east-2      = "ami-0861f8a0e35a19b0b"
    us-west-1      = "ami-0cf70ae96639f0057"
    us-west-2      = "ami-0d1499f297ecddea6"
    ca-central-1   = "ami-08ca66ca024bbce49"
    eu-central-1   = "ami-0f27d29114cb3e116"
    eu-west-1      = "ami-08d86496a8dcb9d33"
    eu-west-2      = "ami-001bdb44b4e47313a"
    eu-west-3      = "ami-01838788ed74ad98d"
    eu-north-1     = "ami-b2f378cc"
    ap-east-1      = "ami-9a552eeb"
    ap-southeast-1 = "ami-0a9c6a012c943b907"
    ap-southeast-2 = "ami-0e4d20f09c0318644"
    ap-northeast-1 = "ami-0971c3882816c1bc4"
    ap-northeast-2 = "ami-0d5e9b905bf30d2d3"
    ap-south-1     = "ami-0971c3882816c1bc4"
    sa-east-1      = "ami-0696240d0fc2ecc53"
    us-gov-west-1  = "ami-a9afe8c8"
  }
  ami_id = "${var.type == "metered" ? local.images_metered[data.aws_region.current.name] : local.images_byol[data.aws_region.current.name]}"
}
