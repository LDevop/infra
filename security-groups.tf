# security group creation and attcahing in ecs, alb etc

# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "alb-sg" {
  name        = "load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.cluster-vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = var.alb_listener_port
    to_port     = var.alb_listener_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# this security group for ecs - Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.cluster-vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.alb-sg.id]
  }
  ingress {
    protocol    = "tcp"
    from_port   = var.alb_listener_port
    to_port     = var.alb_listener_port
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Mariadb Access from within the VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
