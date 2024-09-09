variable "application_name" {
  description = "Name of the CodeDeploy application"
  type        = string
}

variable "deployment_group_name" {
  description = "Name of the deployment group"
  type        = string
}

variable "service_role_arn" {
  description = "IAM Role ARN for CodeDeploy"
  type        = string
}

variable "ec2_tag_name" {
  description = "EC2 Tag for identifying instances to deploy to"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
