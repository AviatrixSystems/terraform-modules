/*
 * This module builds an Aviatrix controller and initializes it
 */

/* upgrade the controller to the latest */
resource "aviatrix_upgrade" "controller_upgrade_to_latest" {
    version = "latest"
    depends_on = [
    ]
}

/* set the admin email address */
resource "aviatrix_admin_email" "controller_admin_email" {
    admin_email = "${var.admin_email}"
    depends_on = [
        "aviatrix_upgrade.controller_upgrade_to_latest"
    ]
}

/* set the password */
resource "aviatrix_account_user" "controller_admin_password" {
    username = "admin"
    email = "${var.admin_email}"
    what = "password"
    account_name = "admin"
    old_password = "${var.private_ip}"
    new_password = "${var.admin_password}"
    depends_on = [
        "aviatrix_upgrade.controller_upgrade_to_latest",
        "aviatrix_admin_email.controller_admin_email"
    ]
}

/* onboard the AWS account */
resource "aviatrix_account" "first_account" {
    account_name = "${var.aviatrix_account_name}"
    cloud_type = 1
    aws_account_number = "${data.aws_caller_identity.current.account_id}"
    aws_iam = "true"
    aws_role_app = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aviatrix-role-app"
    aws_role_ec2 = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aviatrix-role-ec2"
}
