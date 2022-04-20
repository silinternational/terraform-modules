# aws/backup/rds - AWSBackup of databases
This module is used to create scheduled backups of AWS databases.


## Required Inputs

- `app_name` - Name of application, ex: Doorman, IdP, etc.
- `app_env` - Name of environment, ex: prod, test, etc.
- `aws_access_key` - Access key to allow access via the AWS CLI
- `aws_secret_key` - Secret access key to allow access via the AWS CLI
- `source_arns` - List of ARN's of the databases to backup

### Optional Inputs

- `backup_cron_schedule` - Default: "11 1 * * ? *"
- `notification_events` - Default: ["BACKUP_JOB_STARTED", "BACKUP_JOB_COMPLETED", "BACKUP_JOB_FAILED", "RESTORE_JOB_COMPLETED"]


## Outputs

- `bkup_key_id` - The backup key ID
- `bkup_key_arn` - The backup key ARN
- `bkup_vault_arn` - The backup vault ARN
- `bkup_cron_scheduled` - The cron schedule for making backups
- `sns_notification_events` - The events that trigger SNS notifications


## Example Usage

```hcl
module "backup_rds" {
  source = "github.com/silinternational/terraform-modules//aws/backup/rds"
  app_name = var.app_name
  app_env = var.app_env
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  source_arns = ["arn:aws:rds:us-east-1:123456789012:db:my-db"]
  backup_cron_schedule = "11 1 * * ? *"
  notification_events = ["BACKUP_JOB_STARTED", "BACKUP_JOB_COMPLETED", "BACKUP_JOB_FAILED", "RESTORE_JOB_COMPLETED"]
}
```
