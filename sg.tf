resource "aws_security_group" "allow_tcp_over_443_vpce" {
  name   = "vpce"
  vpc_id = aws_vpc.ecs_vpc.id
}


# VPC endpoint must allow incoming connections on port 443 from the private subnet of the VPC
resource "aws_security_group_rule" "allow_ingress_443_sgr" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.ecs_vpc.cidr_block]
  security_group_id = aws_security_group.allow_tcp_over_443_vpce.id
}