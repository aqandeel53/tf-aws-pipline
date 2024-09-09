##############################################################################################################
#
#
#
#
#
#                           CodeBuild Project Configuration
#
# Defines a CodeBuild project with:
# - Name and service role from variables
# - Source and artifacts types as CODEPIPELINE
# - Environment with specific compute type, image, and variables
# - Tags from variable
#
#
#
#
##############################################################################################################

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


