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
