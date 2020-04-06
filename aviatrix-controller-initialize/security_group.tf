resource aws_security_group AviatrixLambdaSecurityGroup {
  name        = "${var.name_prefix}AviatrixLambdaSecurityGroup"
  description = "Aviatrix - Lambda Security Group"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}AviatrixLambdaSecurityGroup"
  })
}

resource aws_security_group_rule egress_rule {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.AviatrixLambdaSecurityGroup.id
}