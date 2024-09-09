##############################################################################################################
#
#
#
#
#
#                           CodePipeline Configuration
#
# Creates a CodePipeline with:
# - Pipeline name and role ARN from variables
# - Artifact store configured with S3 bucket
# - Source stage using CodeStarSourceConnection with GitHub configuration
# - Build stage using CodeBuild with input and output artifacts
# - Deploy stage using CodeDeploy with deployment configuration
# - Tags from variable
#
#
#
#
##############################################################################################################

resource "aws_codepipeline" "pipeline" {
  name     = var.pipeline_name
  role_arn = var.pipeline_role_arn

  artifact_store {
    type     = "S3"
    location = var.artifact_bucket
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        #Owner         = var.github_owner
        FullRepositoryId = var.github_repo
        BranchName       = var.github_branch
        ConnectionArn    = var.codestar_connection_arn
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName     = var.codedeploy_application_name
        DeploymentGroupName = var.codedeploy_deployment_group_name
      }
    }
  }

  tags = var.tags
}
