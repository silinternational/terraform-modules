# aws/asg - Auto Scaling Group
This module is used to create an auto scaling group launch configuration and
an auto scaling group that uses the configuration.

## What this does

 - Create launch configuration named after `app_name` and `app_env`
 - Create auto scaling group of defined size and distribute instances across `aws_zones`

## Required Inputs

 - `app_name` - Name of application, ex: Doorman, IdP, etc.
 - `app_env` - Name of environment, ex: production, testing, etc.
 - `ami_id` - ID for AMI to be used.
 - `aws_instance` - A map containing keys for `instance_type`, `volume_size`, `instance_count`
 - `aws_zones` - A list of availability zones to distribute instances across
 - `private_subnet_ids` - A list of private subnet ids to identify VPC subnets for placement
 - `default_sg_id` - VPC default security group ID to add instances to
 - `ecs_instance_profile_id` - IAM profile ID for ecsInstanceProfile
 - `ecs_cluster_name` - ECS cluster name for registering instances

## Outputs

 - `ecs_cluster_name` - The ECS cluster name
 - `ecs_instance_role_id` - The ID for created IAM role `ecsInstanceRole`
 - `ecs_instance_profile_id` - The ID for created IAM profile `ecsInstanceProfile`
 - `ecs_service_role_id` - The ID for created IAM role `ecsServiceRole`

## Example Usage

```hcl
module "asg" {
  source = "github.com/silinternational/terraform-modules//aws/asg"
  app_name = "${var.app_name}"
  app_env = "${var.app_env}"
  aws_instance = "${var.aws_instance}"
  aws_zones = "${var.aws_zones}"
  private_subnet_ids = ["${module.vpc.private_subnet_ids}"]
  default_sg_id = "${module.vpc.vpc_default_sg_id}"
  ecs_instance_profile_id = "${module.ecs.ecs_instance_profile_id}"
  ecs_cluster_name = "${module.ecs.ecs_cluster_name}"
  ami_id = "${module.ecs.ami_id}"
}
```
