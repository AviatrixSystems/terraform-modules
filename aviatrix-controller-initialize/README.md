## Aviatrix - Terraform Modules - Aviatrix Controller Initialize

### Description

This Terraform module initializes a newly created Aviatrix Controller.

### Usage

``` terraform
module "aviatrix_controller_init" {
   source = "github.com/AviatrixSystems/terraform-modules.git/aviatrix-controller-initialize"
   admin_email = "<<< enter the administrator email address >>>"
   admin_password = "<<< enter the new administrator password >>>"
   private_ip = "<<< enter the Aviatrix Controller's private IP address (initial admin password >>>"
   public_ip = "<<< enter the Aviatrix Controller's public IP address >>>"
   aviatrix_account_name = "<<< enter the account name mapping to your AWS account in the Aviatrix Controller >>>"
}
```

### Variables

- **admin_email**

The administrator's email address.  This email address will be used for password recovery as well as for notifications from the Controller.

- **admin_password**

The administrator's password.  The default password is the Controller's private IP addresses.  It will be changed to this value as part of the initialization.

- **private_ip**

The Controller's private IP address.

- **public_ip**

The Controller's public IP address.

- **aviatrix_account_name**

A friendly name mapping to your AWS account ID

### Outputs

None
