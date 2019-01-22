resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_iam_role_policy_attachment" "attach-policy" {
  role       = "${aws_iam_role.iam_for_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

data "aws_region" "current" {}

resource "aws_lambda_function" "lambda" {
  s3_bucket     = "aviatrix-lambda-${data.aws_region.current.name}"
  s3_key        = "run_controller_init_setup.zip"
  function_name = "AvxLambda"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "run_controller_init_setup.lambda_handler"
  runtime       = "python3.7"
  description   = "MANAGED BY TERRAFORM"
  timeout       = 300
}

data "aws_lambda_invocation" "example" {
  function_name   = "${aws_lambda_function.lambda.function_name}"
  
  input = <<JSON
{ "ResourceProperties":
{
  "LambdaInvokerType"                : "terraform",
  "PrefixStringParam"                : "avxxx",
  "AWS_Account_ID"                   : "${var.aws_account_id}",
  "KeywordForCloudWatchLogParam"     : "avx-log",
  "DelimiterForCloudWatchLogParam"   : "---",
  "ControllerPublicIpParam"          : "${var.public_ip}",
  "AviatrixApiVersionParam"          : "v1",
  "AviatrixApiRouteParam"            : "api/",
  "ControllerPrivateIpParam"         : "${var.private_ip}",
  "ControllerAdminPasswordParam"     : "${var.admin_password}",
  "ControllerAdminEmailParam"        : "${var.admin_email}",
  "ControllerVersionParam"           : "latest",
  "ControllerAccessAccountNameParam" : "${var.access_account_name}",
  "AviatrixCustomerLicenseIdParam"   : "${var.customer_license_id}"
}
}
JSON
}

