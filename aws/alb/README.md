# aws/alb - Application Load Balancer
This module is used to create an application load balancer along with security
groups for traffic and a default target group.

## What this does

 - Create ALB named after `tag_app_name` and `tag_app_env`
 - Create ALB target group
 - Create HTTPS listener for ALB / Target Group

## Required Inputs

 - `tag_app_name` - Name of application, ex: Doorman, IdP, etc.
 - `tag_app_env` - Name of environment, ex: production, testing, etc.
 - `vpc_id` - ID of VPC for target group.
 - `security_groups` - List of security groups to apply to ALB.
 - `subnets` - A list of public subnet ids for ALB placement
 - `certificate_arn` - ARN to SSL certificate to use with HTTPS listener

### Optional Inputs
 - `port` - Target group listening port. Default: `80`
 - `protocol` - Target group listening protocol. Default: `http`
 - `access_logs_enabled` - Whether or not to enable logging. Default: `false`
 - `access_logs_bucket` - S3 bucket to store logs. Default: `""`

## Outputs

 - `id` - ID for ALB
 - `arn` - ARN for ALB
 - `dns_name` - DNS hostname for ALB
 - `default_tg_id` - ID for Target Group
 - `default_tg_arn` - ARN for Target Group

## Example Usage

```hcl
module "asg" {
  source = "github.com/silinternational/terraform-modules//aws/asg"
  tag_app_name = "${var.tag_app_name}"
  tag_app_env = "${var.tag_app_env}"
  vpc_id = "${module.vpc.id}"
  security_groups = ["${module.vpc.vpc_default_sg_id}","${module.cloudflare-sg.id}"]
  subnets = ["${module.vpc.public_subnet_ids}"]
  certificate_arn = "${data.aws_acm_certificate.name.arn}"
}
```
