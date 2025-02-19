# Using required inputs
module "alb-test" {
  source = "../aws/alb"

  app_name        = "test_name1"
  app_env         = "test_env1"
  vpc_id          = "vpc-0123abcd"
  security_groups = ["sg-1234bcde"]
  subnets         = ["subnet-2345cdef"]
  certificate_arn = "arn:aws:acm:us-east-1:0123456789012:certificate/44f68dac-d9f1-4d2f-94e6-a8231965f8ed"
}

# Using required and optional inputs
module "alb-test2" {
  source = "../aws/alb"

  app_name                  = "test_name1"
  app_env                   = "test_env1"
  vpc_id                    = "vpc-0123abcd"
  security_groups           = ["sg-1234bcde"]
  subnets                   = ["subnet-2345cdef"]
  certificate_arn           = "arn:aws:acm:us-east-1:0123456789012:certificate/44f68dac-d9f1-4d2f-94e6-a8231965f8ed"
  port                      = "80"
  protocol                  = "HTTP"
  alb_name                  = "alb-test2"
  internal                  = false
  ssl_policy                = "ELBSecurityPolicy-2016-08"
  tg_name                   = "tg-test2"
  health_check_interval     = "30"
  health_check_path         = "/"
  health_check_port         = "traffic-port"
  health_check_protocol     = "HTTP"
  health_check_timeout      = "5"
  healthy_threshold         = "5"
  unhealthy_threshold       = "2"
  health_check_status_codes = "200"
  idle_timeout              = "60"
  load_balancer_type        = "application"
  enable_ipv6               = true
}
