output "ecs_cluster_name" {
    value = aws_ecs_cluster.ecs_s3_ct_bkt.name
}

output "ecr_repo_url" {
    value = aws_ecr_repository.ecr_s3_ct_bkt.repository_url
}

output "ecr_image_name" {
    value = aws_ecr_repository.ecr_s3_ct_bkt.name
}
output "s3_ct_bkt_td_name" {
    value = aws_ecs_task_definition.ecs_s3_ct_bkt_td.id
}

output "private_subnet_id" {
    value = aws_subnet.private.id
}
