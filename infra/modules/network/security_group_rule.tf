# SecurityGroupRules for ecs
resource "aws_security_group_rule" "ecs_in_tcp8000" {
  type              = "ingress"
  from_port         = var.api_port
  to_port           = var.api_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
}

resource "aws_security_group_rule" "ecs_out_http" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
}
