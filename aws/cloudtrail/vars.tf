variable "cloudtrail_name" {
  default     = "aws-account-cloudtrail"
  description = "The name for your Trail in AWS CloudTrail"
  type        = string
}

variable "create_access_key" {
  description = "Whether to create an Access Key/Secret for the created IAM user"
  default     = false
  type        = bool
}

variable "is_multi_region_trail" {
  description = "Whether the trail is created in the current region or in all regions"
  type        = bool
  default     = false
}

variable "s3_bucket_name" {
  description = "The name for the S3 bucket where your CloudTrail logs will be stored"
  type        = string
}

