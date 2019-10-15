# Variable declarations for testbed-onprem module

variable "account_name" {
  type        = string
  description = "Access account name in Aviatrix controller."
}

variable "onprem_vpc_cidr" {
  type        = string
  description = "VPC cidr for Onprem VPC."
}

variable "pub_subnet_cidr" {
  type        = string
  description = "Subnet cidr to launch Aviatrix GW and public ubuntu instance into."
}

variable "pub_subnet_az" {
  type        = string
  description = "Subnet availability zone."
}

variable "pri_subnet_cidr" {
  type        = string
  description = "Subnet cidr to launch private ubuntu instance into."
}

variable "pri_subnet_az" {
  type        = string
  description = "Subnet availability zone."
}

variable "pub_hostnum" {
  type        = number
  description = "Numer to be used for public ubuntu instance private ip host part."
}

variable "pri_hostnum" {
  type        = number
  description = "Numer to be used for private ubuntu instance private ip host part."
}

variable "termination_protection" {
  type        = bool
  description = "Whether to turn on EC2 instance termination protection."
}

variable "public_key" {
  type        = string
  description = "Public key to ssh into ubuntu instances."
}

variable "ubuntu_ami" {
  type        = string
  description = "AMI of ubuntu instances."
}

variable "local_subnet_cidr" {
  type        = string
  description = "Local subnet cidr for Site2Cloud connection. Optional."
  default     = ""
}
