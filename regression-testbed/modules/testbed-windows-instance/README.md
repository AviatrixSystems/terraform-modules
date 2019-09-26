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
  providers = {
	aws = aws.controller
  }
  vpc	  	= "<<insert VPC here> ie. vpc-xxxxxx>"
  subnet  	= "<<insert public subnet id ie.: subnet-9x3237xx>>"
  sg_source_ip	= "<<insert source ip to allow rdp>> ie: 10.10.1.0"
  windows_ami	= "<<insert ami for instance>> ie: ami-0acfa9d37b413b160"
  keypair 	= "<<insert keypair name ie.: keypairname>>"
  termination_protection = <<true/false>>
}
```

### Variables

- **vpc**

VPC ID to launch Windows instance in.

- **subnet**

Public subnet ID to launch Windows in.

- **sg_source_ip**

Source IP that Windows instance security group will allow for ingress RDP rule.

- **windows_ami**

Amazon Machine Id to create the Windows instance from.

- **keypair**

Name of the key pair used to connect to the instance.

- **termination_protection**

Whether to enable termination protection for Windows instance.

- **resource_name_label**

The label for the resource name.

### Outputs

- **public_ip**

Public IP of the windows instance.

- **key**

Key pair name of the windows instance.
