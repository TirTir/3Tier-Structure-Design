####################################
#   Network Load Balancing
####################################
resource "aws_lb" "network-load-balancing" {
  name               = "network-load-balancing"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [var.was-sg-id]
  subnets            = [var.pri-sub1-id, var.pri-sub2-id]

  tags = {
    Name = "network-load-balancing"
  }
}

####################################
#   Load Balancing Listener
####################################
resource "aws_lb_listener" "nlb-listener" {
  load_balancer_arn = aws_lb.network-load-balancing.arn
  port              = "8080"
  protocol          = "TCP"

  default_action{
    type = "forward"
    target_group_arn = aws_lb_target_group.nlb-target-group.arn
  }
}

####################################
#   Load Balancing Target Group
####################################
resource "aws_lb_target_group" "nlb-target-group" {
  name     = "nlb-target-group"
  port     = 8080
  protocol = "TCP"
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

# ####################################
# #   Load Balancing Rule
# ####################################
# resource "aws_lb_listener_rule" "nlb-rule" {
#   listener_arn = aws_lb_listener.nlb-listener.arn
#   priority     = 100

#   action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.nlb-target-group.arn
#   }

#   condition {
#     path_pattern {
#       values = ["*"]
#     }
#   }
# }