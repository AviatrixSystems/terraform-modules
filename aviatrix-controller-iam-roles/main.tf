resource aws_iam_role aviatrix-role-ec2 {
  name               = "${local.name_prefix}aviatrix-role-ec2"
  description        = "Aviatrix EC2 - Created by Terraform+Aviatrix"
  path               = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
         "Effect": "Allow",
         "Principal": {
           "Service": [
              "ec2.amazonaws.com"
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

resource aws_iam_role aviatrix-role-app {
  name               = "${local.name_prefix}aviatrix-role-app"
  description        = "Aviatrix APP - Created by Terraform+Aviatrix"
  path               = "/"
  assume_role_policy = var.external-controller-account-id == "" ? local.policy_primary : local.policy_cross
}

data "http" "iam_policy_assume_role" {
  url = "https://s3-us-west-2.amazonaws.com/aviatrix-download/iam_assume_role_policy.txt"
  request_headers = {
    "Accept" = "application/json"
  }
}

resource aws_iam_policy aviatrix-assume-role-policy {
  name        = "${local.name_prefix}aviatrix-assume-role-policy"
  path        = "/"
  description = "Policy for creating aviatrix-assume-role-policy"
  policy      = data.http.iam_policy_assume_role.body
}

data http iam_policy_ec2_role {
  url = "https://s3-us-west-2.amazonaws.com/aviatrix-download/IAM_access_policy_for_CloudN.txt"
  request_headers = {
    "Accept" = "application/json"
  }
}

resource aws_iam_policy aviatrix-app-policy {
  name        = "${local.name_prefix}aviatrix-app-policy"
  path        = "/"
  description = "Policy for creating aviatrix-app-policy"
  policy      = data.http.iam_policy_ec2_role.body
}

resource aws_iam_role_policy_attachment aviatrix-role-ec2-attach {
  role       = aws_iam_role.aviatrix-role-ec2.name
  policy_arn = aws_iam_policy.aviatrix-assume-role-policy.arn
}

resource aws_iam_role_policy_attachment aviatrix-role-app-attach {
  role       = aws_iam_role.aviatrix-role-app.name
  policy_arn = aws_iam_policy.aviatrix-app-policy.arn
}

resource aws_iam_instance_profile aviatrix-role-ec2_profile {
  name = aws_iam_role.aviatrix-role-ec2.name
  role = aws_iam_role.aviatrix-role-ec2.name
}

