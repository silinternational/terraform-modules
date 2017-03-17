 /*
  * Create ECS IAM Service Role and Policy
  */
resource "aws_iam_role" "ecsServiceRole" {
  name = "ecsServiceRole"
  assume_role_policy = "${var.ecsServiceRoleAssumeRolePolicy}"
}

resource "aws_iam_role_policy" "ecsServiceRolePolicy" {
  name = "ecsServiceRolePolicy"
  role = "${aws_iam_role.ecsServiceRole.id}"
  policy = "${var.ecsServiceRolePolicy}"
}

/*
 * Create UUID for unique resource names
 */
data "template_file" "uuid" {
  template = "$${uuid}"
  vars {
    uuid = "${uuid()}"
  }
}

/*
 * Create application load balancer
 */
resource "aws_alb" "alb" {
  #name            = "${join("",slice(split("","${var.tag_app_name}-${var.tag_app_env}-${data.template_file.uuid.rendered}"),0,31))}"
  name = "alb-${var.tag_app_name}-${var.tag_app_env}"
  internal        = false
  security_groups = ["${var.security_groups}"]
  subnets         = ["${var.subnets}"]

  lifecycle {
    create_before_destroy = true
    #ignore_changes = ["name"]
  }

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
  #name = "${join("",slice(split("","${var.tag_app_name}-${var.tag_app_env}-${data.template_file.uuid.rendered}"),0,31))}"
  name = "testing"
  port     = "${var.port}"
  protocol = "${var.protocol}"
  vpc_id   = "${var.vpc_id}"

  /*lifecycle {
    create_before_destroy = true
    #ignore_changes = ["name"]
  }*/
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

  /*lifecycle {
    create_before_destroy = true
  }*/

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

  /*lifecycle {
    create_before_destroy = true
  }*/

  default_action {
    target_group_arn = "${aws_alb_target_group.tg.arn}"
    type = "forward"
  }
}

/*
 * Get task definition data
 */
data "aws_ecs_task_definition" "td" {
  task_definition = "${aws_ecs_task_definition.td.family}"
}

/*
 * Create task definition
 */
resource "aws_ecs_task_definition" "td" {
  family = "${var.service_name}-${var.service_env}"
  container_definitions = "${var.container_def_json}"
  task_role_arn = "${var.task_role_arn}"
  network_mode = "${var.network_mode}"

  /*lifecycle {
    create_before_destroy = true
  }*/
}

/*
 * Create ECS Service
 */
 resource "aws_ecs_service" "service" {
   name = "${var.service_name}"
   //name = "${join("",slice(split("","${var.service_name}-${data.template_file.uuid.rendered}"),0,31))}"
   //name = "${var.service_name}-rev${max("${aws_ecs_task_definition.td.revision}", "${data.aws_ecs_task_definition.td.revision}")}"
   cluster = "${var.cluster_id}"
   desired_count = "${var.desired_count}"
   iam_role = "${aws_iam_role.ecsServiceRole.arn}"
   depends_on = ["aws_iam_role_policy.ecsServiceRolePolicy", "aws_alb_listener.https"]

   placement_strategy {
     type = "spread"
     field = "host"
   }

   load_balancer {
     target_group_arn = "${aws_alb_target_group.tg.arn}"
     container_name = "${var.lb_container_name}"
     container_port = "${var.lb_container_port}"
   }

   /*lifecycle {
     create_before_destroy = true
   }*/

   # Track the latest ACTIVE revision
   task_definition = "${aws_ecs_task_definition.td.family}:${max("${aws_ecs_task_definition.td.revision}", "${data.aws_ecs_task_definition.td.revision}")}"
 }
