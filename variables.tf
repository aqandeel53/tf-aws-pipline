# Variables for CodePipeline
variable "pipeline_name" {
  description = "Name of the CodePipeline"
  type        = string
}

# variable "pipeline_role_arn" {
#   description = "IAM Role ARN for CodePipeline"
#   type        = string
# }

# variable "artifact_bucket" {
#   description = "S3 bucket for storing artifacts"
#   type        = string
# }

variable "github_owner" {
  description = "Owner of the GitHub repository"
  type        = string
}

variable "github_repo" {
  description = "Name of the GitHub repository"
  type        = string
}

variable "github_branch" {
  description = "Name of the GitHub Branch"
  type        = string
}

variable "source_repository_url" {
  description = "Source Repository URL"
  type        = string
}

variable "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "codedeploy_application_name" {
  description = "Name of the CodeDeploy application"
  type        = string
}

variable "codedeploy_deployment_group_name" {
  description = "Name of the CodeDeploy deployment group"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}


variable "codestar_connection_arn" {
  description = "ARN of github connection"
  type        = string
}
variable "ec2_tag_name" {
  description = "Name of EC2"
  type        = string
}
