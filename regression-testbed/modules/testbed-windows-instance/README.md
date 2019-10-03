## Aviatrix - Terraform Modules - Windows Instance Setup

### Description
This Terraform module creates a Windows instance for the Regression Testbed environment. Nested module of the Terraform Regression Testbed module.

### Pre-requisites:

* An existing VPC
* An existing public subnet in that VPC
* An internet gateway attached to that VPC
* An AWS Key Pair
* Windows AMI

### Usage:
To create a Windows instance:
```
module "windows-instance" {
  source  	= "./modules/testbed-windows-instance"
  vpc_cidr	  	= "<<insert cidr>> ie: 10.0.0.0/16"
  subnet_cidr  	= "<<insert cidr>> ie: 10.0.0.0/24"
  sg_source_ip	= "<<insert source ip to allow rdp>> ie: 10.10.1.0"
  ami	          = "<<insert ami for instance>> ie: ami-0acfa9d37b413b160"
  public_key 	  = "<<insert public key contents>>"
  termination_protection = <<true/false>>
}
```

### Variables

- **vpc_cidr**

VPC cidr to launch Windows instance in.

- **subnet_cidr**

Public subnet cidr to launch windows instance in.

- **public_key**

Public key to create a new key pair for the controller.

- **sg_source_ip**

Source IP that Windows instance security group will allow for ingress RDP rule.

- **ami**

Amazon Machine Id to create the Windows instance from.

- **termination_protection**

Whether to enable termination protection for Windows instance.

- **resource_name_label**

The label for the resource name.

### Outputs

- **public_ip**

Public IP of the windows instance.

- **key**

Key pair name of the windows instance.
