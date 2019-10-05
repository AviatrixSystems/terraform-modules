## Aviatrix - Terraform Modules - ARM VNET Setup

### Description
This Terraform module creates an ARM VNET for the Regression Testbed environment. VNET includes: 1 public subnet, 1 private subnet, public ubuntu, private ubuntu. SSH open to 0.0.0.0/0. Nested module of the Terraform Regression Testbed module.

### Usage:
To create a filled ARM VNET:
```
provider "azurerm" {

}

module "arm-vnet" {
  source          	    = "./modules/testbed-vnet-arm"
  region                = "<<insert arm region>>"
  vnet_count	  	      = <<insert amount of vnets>> ie: 2
  resource_name_label	  = "<<insert label name>>"
  vnet_cidr        	    = ["<<insert vnet cidr here> ie: 10.10.0.0/16"]
  pub_subnet_cidr     	= ["<<insert subnet cidr ie: 10.10.5.0/24 >"]
  pri_subnet_cidr     	= ["<<insert subnet cidr ie: 10.10.5.0/24 >"]
  public_key            = "<<insert public key>>"
}
```

### Variables

- **region**

The region for the vnet.

- **vnet_count**

The number of vnets to create in the given arm region.

- **resource_name_label**

The label for the resource name.

- **pub_hostnum**

The number to be used for public ubuntu instance private ip host part.

- **pri_hostnum**

The number to be used for private ubuntu instance private ip host part.

- **vnet_cidr**

ARM VNET cidr.

- **pub_subnet_cidr**

Public subnet cidr

- **pri_subnet_cidr**

Private subnet cidr

- **public_key**

Public key used for ubuntu instance.

### Outputs

- **vnet_id**

VNET ID.

- **vnet_name**

VNET Name.

- **subnet_name**

Names of the subnets in the VNET.

- **subnet_cidr**

Cidr of the subnets in the VNET.

- **ubuntu_name**

Name of the Ubuntu instances.

- **ubuntu_public_ip**

Public IP of the Ubuntu instances. Only the public instances have a public IP.

- **ubuntu_private_ip**

Private IP of the Ubuntu instances.

- **ubuntu_id**

Instance ID of the Ubuntu instances.
