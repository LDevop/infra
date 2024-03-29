#this template we are creating aws application loadbalancer and target group and alb http listener

resource "aws_alb" "alb" {
  name               = "ecs-load-balancer"
  load_balancer_type = "application"
  internal           = false
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.alb-sg.id]
}

resource "aws_alb_target_group" "myapp-tg" {
  name     = "myapp-tg"
  port     = var.app_port #80?
  protocol = "HTTP"
  vpc_id   = aws_vpc.cluster-vpc.id

  health_check {
    healthy_threshold   = "3" #5
    unhealthy_threshold = "3" #2
    timeout             = "3"
    protocol            = "HTTP"
    matcher             = "200"
    path                = var.health_check_path
    interval            = "10"
    port                = "traffic-port"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 600
  }
}

#redirecting all incomming traffic from ALB to the target group
resource "aws_alb_listener" "adminer-app" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.alb_listener_port
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.myapp-tg]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.myapp-tg.arn
  }
}
