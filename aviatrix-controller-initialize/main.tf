resource aws_iam_role iam_for_lambda {
  name = replace("iam_for_lambda_${var.public_ip}", ".", "-")

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource aws_iam_policy lambda-policy {
  name        = "${var.name_prefix}aviatrix-lambda-policy"
  path        = "/"
  description = "Policy for creating aviatrix-lambda-policy"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:CreateNetworkInterface",
        "ec2:AttachNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DetachNetworkInterface",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:ResetNetworkInterfaceAttribute",
        "autoscaling:CompleteLifecycleAction"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource aws_iam_role_policy_attachment attach-policy {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda-policy.arn
}

data aws_region current {}

resource aws_lambda_function lambda {
  s3_bucket     = "aviatrix-lambda-${data.aws_region.current.name}"
  s3_key        = "run_controller_init_setup.zip"
  function_name = replace("AvxLambda_${var.public_ip}", ".", "-")
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "run_controller_init_setup.lambda_handler"
  runtime       = "python3.7"
  description   = "MANAGED BY TERRAFORM"
  timeout       = 900
  vpc_config {
    subnet_ids         = [var.subnet_id]
    security_group_ids = [aws_security_group.AviatrixLambdaSecurityGroup.id]
  }

  tags       = local.common_tags
  depends_on = [aws_iam_role_policy_attachment.attach-policy, aws_security_group.AviatrixLambdaSecurityGroup]
}

resource null_resource delay {
  provisioner local-exec {
    command = "sleep 90"
  }
  depends_on = [aws_lambda_function.lambda]
}

data aws_lambda_invocation example {
  function_name = aws_lambda_function.lambda.function_name
  depends_on    = [null_resource.delay]
  input         = <<JSON
{ "ResourceProperties":
{
  "PrefixStringParam"                  : "avx",
  "LambdaInvokerTypeParam"             : "terraform",
  "AWS_Account_ID"                     : "${var.aws_account_id}",
  "KeywordForCloudWatchLogParam"       : "avx-log",
  "DelimiterForCloudWatchLogParam"     : "---",
  "ControllerPublicIpParam"            : "${var.private_ip}",
  "AviatrixApiVersionParam"            : "v1",
  "AviatrixApiRouteParam"              : "api/",
  "ControllerPrivateIpParam"           : "${var.private_ip}",
  "ControllerAdminPasswordParam"       : "${var.admin_password}",
  "ControllerAdminEmailParam"          : "${var.admin_email}",
  "ControllerVersionParam"             : "latest",
  "ControllerAccessAccountNameParam"   : "${var.access_account_name}",
  "AviatrixCustomerLicenseIdParam"     : "${var.customer_license_id}",
  "_SecondsToWaitForApacheToBeUpParam" : "${var.controller_launch_wait_time}"
}
}
JSON
}