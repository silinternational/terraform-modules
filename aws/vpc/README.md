# aws/vpc - Virtual Private Cloud
This module is used to create a VPC along with the necessary configuration to
be useful.

## What this does

 - Create VPC named after `tag_app_name` and `tag_app_env`
 - Create public and private subnets for each `aws_zones` specified
 - Provision a Internet Gateway and configure public subnets to route through it
 - Provision a NAT Gateway and configure private subnets to route through it
 - Create a DB subnet group including all private subnets

## Required Inputs

 - `tag_app_name` - Name of application, ex: Doorman, IdP, etc.
 - `tag_app_env` - Name of environment, ex: production, testing, etc.
 - `aws_zones` - A list of zones to create subnets in, ex: `["us-east-1c", "us-east-1d", "us-east-1e"]`

## Outputs

 - `vpc_default_sg_id` - The VPC default security group ID
 - `public_subnet_ids` - A list of the public subnet IDs
 - `private_subnet_ids` - A list of the private subnet IDs
 - `db_subnet_group_name` - The name of the DB subnet group

## Example Usage

```hcl
module "vpc" {
  source = "github.com/silinternational/terraform-modules//aws/vpc"
  tag_app_name = "${var.tag_app_name}"
  tag_app_env = "${var.tag_app_env}"
  aws_zones = "${var.aws_zones}"
}
```
