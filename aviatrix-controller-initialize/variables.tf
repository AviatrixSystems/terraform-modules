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
variable "aviatrix_account_name" {}
