resource "aws_ecr_repository" "ecr_s3_ct_bkt" {
  name = local.service_name

  tags = {
    Name = local.service_name
  }
}
