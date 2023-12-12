####################################
#   Application Load Balancing
####################################
resource "aws_lb" "application-load-balancing" {
  name               = "application-load-balancing"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web-sg-id]
  subnets            = [var.pub-sub1-id, var.pub-sub2-id]

  tags = {
    Name = "application-load-balancing"
  }
}

####################################
#   Load Balancing Listener
####################################
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.application-load-balancing.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

####################################
#   Load Balancing Target Group
####################################
resource "aws_lb_target_group" "alb-target-group" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

####################################
#   Load Balancing Rule
####################################
resource "aws_lb_listener_rule" "alb-rule" {
  listener_arn = aws_lb_listener.alb-listener.arn
  priority     = 100

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}