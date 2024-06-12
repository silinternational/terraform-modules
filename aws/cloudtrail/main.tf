resource "aws_s3_bucket" "cloudtrail" {
  bucket        = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "AWSCloudTrailAclCheck"
          Effect = "Allow"
          Principal = {
            Service = "cloudtrail.amazonaws.com"
          }
          Action   = "s3:GetBucketAcl"
          Resource = "arn:aws:s3:::${var.s3_bucket_name}"
        },
        {
          Sid    = "AWSCloudTrailWrite"
          Effect = "Allow"
          Principal = {
            Service = "cloudtrail.amazonaws.com"
          }
          Action   = "s3:PutObject"
          Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
          Condition = {
            StringEquals = {
              "s3:x-amz-acl" = "bucket-owner-full-control"
            }
          }
        },
      ]
  })
}

resource "aws_iam_user" "cloudtrail-s3" {
  name = "cloudtrail-s3-${var.s3_bucket_name}"
}

resource "aws_iam_user_policy" "cloudtrail-s3" {
  name = "cloudtrail-s3"
  user = aws_iam_user.cloudtrail-s3.name

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "s3:GetBucketPolicy",
            "s3:GetObject",
            "s3:ListBucket",
          ],
          Resource = [
            aws_s3_bucket.cloudtrail.arn,
            "${aws_s3_bucket.cloudtrail.arn}/*",
          ]
        },
      ]
  })
}

resource "aws_iam_access_key" "cloudtrail-s3" {
  count = var.create_access_key ? 1 : 0
  user  = aws_iam_user.cloudtrail-s3.name
}

resource "aws_cloudtrail" "cloudtrail" {
  count                         = 1
  name                          = var.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  is_multi_region_trail         = var.is_multi_region_trail
}

