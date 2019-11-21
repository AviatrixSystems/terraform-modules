data "aws_caller_identity" "current" {}

locals {
  other-account-id = data.aws_caller_identity.current.account_id
  policy_primary = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": [
              "arn:aws:iam::${local.other-account-id}:root"
            ]
        },
        "Action": [
          "sts:AssumeRole"
        ]
      }
    ]
}
EOF
  policy_cross= <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": [
              "arn:aws:iam::${var.external-controller-account-id}:root",
              "arn:aws:iam::${local.other-account-id}:root"
            ]
        },
        "Action": [
          "sts:AssumeRole"
        ]
      }
    ]
}
EOF
}

variable "external-controller-account-id" {
  default = ""
}
