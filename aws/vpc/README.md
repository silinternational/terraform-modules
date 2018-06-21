# aws/vpc - Virtual Private Cloud
This module is used to create a VPC along with the necessary configuration to
be useful.

## What this does

 - Create VPC named after `app_name` and `app_env`
 - Create public and private subnets for each `aws_zones` specified
 - Provision a Internet Gateway and configure public subnets to route through it
 - Provision a NAT Gateway and configure private subnets to route through it
 - Create a DB subnet group including all private subnets

## Required Inputs

 - `app_name` - Name of application, ex: Doorman, IdP, etc.
 - `app_env` - Name of environment, ex: prod, test, etc.
 - `aws_zones` - A list of zones to create subnets in, ex: `["us-east-1c", "us-east-1d", "us-east-1e"]`

## Optional Inputs

 - `enable_dns_hostnames` - default `false`

## Outputs

 - `vpc_default_sg_id` - The VPC default security group ID
 - `public_subnet_ids` - A list of the public subnet IDs
 - `public_subnet_cidr_blocks` - A list of public subnet CIDR blocks, ex: `["10.0.10.0/24","10.0.12.0/24"]`
 - `private_subnet_ids` - A list of the private subnet IDs
 - `private_subnet_cidr_blocks` - A list of private subnet CIDR blocks, ex: `["10.0.11.0/24","10.0.22.0/24"]`
 - `db_subnet_group_name` - The name of the DB subnet group

## Example Usage

```hcl
module "vpc" {
  source = "github.com/silinternational/terraform-modules//aws/vpc"
  app_name = "${var.app_name}"
  app_env = "${var.app_env}"
  aws_zones = "${var.aws_zones}"
}
```
