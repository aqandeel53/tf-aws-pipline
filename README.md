# Terraform AWS CI/CD Pipeline

This repository contains Terraform configuration files to set up a continuous integration and deployment pipeline using AWS services. The pipeline builds and deploys a Node.js application from a public GitHub repository to an EC2 instance using the following modules:

- **CodeBuild** - Configures the AWS CodeBuild project to build the application.

- **CodeDeploy** - Sets up the AWS CodeDeploy application and deployment group.

- **CodePipeline** - Defines the AWS CodePipeline to orchestrate the build and deployment process.

- **IamRoles** - Manages the IAM roles and policies required for CodePipeline, CodeBuild, and CodeDeploy.

## Project Structure

- `modules/`

- `codebuild/` - Contains CodeBuild project configuration.

- `codedeploy/` - Contains CodeDeploy application and deployment group configuration.

- `codepipeline/` - Contains CodePipeline configuration.

- `iamroles/` - Contains IAM roles and policies configuration.

- `main.tf` - Root Terraform configuration file that references the modules and sets up the resources.

- `variables.tf` - Contains the variables used in the root module.

- `terraform.tfvars` (optional) - File for setting variable values.

## Prerequisites

- Terraform CLI (v1.0 or later)

- AWS CLI configured with appropriate credentials

- An AWS account

- A public GitHub repository for the source code

- Node.js application ready to be built and deployed

## Setup Instructions

### 1. Clone the Repository

Clone this repository to your local machine:

```bash

git clone <repository-url>

cd <repository-directory>

```

### 2. Configure Variables

Example `terraform.tfvars`:

```hcl

pipeline_name                    = "my-nodejs-app-pipeline"
pipeline_role_arn                = "arn:aws:iam::123456789012:role/my-codepipeline-role" # Replace with your IAM role ARN
artifact_bucket                  = "my-tf-test-bucket"
github_owner                     = "your-github-username" # Replace with your GitHub username or organization name
github_repo                      = "your-repo-name"       # Replace with your GitHub repository name
codebuild_project_name           = "my-codebuild-project"
codedeploy_application_name      = "my-codedeploy-app"
codedeploy_deployment_group_name = "my-codedeploy-deployment-group"
tags = {
  Environment = "Production"
}
```

### 3. Initialize Terraform

Run `terraform init` to initialize the Terraform working directory:

```bash

terraform init

```

### 4. Validate Configuration

Optionally, run `terraform validate` to check for syntax errors:

```bash

terraform validate

```

### 5. Plan the Deployment

Generate an execution plan to preview the changes:

```bash

terraform plan

```

### 6. Apply the Configuration

Apply the Terraform configuration to create the resources:

```bash

terraform apply

```
