##############################################################################################################
#
#
#
#
#
#                           CodeDeploy Configuration
#
# Creates a CodeDeploy application and deployment group with:
# - Application name from variable
# - Tags from variable
#
#
#
#
##############################################################################################################

# Create CodeDeploy Application
resource "aws_codedeploy_app" "app" {
  name             = var.application_name
  compute_platform = "Server" # or "ECS" for ECS deployments
}

# Create CodeDeploy Deployment Group
resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = aws_codedeploy_app.app.name
  deployment_group_name = var.deployment_group_name
  service_role_arn      = var.service_role_arn

  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = var.ec2_tag_name
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  tags = var.tags
}
