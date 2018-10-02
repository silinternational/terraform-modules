output "cloudtrail_access_key_id" {
  value = "${aws_iam_access_key.cloudtrail-s3.id}"
}

output "cloudtrail_access_key_secret" {
  value = "${aws_iam_access_key.cloudtrail-s3.secret}"
}

output "cloudtrail_arn" {
  value = "${aws_iam_user.cloudtrail-s3.arn}"
}

output "cloudtrail_username" {
  value = "${aws_iam_user.cloudtrail-s3.name}"
}
