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

