resource "aws_ecs_service" "MainService" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.MainCluster.id
  task_definition = aws_ecs_task_definition.MainDefinition.arn
  desired_count   = 1

  network_configuration {
    security_groups  = ["${var.sg_ecs_id}"]
    subnets          = ["${var.subnet_public_subnet_1a_id}"]
    assign_public_ip = true
  }

  capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}
