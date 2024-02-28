# aws/cloudtrail - CloudTrail
This module is used to set up CloudTrail logging for your AWS account.

## What this does

 - Create S3 bucket for CloudTrail logs
 - Create IAM user with read-only access to CloudTrail S3 bucket
 - Enable CloudTrail logging

## Required Inputs

- `s3_bucket_name` - The name for the S3 bucket where your CloudTrail logs will be stored

## Optional Inputs

- `cloudtrail_name` - The name for your Trail in AWS CloudTrail. Default: `"aws-account-cloudtrail"`
- `is_multi_region_trail` - Whether the trail is created in the current region or in all regions. Default: `false`

## Outputs

_none_

## Example Usage

```hcl
module "cloudtrail" {
  source          = "github.com/silinternational/terraform-modules//aws/cloudtrail"
  cloudtrail_name = "${var.cloudtrail_name}"
  s3_bucket_name  = "YOUR-AWS-ACCOUNT-cloudtrail-logs"
}
```
