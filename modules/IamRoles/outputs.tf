output "codepipeline_role_arn" {
  description = "ARN of the CodePipeline IAM Role"
  value       = aws_iam_role.codepipeline_role.arn
}

output "codebuild_role_arn" {
  description = "ARN of the CodeBuild IAM Role"
  value       = aws_iam_role.codebuild_role.arn
}

output "codedeploy_role_arn" {
  description = "ARN of the CodeDeploy IAM Role"
  value       = aws_iam_role.codedeploy_role.arn
}
