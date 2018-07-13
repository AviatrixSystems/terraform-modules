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
