# ARM VNET Setup

# ARM Resource group
resource "azurerm_resource_group" "rg" {
	name			= "${var.resource_name_label}-testbed"
	location	= var.region

	tags	= {
		environment	= "${var.resource_name_label}-Testbed"
	}
}

# ARM Vnet
resource "azurerm_virtual_network" "vnet" {
	count								= var.vnet_count
	name								= "${var.resource_name_label}-vnet${count.index}"
	resource_group_name	= azurerm_resource_group.rg.name
	location						= azurerm_resource_group.rg.location
	address_space				= [var.vnet_cidr[count.index]]

	tags	= {
		environment	= "${var.resource_name_label}-Testbed"
	}
}

# ARM Private route table
resource "azurerm_route_table" "private_rtb" {
	name 													= "${var.resource_name_label}-pri-rtb"
	location 											= azurerm_resource_group.rg.location
	resource_group_name         	= azurerm_resource_group.rg.name
	disable_bgp_route_propagation	= false

	route {
		name 					 = "denyInternetRoute"
		address_prefix = "0.0.0.0/0"
		next_hop_type  = "None"
	}

	tags = {
		environment 	 = "${var.resource_name_label}-Testbed"
	}
}

resource "azurerm_subnet_route_table_association" "rtb_associate" {
	count 				 = var.vnet_count
	subnet_id 		 = azurerm_subnet.private_subnet[count.index].id
	route_table_id = azurerm_route_table.private_rtb.id
}

# ARM subnet
resource "azurerm_subnet" "public_subnet" {
	count									= var.vnet_count
	name									= "${var.resource_name_label}-pub-subnet${count.index}"
	resource_group_name		= azurerm_resource_group.rg.name
	virtual_network_name	= azurerm_virtual_network.vnet[count.index].name
	address_prefix				= var.pub_subnet_cidr[count.index]
}

resource "azurerm_subnet" "private_subnet" {
	count									= var.vnet_count
	name									= "${var.resource_name_label}-pri-subnet${count.index}"
	resource_group_name		= azurerm_resource_group.rg.name
	virtual_network_name	=	azurerm_virtual_network.vnet[count.index].name
	address_prefix				=	var.pri_subnet_cidr[count.index]
}

# ARM Network SG
resource "azurerm_network_security_group" "network_sg1" {
	name								= "${var.resource_name_label}-pub-network-sg"
	resource_group_name	= azurerm_resource_group.rg.name
	location						= azurerm_resource_group.rg.location

	security_rule {
    name                       = "AllowSSHInbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
	}

	tags = {
		environment	= "${var.resource_name_label}-Testbed"
	}
}

resource "azurerm_network_security_group" "network_sg2" {
	count								= var.vnet_count
	name								= "${var.resource_name_label}-pri-network-sg${count.index}"
	resource_group_name	= azurerm_resource_group.rg.name
	location						= azurerm_resource_group.rg.location

	security_rule {
    name                       = "AllowSSHInbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = azurerm_subnet.public_subnet[count.index].address_prefix
    destination_address_prefix = "*"
	}

	tags = {
		environment	= "${var.resource_name_label}-Testbed"
	}
}

# ARM virtual network interface card
resource "azurerm_network_interface" "network_interface1" {
	count											= var.vnet_count
	name											= "${var.resource_name_label}-public-network-interface${count.index}"
	location									= azurerm_resource_group.rg.location
	resource_group_name				= azurerm_resource_group.rg.name
	network_security_group_id	= azurerm_network_security_group.network_sg1.id

	ip_configuration {
		name													= "${var.resource_name_label}-public-instance-ip-config"
		subnet_id											= azurerm_subnet.public_subnet[count.index].id
		private_ip_address_allocation	= "Static"
		private_ip_address 						= cidrhost(azurerm_subnet.public_subnet[count.index].address_prefix, var.pub_hostnum)
		public_ip_address_id					= azurerm_public_ip.public_ip[count.index].id
	}

	tags = {
		environment	= "${var.resource_name_label}-Testbed"
	}
}

resource "azurerm_network_interface" "network_interface2" {
	count											= var.vnet_count
	name											= "${var.resource_name_label}-private-network-interface${count.index}"
	location									= azurerm_resource_group.rg.location
	resource_group_name				= azurerm_resource_group.rg.name
	network_security_group_id	= azurerm_network_security_group.network_sg2[count.index].id

	ip_configuration {
		name													= "${var.resource_name_label}-private-instance-ip-config"
		subnet_id											= azurerm_subnet.private_subnet[count.index].id
		private_ip_address_allocation	= "Static"
		private_ip_address 						= cidrhost(azurerm_subnet.private_subnet[count.index].address_prefix, var.pri_hostnum)
	}

	tags = {
		environment	= "${var.resource_name_label}-Testbed"
	}
}

# ARM public ip
resource "azurerm_public_ip" "public_ip" {
	count								= var.vnet_count
	name								= "${var.resource_name_label}-public-ip${count.index}"
	location						= azurerm_resource_group.rg.location
	resource_group_name	= azurerm_resource_group.rg.name
	allocation_method		= "Dynamic"

	tags	= {
		environment	= "${var.resource_name_label}-Testbed"
	}
}

# ARM public instance
resource "azurerm_virtual_machine" "ubuntu_public" {
		count									= var.vnet_count
    name                  = "${var.resource_name_label}-ubuntu-public${count.index}"
    location              = azurerm_resource_group.rg.location
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.network_interface1[count.index].id]
    vm_size               = "Standard_B1ls"

    storage_os_disk {
        name              = "${var.resource_name_label}-OsDisk-public-ubuntu${count.index}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "${var.resource_name_label}-public-ubuntu"
        admin_username = "azureuser"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = var.public_key
        }
    }

    tags = {
        environment = "${var.resource_name_label}-Testbed"
    }
}

# ARM private instance
resource "azurerm_virtual_machine" "ubuntu_private" {
		count									= var.vnet_count
		name									= "${var.resource_name_label}-ubuntu-private${count.index}"
		location							=	azurerm_resource_group.rg.location
		resource_group_name		= azurerm_resource_group.rg.name
		network_interface_ids	= [azurerm_network_interface.network_interface2[count.index].id]
		vm_size								= "Standard_B1ls"

   storage_os_disk {
       name              = "${var.resource_name_label}-OsDisk-public-ubuntu${count.index}"
       caching           = "ReadWrite"
       create_option     = "FromImage"
       managed_disk_type = "Premium_LRS"
   }

   storage_image_reference {
       publisher = "Canonical"
       offer     = "UbuntuServer"
       sku       = "16.04.0-LTS"
       version   = "latest"
   }

   os_profile {
       computer_name  = "${var.resource_name_label}-private-ubuntu"
       admin_username = "azureuser"
   }

   os_profile_linux_config {
       disable_password_authentication = true
       ssh_keys {
           path     = "/home/azureuser/.ssh/authorized_keys"
           key_data = var.public_key
			 }
   }

   tags = {
       environment = "${var.resource_name_label}-Testbed"
   }
}
