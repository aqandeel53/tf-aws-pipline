##############################################################################################################
#
#
#
#
#
#                           AWS Provider and Terraform Backend Configuration
#
# Specifies the AWS region and S3 backend for storing Terraform state files:
# - AWS Provider: Sets the region to eu-north-1
# - Backend: Configures S3 as the backend for Terraform state storage with bucket name and key
#
#
#
#
##############################################################################################################

provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-test-12"
    key    = "terraform.tfstate"
    region = "eu-north-1"
  }
}
