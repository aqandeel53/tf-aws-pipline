resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-124245"

  tags = {
    Name        = "pipeline-artifacts-1"
    Environment = "Dev"
  }
}

# # S3 Bucket ACL Resource
# resource "aws_s3_bucket_acl" "b_acl" {
#   bucket = aws_s3_bucket.b.id
#   acl    = "private"
# }

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
  source_repository_url = "https://github.com/aqandeel53/Nodet" #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
  ec2_tag_name          = "node-server" #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
  github_owner                     = "aqandeel53"       # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  github_repo                      = "aqandeel53/Nodet" # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  github_branch                    = "tf"
  codestar_connection_arn          = var.codestar_connection_arn
  codebuild_project_name           = module.codebuild.project_name
  codedeploy_application_name      = module.codedeploy.application_name
  codedeploy_deployment_group_name = module.codedeploy.deployment_group_name
  tags = {
    Environment = "Production"
  }
}

