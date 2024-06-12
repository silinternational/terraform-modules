output "s3_access_key_id" {
  value       = one(aws_iam_access_key.cloudtrail-s3[*].id)
  description = "The (optional) Access Key ID for the IAM user"
}

output "s3_access_key_secret" {
  value       = one(aws_iam_access_key.cloudtrail-s3[*].secret)
  sensitive   = true
  description = "The (optional) Access Key Secret for the IAM user"
}
