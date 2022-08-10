data "aws_iam_policy_document" "aviatrix-role-ec2" {
  statement {
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com${local.is_aws_cn}"
      ]
    }
    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "aviatrix-role-ec2" {
  name               = local.ec2_role_name
  description        = "Aviatrix EC2 - Created by Terraform+Aviatrix"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.aviatrix-role-ec2.json
}

data "aws_iam_policy_document" "policy_primary" {
  statement {
    principals {
      type        = "AWS"
      identifiers = local.identifiers
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "aviatrix-role-app" {
  name               = local.app_role_name
  description        = "Aviatrix APP - Created by Terraform+Aviatrix"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.policy_primary.json
}

data "aws_iam_policy_document" "aviatrix-assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    resources = local.resource_strings
  }

  statement {
    actions = [
      "aws-marketplace:MeterUsage",
      "s3:GetBucketLocation",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "aviatrix-assume-role-policy" {
  name        = "${local.ec2_role_name}-assume-role-policy"
  path        = "/"
  description = "Policy for creating aviatrix-assume-role-policy"
  policy      = data.aws_iam_policy_document.aviatrix-assume-role-policy.json
}

data "http" "iam_policy_ec2_role" {
  url = "https://s3-us-west-2.amazonaws.com/aviatrix-download/IAM_access_policy_for_CloudN.txt"
  request_headers = {
    "Accept" = "application/json"
  }
}

resource "aws_iam_policy" "aviatrix-app-policy" {
  name        = "${local.app_role_name}-app-policy"
  path        = "/"
  description = "Policy for creating aviatrix-app-policy"
  policy      = data.http.iam_policy_ec2_role.response_body
}

resource "aws_iam_role_policy_attachment" "aviatrix-role-ec2-attach" {
  role       = aws_iam_role.aviatrix-role-ec2.name
  policy_arn = aws_iam_policy.aviatrix-assume-role-policy.arn
}

resource "aws_iam_role_policy_attachment" "aviatrix-role-app-attach" {
  role       = aws_iam_role.aviatrix-role-app.name
  policy_arn = aws_iam_policy.aviatrix-app-policy.arn
}

resource "aws_iam_instance_profile" "aviatrix-role-ec2_profile" {
  name = aws_iam_role.aviatrix-role-ec2.name
  role = aws_iam_role.aviatrix-role-ec2.name
}
