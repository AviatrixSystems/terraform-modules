data "aws_caller_identity" "current" {}

/* the admin email address */
variable "admin_email" {}

/* the new admin password */
variable "admin_password" {}

/* the private IP of the controller */
variable "private_ip" {}

/* the public IP of the controller */
variable "public_ip" {}

/* the controller account friendly name (mapping to the AWS account ID) */
variable "access_account_name" {}

/* aws account id */
variable "aws_account_id" {}

/* the controller account friendly name (mapping to the AWS account ID) */
variable "customer_license_id" {
  default = ""
}

variable "controller_launch_wait_time" {
  default = 210
}

variable "vpc_id" {}

variable "subnet_id" {}
