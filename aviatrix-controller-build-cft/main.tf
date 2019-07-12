/*
 * This module builds an Aviatrix controller.
 */

/* AWS TF provider */
provider "aws" {
  alias      = "controller"
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

/* avtx controller, roles, etc (using quick start cloud formation stack) */
resource "aws_cloudformation_stack" "controller_quickstart" {
  provider     = "aws.controller"
  name         = "aviatrix-controller"
  template_url = "https://s3-us-west-2.amazonaws.com/aviatrix-cloudformation-templates/aws-cloudformation-aviatrix-metering-controller.json"
  parameters   = {
    VPCParam          = var.vpc_id
    SubnetParam       = var.subnet_id
    KeyNameParam      = var.aws_key_pair_name
    IAMRoleParam      = var.aws_iam_role
    InstanceTypeParam = var.aws_ec2_instance_size
  }
  capabilities = [ "CAPABILITY_NAMED_IAM" ] /* to allow roles to be created */
}

