# Outputs for TF Regression Testbed ARM VNET environment setup

output "vnet_id" {
	value	= azurerm_virtual_network.vnet[*].id
}

output "vnet_name" {
	value	= azurerm_virtual_network.vnet[*].name
}

output "subnet_name" {
	value	= concat(
		azurerm_subnet.public_subnet[*].name,
		azurerm_subnet.private_subnet[*].name
	)
}

output "subnet_cidr" {
	value	= concat(
		azurerm_subnet.public_subnet[*].address_prefix,
		azurerm_subnet.private_subnet[*].address_prefix
	)
}

output "ubuntu_name" {
	value	= concat(
		azurerm_virtual_machine.ubuntu_public[*].name,
		azurerm_virtual_machine.ubuntu_private[*].name
	)
}

output "ubuntu_public_ip" {
	value	= azurerm_public_ip.public_ip[*].ip_address
}

output "ubuntu_private_ip" {
	value = concat(
		azurerm_network_interface.network_interface1[*].private_ip_address,
		azurerm_network_interface.network_interface2[*].private_ip_address
	)
}

output "ubuntu_id" {
	value	= concat(
		azurerm_virtual_machine.ubuntu_public[*].id,
		azurerm_virtual_machine.ubuntu_private[*].id
	)
}
