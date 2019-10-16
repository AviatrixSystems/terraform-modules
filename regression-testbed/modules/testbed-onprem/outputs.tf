output "onprem_vpc_info" {
  value = [
    aws_vpc.onprem_vpc.tags.Name,
    aws_vpc.onprem_vpc.id,
    aws_vpc.onprem_vpc.cidr_block
  ]
}

output "onprem_public_subnet_info" {
  value = [
    aws_subnet.public_subnet.tags.Name,
    aws_subnet.public_subnet.cidr_block
  ]
}

output "onprem_private_subnet_info" {
  value = [
    aws_subnet.private_subnet.tags.Name,
    aws_subnet.private_subnet.cidr_block
  ]
}

output "onprem_public_ubuntu_info" {
  value = [
    aws_instance.public_instance.tags.Name,
    aws_instance.public_instance.id,
    aws_eip.eip.public_ip,
    aws_instance.public_instance.private_ip
  ]
}

output "onprem_private_ubuntu_info" {
  value = [
    aws_instance.private_instance.tags.Name,
    aws_instance.private_instance.id,
    aws_instance.private_instance.private_ip
  ]
}

output "onprem_aviatrix_gw_info" {
  value = [
    aviatrix_gateway.avtx_gw.gw_name,
    aviatrix_gateway.avtx_gw.cloud_instance_id
  ]
}

output "onprem_vgw_info" {
  value = [
    aws_vpn_gateway.aws_vgw.tags.Name,
    aws_vpn_gateway.aws_vgw.id
  ]
}

output "onprem_cgw_info" {
  value = [
    aws_customer_gateway.aws_cgw.tags.Name,
    aws_customer_gateway.aws_cgw.id
  ]
}

output "onprem_vpn_info" {
  value = [
    aws_vpn_connection.vpn.tags.Name,
    aws_vpn_connection.vpn.id
  ]
}

output "onprem_s2c_info" {
  value = [
    aviatrix_site2cloud.onprem_s2c.connection_name
  ]
}
