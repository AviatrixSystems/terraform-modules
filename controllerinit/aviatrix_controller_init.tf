variable "controller_private_ip" {}

variable "controller_public_ip" {}

module "aviatrix_controller_init" {
   source = "github.com/AviatrixSystems/terraform-modules.git/aviatrix-controller-initialize"
   admin_email         = "zhiqiang008@gmail.com"
   admin_password      = "Aa12345678!"
   private_ip          = "${var.controller_private_ip}"
   public_ip           = "${var.controller_public_ip}"
   access_account_name = "zhiqiangjin"
   aws_account_id      = "830104897336"
   customer_license_id = "carmelodev-1393702544.64"
}

output "lambda_result" {
   value = "${module.aviatrix_controller_init.result}"
}
