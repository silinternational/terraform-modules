variable "cloudtrail_name" {
  default     = "aws-account-cloudtrail"
  description = "The name for your Trail in AWS CloudTrail"
  type        = "string"
}

variable "s3_bucket_name" {
  description = "The name for the S3 bucket where your CloudTrail logs will be stored"
  type        = "string"
}
