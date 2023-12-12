####################################
#   WEB Autoscaling 
####################################
resource "aws_autoscaling_group" "web-autoscaling" {
  name                      = "web-autoscaling"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true

  launch_configuration      = aws_launch_configuration.web-configuration.name
  vpc_zone_identifier       = [var.pub-sub1-id, var.pub-sub2-id]
  target_group_arns = [aws_lb_target_group.alb-target-group.arn]

  tag {
    key                 = "Name"
    value               = "web-autoscaling"
    propagate_at_launch = false
  }
  lifecycle {
    create_before_destroy = true
  }
}

####################################
#   WAS Autoscaling 
####################################
resource "aws_autoscaling_group" "was-autoscaling" {
  name                      = "was-autoscaling"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true

  launch_configuration      = aws_launch_configuration.was-configuration.name
  vpc_zone_identifier       = [var.pri-sub1-id, var.pri-sub2-id]
  target_group_arns = [aws_lb_target_group.nlb-target-group.arn]

  tag {
    key                 = "Name"
    value               = "was-autoscaling"
    propagate_at_launch = false
  }
  lifecycle {
    create_before_destroy = true
  }
}