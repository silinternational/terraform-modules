# aws/ecr - EC2 Container Service Image Repository
This module is used to create an ECS image repository for storage of a Docker
image.

## What this does

 - Create ECR repository named `var.repo_name`
 - Attache ECR policy to allow appropriate access

## Required Inputs

 - `repo_name` - Name of repo, ex: Doorman, IdP, etc.
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `ecsInstanceRole_arn` - ARN for ECS Instance Role
 - `cd_user_arn` - ARN for an IAM user used by a Continuous Delivery service
    for pushing Docker images

## Outputs

 - `repo_url` - The repository url. Ex: `1234567890.dkr.ecr.us-east-1.amazonaws.com/repo-name`

## Usage Example

```hcl
module "ecr" {
  source = "github.com/silinternational/terraform-modules//aws/ecr"
  repo_name = "${var.app_name}-${var.app_env}"
  ecsInstanceRole_arn = "${data.terraform_remote_state.cluster.ecsInstanceRole_arn}"
  ecsServiceRole_arn = "${data.terraform_remote_state.cluster.ecsServiceRole_arn}"
  cd_user_arn = "${data.terraform_remote_state.cluster.cd_user_arn}"
}
```
