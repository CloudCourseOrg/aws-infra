resource "aws_lb" "application_load_balancer" {
  name                       = "alb"
  internal                   = false         //routing values to internet therefore false
  load_balancer_type         = "application" // because this is an application load balancer
  security_groups            = [aws_security_group.loadbalancer_sg.id]
  subnets                    = var.subnet_ids //public subnets az1 from vpc module take the ids from that output folders
  enable_deletion_protection = false
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name = "webapp-tg"
  # target_type = "ip"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id // from vpc module

  health_check {
    enabled             = true
    interval            = 30
    path                = "/healthz"
    timeout             = 5
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = var.app_port

  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
