
# Encryption key for the Backup Vault
resource "aws_kms_key" "bkup_key" {
  description = "${var.app_name}-${var.app_env} backup vault key"

  tags = {
    app_name = var.app_name
    app_env  = var.app_env
  }
}

# Create the Backup vault
resource "aws_backup_vault" "bkup_vault" {
  name        = "${var.app_name}-${var.app_env}-db-backup-vault"
  kms_key_arn = aws_kms_key.bkup_key.arn

  tags = {
    app_name = var.app_name
    app_env  = var.app_env
  }
}

resource "aws_backup_vault_policy" "bkup_vault_policy" {
  backup_vault_name = aws_backup_vault.bkup_vault.name

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Id = "default"
      Statement = [
        {
          Sid = "default"
          Effect = "Allow"
          Principal = {
            AWS = "*"
          }
          Action = [
            "backup:DescribeBackupVault",
            "backup:DeleteBackupVault",
            "backup:PutBackupVaultAccessPolicy",
            "backup:DeleteBackupVaultAccessPolicy",
            "backup:GetBackupVaultAccessPolicy",
            "backup:StartBackupJob",
            "backup:GetBackupVaultNotifications",
            "backup:PutBackupVaultNotifications",
          ]
          Resource = aws_backup_vault.bkup_vault.arn
        }
      ]
    })
}

# Create the Backup plan
resource "aws_backup_plan" "bkup_plan" {
  name = "${var.app_name}-${var.app_env}-db-backup-plan"

  rule {
    rule_name           = "${var.app_name}-${var.app_env}-db-backup-rule"
    target_vault_name   = aws_backup_vault.bkup_vault.name
    schedule            = "cron(${var.backup_cron_schedule})"
    completion_window   = 120 # 2 hours (in minutes)

    lifecycle {
      cold_storage_after = 7 # a week in days
      delete_after       = 60 # around two months in days
    }

    # Metadata you assign to help organize the resources that you create
    recovery_point_tags = {
      datetime = timestamp()
    }
  }

  tags = {
    app_name = var.app_name
    app_env  = var.app_env
  }
}

# Select objects to be backed up
resource "aws_backup_selection" "bkup_selection" {
  name         = "${var.app_name}-${var.app_env}-db-backup-selection"
  plan_id      = aws_backup_plan.bkup_plan.id
  iam_role_arn = aws_iam_role.bkup_role.arn
  resources = var.source_arns
}

# Create the IAM role for backups
resource "aws_iam_role" "bkup_role" {
  name               = "${var.app_name}-${var.app_env}-db-backup-role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = ["sts:AssumeRole"]
          Effect = "allow"
          Principal = {
            Service = ["backup.amazonaws.com"]
          }
        }
      ]
    })
}

resource "aws_iam_role_policy_attachment" "bkup_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.bkup_role.name
}

# Create notifications
resource "aws_sns_topic" "bkup_sns_topic" {
  name = "backup-vault-events"
}

data "aws_iam_policy_document" "bkup_sns_policy" {
  statement {
    actions = [
      "SNS:Publish",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.bkup_sns_topic.arn,
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_sns_topic_policy" "bkup_sns_topic_policy" {
  arn    = aws_sns_topic.bkup_sns_topic.arn
  policy = data.aws_iam_policy_document.bkup_sns_policy.json
}

resource "aws_backup_vault_notifications" "bkup_vault_notifications" {
  backup_vault_name   = aws_backup_vault.bkup_vault.name
  sns_topic_arn       = aws_sns_topic.bkup_sns_topic.arn
  backup_vault_events = var.notification_events
}