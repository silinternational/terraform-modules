/*
 * Create application load balancer
 */
resource "aws_alb" "alb" {
  name            = "alb-${var.tag_app_name}-${var.tag_app_env}"
  internal        = false
  security_groups = ["${var.security_groups}"]
  subnets         = ["${var.subnets}"]

  tags {
    Name = "alb-${var.tag_app_name}-${var.tag_app_env}"
    app_name = "${var.tag_app_name}"
    app_env = "${var.tag_app_env}"
  }
}

/*
 * Create target group for ALB
 */
resource "aws_alb_target_group" "tg" {
  name     = "alb-tg-${var.tag_app_name}-${var.tag_app_env}"
  port     = "${var.port}"
  protocol = "${var.protocol}"
  vpc_id   = "${var.vpc_id}"
}

/*
 * Create listeners to connect ALB to target group
 */
resource "aws_alb_listener" "https" {
  count = "${var.enable_https}"
  load_balancer_arn = "${aws_alb.alb.arn}"
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "${var.ssl_policy}"
  certificate_arn = "${var.certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.tg.arn}"
    type = "forward"
  }
}
resource "aws_alb_listener" "http" {
  count = "${var.enable_http}"
  load_balancer_arn = "${aws_alb.alb.arn}"
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.tg.arn}"
    type = "forward"
  }
}
