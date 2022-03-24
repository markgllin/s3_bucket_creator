resource "aws_cloudwatch_log_group" "ecs_s3_ct_bkt" {
  name              = "/ecs/${local.service_name}"
  retention_in_days = 1

  tags = {
    function = "logs"
  }
}
