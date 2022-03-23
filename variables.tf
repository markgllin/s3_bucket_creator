locals {
  environment  = "staging"
  service_name = "s3_bucket_creator"
}

variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "Region to deploy infrastructure to."
}

variable "availability_zone" {
  type        = string
  default     = "us-west-2a"
  description = "Availability zone to deploy infrastructure to."
}
