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

# for container to write to s3
resource "aws_iam_role" "ecs_task_role_s3_create" {
  assume_role_policy = data.aws_iam_policy_document.ecs_sts_assume_role-document.json

  name = "ecs_task_role_s3_create"
  path = "/${local.service_name}/"
}

resource "aws_iam_role_policy_attachment" "allow_s3_ct_bckt_pa" {
  policy_arn = aws_iam_policy.allow_s3_ct_bckt.arn
  role       = aws_iam_role.ecs_task_role_s3_create.name
}

data "aws_iam_policy_document" "allow_s3_ct_bckt_pd" {
  statement {
    sid       = "S3CreateBucketAccess"
    actions   = ["s3:CreateBucket"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::*"]
  }
}
resource "aws_iam_policy" "allow_s3_ct_bckt" {
  name   = "ecs-allow-s3-write"
  path   = "/${local.service_name}/"
  policy = data.aws_iam_policy_document.allow_s3_ct_bckt_pd.json
}