## Aviatrix - Terrform Modules - Onprem Setup

### Description
This Terraform modules sets up a onprem connection for simulation in the Regression Testbed environment. Creates an AWS VPC, AWS VGW, AWS CGW, AWS VPN connection, Aviatrix GW, and Aviatrix Site2Cloud connection.

### Pre-requisites

* An existing VPC
* An Aviatrix controller
* An Aviatrix access account

### Usage:
To create an onprem connection:
```
module "onprem-connection" {
  source                 = "./modules/testbed-onprem_s2c"
  account_name           = "<<insert access account name>>"

  onprem_vpc_cidr        = "<<insert cidr for vpc>>"
  pub_subnet_cidr        = "<<insert cidr for subnet>>"
  pri_subnet_cidr        = "<<insert cidr for subnet>>"
  pub_subnet_az          = "<<insert availability zone>>"
  pri_subnet_az          = "<<insert availability zone>>"
  pub_hostnum            = "<<insert public instance hostnum>>"
  pri_hostnum            = "<<insert private instance hostnum>>"

  termination_protection = <<true/false>>
  public_key             = file("<<public key filepath")
  ubuntu_ami             = ""
  local_subnet_cidr      = "<<insert local subnet cidr for s2c>>"
}
```

### Variables
- **account_name**

Access account name in Aviatrix controller.

- **onprem_vpc_cidr**

VPC cidr for onprem VPC.

- **pub_subnet_cidr**

Subnet cidr to launch Aviatrix GW and public ubuntu instance into.

- **pri_subnet_cidr**

Subnet cidr to launch private ubuntu instance into.

- **pub_subnet_az**
- **pri_subnet_az**

Subnet availability zone.

- **pub_hostnum**

Number to be used for public ubuntu instance private ip host part.

- **pri_hostnum**

Number to be usde for private ubuntu instance private ip host part.

- **termination_protection**

Whether to turn on EC2 instance termination protection.

- **public_key**

Public key to ssh into ubuntu instances.

- **ubuntu_ami**

AMI of the ubuntu instances.

- **local_subnet_cidr**

Local subnet cidr for Site2Cloud connections. Optional.

### Outputs

- **onprem_vpc_info**

Displays the vpc name and id.
```
onprem_vpc_info = [
  "<<vpc name>>",
  "<<vpc id>>",
  "<<vpc cidr>>",
]
```

- **onprem_public_subnet_info**

Displays the public subnet name and cidr block.
```
onprem_public_subnet_info = [
  "<<subnet name>>",
  "<<subnet cidr>>"
]
```

- **onprem_private_subnet_info**

Displays the private subnet name and cidr block.
```
onprem_private_subnet_info = [
  "<<subnet name>>",
  "<<subnet cidr>>"
]
```

- **onprem_public_ubuntu_info**

Displays the public ubuntu name, id, public ip, and private ip.
```
onprem_public_ubuntu_info = [
  "<<instance name>>",
  "<<instance id>>",
  "<<instance public ip>>",
  "<<instance private ip>>",
]
```

- **onprem_private_ubuntu_info**

Displays the private ubuntu name, id, and private ip.
```
onprem_private_ubuntu_info = [
  "<<instance name>>",
  "<<instance id>>",
  "<<instance private ip>>",
]
```

- **onprem_aviatrix_gw_info**

Displays the aviatrix gateway name and cloud instance id.
```
onprem_aviatrix_gw_info = [
  "<<gw name>>",
  "<<gw instance id>>"
]
```

- **onprem_vgw_info**

Displays the aws vpn gateway name and id.
```
onprem_vgw_info = [
  "<<vgw name>>",
  "<<vgw id>>"
]
```

- **onprem_cgw_info**

Displays the aws customer gateway name and id.
```
onprem_cgw_info = [
  "<<cgw name>>",
  "<<cgw id>>"
]
```

- **onprem_vpn_info**

Displays the vpn connection name and id.
```
onprem_vpn_info = [
  "<<vpn name>>",
  "<<vpn id>>"
]
```

- **onprem_s2c_info**

Displays the aviatrix site2cloud connection name.
```
onprem_s2c_info = [
  "<<s2c connection name>>"
]
```
