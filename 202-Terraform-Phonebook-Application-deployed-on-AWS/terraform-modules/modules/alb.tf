resource "aws_lb" "alb_pb" {
  name               = "alb_pb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-010160dfb5df45701", "subnet-038551d19ccabf2d2"]

  enable_deletion_protection = false

  

  tags = {
    Name = "alb_pb"
  }
}
######################


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb_pb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "authenticate-cognito"

  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

#################

resource "aws_lb_listener_rule" "health_check" {
  listener_arn = aws_lb_listener.front_end.arn

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "HEALTHY"
      status_code  = "200"
    }
  }

  condition {
    query_string {
      key   = "health"
      value = "check"
    }

    query_string {
      value = "bar"
    }
  }
}

########################



