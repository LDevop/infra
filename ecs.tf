resource "aws_ecs_cluster" "ecs-cluster" {
  name = "ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_launch_configuration" "ecs" {
  name                        = "${var.name}-for ECS"
  image_id                    = var.amis
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.ecs_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ecs.name
  associate_public_ip_address = true
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER='ecs-cluster' > /etc/ecs/ecs.config"
}

data "template_file" "adminer-app" {
  template = file("./task-definitions/image.json")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "ecs-def" {
  family                   = "task-definition-1"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  container_definitions    = data.template_file.adminer-app.rendered
}

resource "aws_ecs_service" "ecs-service" {
  name            = "ecs-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.ecs-def.arn
  desired_count   = var.app_count
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_alb_target_group.myapp-tg.arn
    container_name   = "adminer-app"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.adminer-app, aws_iam_role_policy_attachment.ecs_task_execution_role, aws_iam_role_policy.ecs-service-role-policy]
}

#------------------------------------GRAFANA-------------------------
/*
resource "aws_ecs_cluster" "grafana" {
  name = "grafana"
}

data "template_file" "grafana" {
  template = file("./task-definitions/grafana.json")
}

resource "aws_ecs_task_definition" "grafana-def" {
  family                   = "task-definition-1"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  container_definitions    = data.template_file.grafana.rendered
}

resource "aws_ecs_service" "grafana" {
  name            = "grafana"
  cluster         = aws_ecs_cluster.grafana.id
  task_definition = aws_ecs_task_definition.grafana-def.arn
  desired_count   = 1
  network_configuration {
    subnets          =  aws_subnet.public.*.id
    security_groups  = [aws_security_group.grafana.id]
    assign_public_ip = true
  }
  launch_type = "EC2"
}
*/
#-----------------------------------------------------------------------------
