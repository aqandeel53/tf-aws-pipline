variable "codepipeline_role_name" {
  description = "Name of the IAM role for CodePipeline"
  type        = string
  default     = "codepipeline-role"
}

variable "codebuild_role_name" {
  description = "Name of the IAM role for CodeBuild"
  type        = string
  default     = "codebuild-role"
}

variable "codedeploy_role_name" {
  description = "Name of the IAM role for CodeDeploy"
  type        = string
  default     = "codedeploy-role"
}
