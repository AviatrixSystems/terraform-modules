# Variable declarations for TF Regression Testbed Aviatrix access account setup

variable "aws_acc_number" {
  type          = string
  description   = "AWS Account number."
}
variable "aws_acc_access_key" {
  type          = string
  description   = "AWS access key."
}
variable "aws_acc_secret_key" {
  type          = string
  description   = "AWS secret key."
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
variable "gcp_credentials_filepath" {
  type          = string
  description   = "GCP credentials filepath in local machine."
}
