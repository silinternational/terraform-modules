module "cloudtrail" {
  source          = "../aws/cloudtrail"
  cloudtrail_name = "cloudtrail_name"
  s3_bucket_name  = "s3_bucket_name"
}
