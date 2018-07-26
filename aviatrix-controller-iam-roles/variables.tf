data "aws_caller_identity" "current" {}

locals {
    other-account-id = "${data.aws_caller_identity.current.account_id}"
}
variable "master-account-id" {
}
