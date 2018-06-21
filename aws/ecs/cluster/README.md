# aws/ecs/cluster - EC2 Container Service Cluster
This module is used to create an ECS cluster along with the necessary
IAM roles to function.

## What this does

 - Create ECS cluster named after `app_name` and `app_env`
 - Create IAM roles and policies for ECS services and instances

## Required Inputs

 - `app_name` - Name of application, ex: Doorman, IdP, etc.
 - `app_env` - Name of environment, ex: prod, test, etc.

## Outputs

 - `ecs_cluster_name` - The ECS cluster name
 - `ecs_instance_role_id` - The ID for created IAM role `ecsInstanceRole`
 - `ecs_instance_profile_id` - The ID for created IAM profile `ecsInstanceProfile`
 - `ecs_service_role_id` - The ID for created IAM role `ecsServiceRole`
 - `ami_id` - The ID for the latest ECS optimized AMI

## Usage Example

```hcl
module "ecscluster" {
  source = "github.com/silinternational/terraform-modules//aws/ecs/cluster"
  app_name = "${var.app_name}"
  app_env = "${var.app_env}"
}
```
