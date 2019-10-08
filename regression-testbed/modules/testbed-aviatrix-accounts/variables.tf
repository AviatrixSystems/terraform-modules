# Variable declarations for TF Regression Testbed Aviatrix access account setup

variable "cross_aws_acc_number" {
  type          = string
  description   = "Cross AWS Account number."
}
variable "cross_aws_acc_access_key" {
  type          = string
  description   = "Cross AWS access key."
}
variable "cross_aws_acc_secret_key" {
  type          = string
  description   = "Cross AWS secret key."
}

variable "arm_subscription_id" {
  type          = string
  description   = "ARM subscription id."
}
variable "arm_directory_id" {
  type          = string
  description   = "ARM directory id."
}
variable "arm_application_id" {
  type          = string
  description   = "ARM application id."
}
variable "arm_application_key" {
  type          = string
  description   = "ARM application key."
}

variable "gcp_id" {
  type          = string
  description   = "GCloud Project ID."
}
variable "gcp_credentials_filepath" {
  type          = string
  description   = "GCloud Project credentials filepath in local machine."
}
