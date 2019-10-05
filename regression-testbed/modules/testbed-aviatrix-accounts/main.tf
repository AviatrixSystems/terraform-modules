# Terraform configuration file to set up Aviatrix access accounts in controller

# Configure Aviatrix accounts in controller
resource "aviatrix_account" "cross_aws_account" {
 account_name        = "tf_regression_cross_aws"
 cloud_type          = 1
 aws_account_number  = var.cross_aws_acc_number
 aws_access_key      = var.cross_aws_acc_access_key
 aws_secret_key      = var.cross_aws_acc_secret_key
}

resource "aviatrix_account" "azure_account" {
 account_name        = "tf_regression_arm"
 cloud_type          = 8
 arm_subscription_id = var.arm_subscription_id
 arm_directory_id    = var.arm_directory_id
 arm_application_id  = var.arm_application_id
 arm_application_key = var.arm_application_key
}

resource "aviatrix_account" "gcp_account" {
 account_name        = "tf_regression_gcp"
 cloud_type          = 4
 gcloud_project_id   = var.gcp_id
 gcloud_project_credentials_filepath = var.gcp_credentials_filepath
}
