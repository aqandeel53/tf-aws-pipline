variable "project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "service_role_arn" {
  description = "IAM Role ARN for CodeBuild to use"
  type        = string
}

variable "build_timeout" {
  description = "Build timeout in minutes"
  type        = number
  default     = 60
}

variable "artifact_bucket" {
  description = "S3 bucket for storing build artifacts"
  type        = string
  default     = "my-tf-test-bucket"
}

variable "environment_variables" {
  description = "Environment variables for the build environment"
  type        = list(map(string))
  default     = []
}

variable "source_repository_url" {
  description = "CodeCommit repository URL for source code"
  type        = string
}

variable "buildspec" {
  description = "Path to buildspec file"
  type        = string
  default     = "buildspec.yml"
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
