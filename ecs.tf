resource "aws_ecs_cluster_capacity_providers" "ecs_fargate_cp" {
  cluster_name       = aws_ecs_cluster.ecs_s3_ct_bkt.name
  capacity_providers = ["FARGATE_SPOT"]
}

resource "aws_ecs_cluster" "ecs_s3_ct_bkt" {
  name = local.service_name

  tags = {
    Name = local.service_name
  }
}

resource "aws_ecs_task_definition" "ecs_s3_ct_bkt_td" {
  family             = "ecs-${local.service_name}-td"
  execution_role_arn = aws_iam_role.ecs_task_exec_role.arn

  cpu          = "256"
  memory       = "512"
  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  runtime_platform {
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      cpu               = 0
      memory            = 156
      memoryReservation = 128
      name              = local.service_name
      essential         = true
      image             = "${aws_ecr_repository.ecr_s3_ct_bkt.repository_url}"
    }
  ])
}