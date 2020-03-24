resource aws_security_group AviatrixSecurityGroup {
  name        = "${local.name_prefix}AviatrixSecurityGroup"
  description = "Aviatrix - Controller Security Group"
  vpc_id      = var.vpc

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}AviatrixSecurityGroup"
  })
}

resource aws_security_group_rule ingress_rule {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.incoming_ssl_cidr
  security_group_id = aws_security_group.AviatrixSecurityGroup.id
}

resource aws_security_group_rule egress_rule {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.AviatrixSecurityGroup.id
}
