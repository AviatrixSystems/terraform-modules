
output "aws-account" {
    value = "${data.aws_caller_identity.current.account_id}"
}

output "aviatrix-role-ec2-name" {
    value = "${aws_iam_role.aviatrix-role-ec2.name}"
}

output "aviatrix-role-app-name" {
    value = "${aws_iam_role.aviatrix-role-app.name}"
}
