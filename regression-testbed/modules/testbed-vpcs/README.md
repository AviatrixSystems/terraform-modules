## Aviatrix - Terraform Modules - AWS VPC Setup

### Description
This Terraform module creates an AWS VPC for the Regression Testbed environment. VPC includes: 2 public subnets, 1 private subnet, public rtb, private rtb, public ubuntu, private ubuntu. Ubuntu instances have an eip assigned to them and termination protection enabled. SSH and ICMP are open to 0.0.0.0/0. Nested module of the Terraform Regression Testbed module.

### Usage:
To create a filled AWS VPC:
```
module "aws-vpc" {
  source          	  = "./modules/testbed-vpcs"
  vpc_count	        	= "<<insert amount of vpcs>> ie: 2"
  resource_name_label	= "<<insert label name>>"
  pub_hostnum		      = "<<insert host number part>>"
  pri_hostnum		      = "<<insert host number part>>"
  vpc_cidr        	  = ["<<insert vpc cidr here> ie: 10.10.0.0/16"]
  pub_subnet1_cidr    = ["<<insert subnet cidr ie: 10.10.5.0/24>>"]
  pub_subnet2_cidr    = ["<<insert subnet cidr ie: 10.10.5.0/24>>"]
  pri_subnet_cidr     = ["<<insert subnet cidr ie: 10.10.5.0/24>>"]
  pub_subnet1_az    = ["<<insert az>> ie: "us-west-1a"]
  pub_subnet2_az    = ["<<insert az>> ie: "us-west-1a"]
  pri_subnet_az     = ["<<insert az>> ie: "us-west-1a"]
  ubuntu_ami		      = "<<insert ami of ubuntu instance>>"
  public_key      	  = "<<insert public key>>"
  termination_protection = <<true/false>>
}
```

### Variables

- **vpc_count**

The number of vpcs to create in the given aws region.

-**resource_name_label**

The label for the resource name.

- **public_key**

Public key to create a new key pair for the controller.

- **pub_hostnum**

Number to be used for public ubuntu instance private ip host part. Must be a whole number that can be represented as a binary integer.

- **pri_hostnum**

Number to be used for private ubuntu instance private ip host part. Must be a whole number that can be represented as a binary integer.

- **vpc_cidr**

AWS VPC cidr.

- **pub_subnet1_cidr**

Public subnet cidr

- **pub_subnet2_cidr**

Public subnet cidr

- **pri_subnet_cidr**

Private subnet cidr

- **pub_subnet1_az**

Public subnet availability zone.

- **pub_subnet2_az**

Public subnet availability zone.

- **pri_subnet_az**

Private subnet availability zone.

- **ubuntu_ami**

AMI of the ubuntu instances

- **termination_protection**

Boolean value to enable termination protection of the ubuntu instances.

### Outputs

- **vpc_id**

VPC ID.

- **vpc_name**

VPC Name.

- **subnet_name**

Names of the subnets in the VPC.

- **subnet_cidr**

Cidr of the subnets in the VPC.

- **ubuntu_name**

Name of the Ubuntu instances.

- **ubuntu_public_ip**

Public IP of the public Ubuntu instance.

- **ubuntu_private_ip**

Private IP of the Ubuntu instances.

- **ubuntu_id**

Instance ID of the Ubuntu instances.
