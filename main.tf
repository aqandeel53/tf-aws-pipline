##############################################################################################################
#
#
#
#
#
#                           Terraform Resources and Modules Configuration
#
# Defines an S3 bucket and multiple Terraform modules for IAM roles, CodeBuild, CodeDeploy, and CodePipeline:
# - S3 Bucket: Creates a bucket for storing pipeline artifacts with specified tags.
# - IAM Module: Defines IAM roles for CodePipeline, CodeBuild, and CodeDeploy.
# - CodeBuild Module: Configures a CodeBuild project with environment variables and tags.
# - CodeDeploy Module: Configures a CodeDeploy application and deployment group with specified tags.
# - CodePipeline Module: Sets up a CodePipeline with specified configuration and sources.
#
#
#
#
##############################################################################################################


# Create S3 Bucket
resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-124245"

  tags = {
    Name        = "pipeline-artifacts-1"
    Environment = "Dev"
  }
}

# IAM Module
module "iam" {
  source                 = "./modules/IamRoles"
  codepipeline_role_name = "codepipeline-role-1"
  codebuild_role_name    = "codebuild-role-1"
  codedeploy_role_name   = "codedeploy-role-1"
}

# CodeBuild Module
module "codebuild" {
  source                = "./modules/CodeBuild"
  project_name          = "my-nodejs-app-build"
  service_role_arn      = module.iam.codebuild_role_arn
  source_repository_url = var.source_repository_url
  environment_variables = [
    {
      name  = "NODE_ENV"
      value = "production"
    }
  ]
  tags = {
    Environment = "Production"
  }
}



# CodeDeploy Module
module "codedeploy" {
  source                = "./modules/CodeDeploy"
  application_name      = "my-nodejs-app-deploy"
  deployment_group_name = "my-nodejs-app-deployment-group"
  service_role_arn      = module.iam.codedeploy_role_arn
  ec2_tag_name          = var.ec2_tag_name
  tags = {
    Environment = "Production"
  }
}



# CodePipeline Module
module "codepipeline" {
  source                           = "./modules/CodePipeline"
  pipeline_name                    = "my-nodejs-app-pipeline"
  pipeline_role_arn                = module.iam.codepipeline_role_arn
  artifact_bucket                  = aws_s3_bucket.b.bucket
  github_owner                     = var.github_owner
  github_repo                      = var.github_repo
  github_branch                    = var.github_branch
  codestar_connection_arn          = var.codestar_connection_arn
  codebuild_project_name           = module.codebuild.project_name
  codedeploy_application_name      = module.codedeploy.application_name
  codedeploy_deployment_group_name = module.codedeploy.deployment_group_name
  tags = {
    Environment = "Production"
  }
}

