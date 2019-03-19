data "aws_caller_identity" "current" {}

module "iam_roles" {
  source            = "github.com/AviatrixSystems/terraform-modules.git/aviatrix-controller-iam-roles"
  master-account-id = "${data.aws_caller_identity.current.account_id}"
}
