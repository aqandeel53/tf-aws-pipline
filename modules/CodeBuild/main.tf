resource "aws_codebuild_project" "build_project" {
  name         = var.project_name
  service_role = var.service_role_arn
  source {
    type = "CODEPIPELINE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"
    environment_variable {
      name  = "ENV_VAR_NAME"
      value = "env_var_value"
    }
  }

  tags = var.tags
}
# # Create the CodeBuild project
# resource "aws_codebuild_project" "build_project" {
#   name          = var.project_name
#   service_role  = var.service_role_arn
#   build_timeout = var.build_timeout

#   artifacts {
#     type      = "S3"
#     location  = var.artifact_bucket
#     packaging = "ZIP"
#   }

#   environment {
#     compute_type          = "BUILD_GENERAL1_SMALL"
#     image                 = "aws/codebuild/standard:5.0"
#     type                  = "LINUX_CONTAINER"
#     environment_variables = var.environment_variables
#   }

#   source {
#     type      = "CODECOMMIT"
#     location  = var.source_repository_url
#     buildspec = var.buildspec
#   }

#   tags = var.tags
# }



