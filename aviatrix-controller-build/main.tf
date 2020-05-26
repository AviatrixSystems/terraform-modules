resource aws_eip controller_eip {
  count = var.num_controllers
  vpc   = true
  tags  = local.common_tags
}

resource aws_eip_association eip_assoc {
  count         = var.num_controllers
  instance_id   = aws_instance.aviatrixcontroller[count.index].id
  allocation_id = aws_eip.controller_eip[count.index].id
}

resource aws_network_interface eni-controller {
  count           = var.num_controllers
  subnet_id       = var.subnet
  security_groups = [aws_security_group.AviatrixSecurityGroup.id]
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}Aviatrix Controller interface : {count.index}"
  })
}

resource aws_instance aviatrixcontroller {
  count                   = var.num_controllers
  ami                     = local.ami_id
  instance_type           = var.instance_type
  key_name                = var.keypair
  iam_instance_profile    = var.ec2role
  disable_api_termination = var.termination_protection

  network_interface {
    network_interface_id = aws_network_interface.eni-controller[count.index].id
    device_index         = 0
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}AviatrixController-${count.index}"
  })

  lifecycle {
    ignore_changes = [
      ami
    ]
  }
}
