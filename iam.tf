data "aws_iam_policy_document" "ecs_sts_assume_role-document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# for pulling container images and publishing container logs to Cloudwatch
resource "aws_iam_role" "ecs_task_exec_role" {
  assume_role_policy = data.aws_iam_policy_document.ecs_sts_assume_role-document.json

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
  name                = "ecs_task_exec_role"
  path                = "/${local.service_name}/"
}
