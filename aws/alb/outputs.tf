output "id" {
  value = "${aws_alb.alb.id}"
}

output "arn" {
  value = "${aws_alb.alb.arn}"
}

output "dns_name" {
  value = "${aws_alb.alb.dns_name}"
}

output "default_tg_id" {
  value = "${aws_alb_target_group.default.id}"
}

output "default_tg_arn" {
  value = "${aws_alb_target_group.default.arn}"
}

output "https_listener_arn" {
  value = "${aws_alb_listener.https.arn}"
}
