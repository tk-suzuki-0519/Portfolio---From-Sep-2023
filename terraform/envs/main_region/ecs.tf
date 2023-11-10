# This tf file consists of ECS and Auto Scaling.
# -----------------------------------
# ECS
# -----------------------------------
resource "aws_ecs_cluster" "cluster" {
  name = format("%s_ecs_cluster", var.env_name)
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs.name
      }
    }
  }
}
resource "aws_ecs_task_definition" "nginx" {
  family = format("%s_nginx_task_definition", var.env_name)
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx-image"
      cpu       = 256
      memory    = 512 # Amount (in MiB)
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  cpu                      = 256
  memory                   = 512 # Amount (in MiB)
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
}
resource "aws_ecs_service" "service" {
  name    = format("%s_ecs_service", var.env_name)
  cluster = aws_ecs_cluster.cluster.arn
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 1
  }
  platform_version = "1.4.0"
  task_definition  = aws_ecs_task_definition.nginx.arn
  desired_count    = 1
  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.fargate_sg.id]
    subnets          = [for subnet in aws_subnet.private_subnet_app : subnet.id]
  }
  enable_execute_command = true
  tags = {
    Name = format("%s_ecs_service", var.env_name)
  }
}

# Auto Scaling
resource "aws_appautoscaling_target" "app_autoscaling_target" {
  service_namespace  = format("%s_app_autoscaling", var.env_name)
  resource_id        = format("service/%s_ecs_cluster/%s_ecs_service", var.env_name, var.env_name)
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = data.aws_iam_role.app_autoscaling_target.arn
  min_capacity       = 1
  max_capacity       = 2
}
data "aws_iam_role" "app_autoscaling_target" {
  name = "AWSServiceRoleForApplicationAutoScaling_ECSService"
}
resource "aws_appautoscaling_policy" "app_autoscaling_scale_up" {
  name               = format("%s_name_app_autoscaling_up", var.env_name)
  service_namespace  = format("%s_app_autoscaling_up", var.env_name)
  resource_id        = format("service/%s_ecs_cluster/%s_ecs_service", var.env_name, var.env_name)
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}
resource "aws_appautoscaling_policy" "app_autoscaling_scale_down" {
  name               = format("%s_name_app_autoscaling_down", var.env_name)
  service_namespace  = format("%s_app_autoscaling_down", var.env_name)
  resource_id        = format("service/%s_ecs_cluster/%s_ecs_service", var.env_name, var.env_name)
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }
}
resource "aws_cloudwatch_metric_alarm" "alarm_cpu_high" {
  alarm_name          = format("%s_cpu_utilization_high", var.env_name)
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  dimensions = {
    ClusterName = format("%s_ecs_cluster", var.env_name)
    ServiceName = format("%s_ecs_service", var.env_name)
  }
  alarm_actions = [aws_appautoscaling_policy.app_autoscaling_scale_up.arn]
}
resource "aws_cloudwatch_metric_alarm" "alarm_cpu_low" {
  alarm_name          = format("%s_cpu_utilization_low", var.env_name)
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = 20
  dimensions = {
    ClusterName = format("%s_ecs_cluster", var.env_name)
    ServiceName = format("%s_ecs_service", var.env_name)
  }
  alarm_actions = [aws_appautoscaling_policy.app_autoscaling_scale_down.arn]
}