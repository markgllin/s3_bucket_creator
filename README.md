# Terraforming ECS Fargate

This repo uses Terraform to deploy the following infrastructure to AWS:

- An ECS cluster with a task definition to execute [s3_bucket_creator](https://github.com/markgllin/s3_bucket_creator/tree/main/docker)
- An ECR repository to host the image
- ECS container log group
- a single VPC with a private subnet and VPC endpoints to communicate with necessary AWS services

All roles were created with the principal of least privilege in mind. This is also why tasks are deployed to a private subnet as they do not require external access for bucket creation. 

# Requirements
The following are needed to start:
- An AWS account
- Terraform v1.1.7

# Infrastructure Deployment
You can deploy this same infrastructure to AWS through Github Actions or from your local machine.

## Github Actions
1. Fork the repository
2. Add your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as repository secrets
3. update `main.tf` accordingly with your own backend configuration
    
    i . if using S3 your backend, ensure your CD user has the [minimal permissions](https://www.terraform.io/language/settings/backends/s3#s3-bucket-permissions) to write to s3 and the s3 bucket to which you're writing your state to already exists

4. Push to `main` and a `terraform apply` workflow will be automatically executed

In addition to permissions to write the state to S3, your CD user will also require permissions to create the resources being deployed.

## Local Deployment

1. Clone the repository locally
2. update `main.tf` accordingly with your own backend configuration. 
3. `terraform init`
4. `terraform plan` to view the planned resources
5. `terraform apply` to deploy resources

Similar to deploying with GHA, your user must have proper permissions to create the resources.

# CI/CD
There is a mandatory status check for a valid terraform plan before a pr can be merged. The workflow is largely identical to HashiCorp's GHA [example](https://learn.hashicorp.com/tutorials/terraform/github-actions).

Despite sharing the same repo, application and infrastructure deployment is decoupled so that they can be deployed independently. The TF workflows will ignore the `docker/` dir while the image deployment workflow will only monitor `docker/` for changes.

# Problems
- tag immutability is disabled for the ECR repo. This was to simplify the redeployment of the same task definition with an updated image using the same `latest` tag.

# Future
Aside from addressing above problems (and the problems w/ docker image), additional things that could be done:
- add a cloudwatch alarm to alert if bucket creation failed. At the moment, there is no visibility on task execution after deployment is completed.
- add a lifecycle policy to clean up unused images in ECR. Although the task definition executes the `latest` image, the image is also pushed to ECR with its github `sha`. This is to provide some form of versioning.