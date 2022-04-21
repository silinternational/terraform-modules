
output "bkup_key_id" {
  value = aws_kms_key.bkup_key.key_id
}

output "bkup_key_arn" {
  value = aws_kms_key.bkup_key.arn
}

output "bkup_vault_arn" {
  value = aws_backup_vault.bkup_vault.arn
}

output "bkup_cron_scheduled" {
  value = var.backup_cron_schedule
}

output "sns_notification_events" {
  value = var.notification_events
}
