output "alb_id" {
  value = "${aws_alb.alb.id}"
}
output "alb_arn" {
  value = "${aws_alb.alb.arn}"
}
output "alb_dns_name" {
  value = "${aws_alb.alb.dns_name}"
}
output "tg_id" {
  value = "${aws_alb_target_group.tg.id}"
}
output "tg_arn" {
  value = "${aws_alb_target_group.tg.arn}"
}
