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





#################################################################################################################

# SNS Topic for Notifications
resource "aws_sns_topic" "pipeline_notifications" {
  name = "pipeline-notifications"
}

# SNS Subscription for Email Notifications
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.pipeline_notifications.arn
  protocol  = "email"
  endpoint  = "aqandeel53@gmail.com"
}


# failer
#################################################################################################################

# CloudWatch Event Rule for Pipeline Failure
resource "aws_cloudwatch_event_rule" "pipeline_failure_rule" {
  name        = "pipeline-failure-rule"
  description = "Triggers on pipeline failures"

  event_pattern = jsonencode({
    detail = {
      pipeline = ["my-nodejs-app-pipeline"],
      state    = ["FAILED"]
    },
    "detail-type" = ["CodePipeline Pipeline Execution State Change"],
    source        = ["aws.codepipeline"],
    resources     = ["arn:aws:codepipeline:eu-north-1:816069125111:my-nodejs-app-pipeline"]
  })
}


# CloudWatch Event Target for SNS Notification
resource "aws_cloudwatch_event_target" "pipeline_failure_target" {
  rule = aws_cloudwatch_event_rule.pipeline_failure_rule.name
  arn  = aws_sns_topic.pipeline_notifications.arn
}



# seccess
#################################################################################################################

# CloudWatch Event Rule for Pipeline Success
resource "aws_cloudwatch_event_rule" "pipeline_success_rule" {
  name        = "pipeline-success-rule"
  description = "Triggers on pipeline successes"

  event_pattern = jsonencode({
    detail = {
      pipeline = ["my-nodejs-app-pipeline"],
      state    = ["SUCCEEDED"]
    },
    "detail-type" = ["CodePipeline Pipeline Execution State Change"],
    source        = ["aws.codepipeline"],
    resources     = ["arn:aws:codepipeline:eu-north-1:816069125111:my-nodejs-app-pipeline"]
  })
}


# CloudWatch Event Target for CodePipeline
resource "aws_cloudwatch_event_target" "pipeline_success_target" {
  rule     = aws_cloudwatch_event_rule.pipeline_success_rule.name
  arn      = "arn:aws:codepipeline:eu-north-1:816069125111:Node-pipeline"
  role_arn = aws_iam_role.cloudwatch_events_role.arn
}














#roles
#####################################################################################




# IAM Role Policy for CloudWatch to SNS
resource "aws_iam_role_policy" "cloudwatch_sns_policy" {
  name = "cloudwatch-sns-policy"
  role = aws_iam_role.cloudwatch_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "sns:Publish",
        Effect   = "Allow",
        Resource = aws_sns_topic.pipeline_notifications.arn
      }
    ]
  })
}

# IAM Role for CloudWatch Events
resource "aws_iam_role" "cloudwatch_role" {
  name = "cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Role for CloudWatch Events to invoke CodePipeline
resource "aws_iam_role" "cloudwatch_events_role" {
  name = "cloudwatch-events-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}



# IAM Role Policy for CloudWatch Events to invoke CodePipeline
resource "aws_iam_role_policy" "cloudwatch_events_policy" {
  name = "cloudwatch-events-policy"
  role = aws_iam_role.cloudwatch_events_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "codepipeline:StartPipelineExecution",
        Effect   = "Allow",
        Resource = "arn:aws:codepipeline:eu-north-1:816069125111:Node-pipeline"
      }
    ]
  })
}
