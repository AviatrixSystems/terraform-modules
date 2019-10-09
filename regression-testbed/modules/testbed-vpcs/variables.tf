# Variable declarations for TF Regression Testbed AWS VPC environment setup

variable "vpc_count" {
	type				= number
	description	= "The number of vpcs to create in the given aws region."
}
variable "resource_name_label" {
	type				= string
	description	= "The label for the resource name."
}
variable "public_key" {
	type				= string
	description	= "Public key used for creating key pair for all instances."
}
variable "pub_hostnum" {
	type				= number
	description = "Number to be used for public ubuntu instance private ip host part. Must be a whole number that can be represented as a binary integer."
}
variable "pri_hostnum" {
	type				= number
	description = "Number to be used for private ubuntu instance private ip host part. Must be a whole number that can be represented as a binary integer."
}
variable "vpc_cidr" {
	type				= list(string)
	description = "The cidr for a vpc."
}
variable "pub_subnet1_cidr" {
	type				= list(string)
  description = "The cidr for public subnet 1."
}
variable "pub_subnet2_cidr" {
	type				= list(string)
  description = "The cidr for public subnet 2."
}
variable "pri_subnet_cidr" {
	type				= list(string)
	description = "The cidr for a private subnet."
}
variable "pub_subnet1_az" {
	type				= list(string)
  description = "The availability zone for public subnet 1."
}
variable "pub_subnet2_az" {
	type				= list(string)
  description = "The availability zone for public subnet 2."
}
variable "pri_subnet_az" {
	type				= list(string)
	description = "The availability zone for a private subnet."
}
variable "ubuntu_ami" {
	type				= string
	description = "AMI of the ubuntu instances"
}
variable "termination_protection" {
	type				= bool
	description	= "Whether to disable api termination for the ubuntu instances."
}
