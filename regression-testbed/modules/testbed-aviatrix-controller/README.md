## Aviatrix - Terraform Modules - Aviatrix Controller Setup

### Description
This Terraform module builds and initializes an Aviatrix Controller for the Regression Testbed environment. Nested module of the Terraform Regression Testbed module.

### Prerequisites

IAM Roles created.

### Usage:
To create an Aviatrix controller:
```
module "aviatrix-controller" {
  source          = "./modules/testbed-aviatrix-controller"
  vpc_cidr        = "<<insert vpc cidr here>> ie: 10.10.0.0/16"
  subnet_cidr     = "<<insert subnet cidr>> ie: 10.10.5.0/24"
  sg_source_ip    = "<<insert source ip to allow ssh and https>> ie: 10.10.5.0"
  public_key      = "<<insert public key contents>>"
  admin_email     = "<<insert admin email>> ie: user@aviatrix.com"
  admin_password  = "<<insert admin password>> ie: aviatrix123!"
  access_account  = "<<insert access account name>> ie: regression-admin"
  customer_id     = "<<insert customer license id>> ie: user-12345678910.12"
  termination_protection = <<true/false>>
}
```

### Variables

- **vpc_cidr**

VPC cidr to launch Aviatrix controller in.

- **subnet_cidr**

Public subnet cidr to launch Aviatrix controller in.

- **sg_source_ip**

Source IP that Aviatrix controller will allow ssh for.

- **public_key**

Public key to create a new key pair for the controller.

- **admin_email**

Admin email to be used for the Aviatrix controller.

- **admin_password**

Admin password to be used for logging into the Aviatrix controller.

- **access_account**

Account name for this AWS access account to be used for Aviatrix controller.

- **customer_id**

Customer license ID for the Aviatrix controller, if using BYOL controller.

- **termination_protection**

Whether termination protection is enabled for the controller.

- **resource_name_label**

The label for the resource name.

### Outputs

- **vpc**

VPC ID the Aviatrix controller is contained in.

- **subnet**

Public subnet ID the Aviatrix controller is contained in.

- **keypair_name**

Name of key pair to access Aviatrix controller.

- **private_ip**

Private IP of the Aviatrix controller.

- **public_ip**

Public IP of the Aviatrix controller.

- **username_password**

Username (1st value) and password (2nd value) to login to Aviatrix controller.

- **result**

Result of initializing the Aviatrix controller
