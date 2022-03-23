resource "aws_vpc" "ecs_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "VPC-${var.aws_region}"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name              = "private-${var.availability_zone}"
    availability_zone = var.availability_zone
  }
}

resource "aws_route_table" "ecs_rtb" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "ecs_rtb-${var.availability_zone}"
  }
}

resource "aws_route_table_association" "ecs_rta_private" {
  route_table_id = aws_route_table.ecs_rtb.id
  subnet_id      = aws_subnet.private.id
}

resource "aws_vpc_endpoint" "ecr-dkr-vpce" {
  vpc_id              = aws_vpc.ecs_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids = [ aws_security_group.allow_tcp_over_443_vpce.id]
}

resource "aws_vpc_endpoint" "ecr-api-vpce" {
  vpc_id              = aws_vpc.ecs_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids = [aws_security_group.allow_tcp_over_443_vpce.id]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.ecs_vpc.id
  service_name    = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [aws_route_table.ecs_rtb.id]
}
