resource "aws_ecs_task_definition" "MainDefinition" {
  family                   = "${var.app_name}-definition"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.ecs_iam_role
  task_role_arn            = var.ecs_iam_role
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
    {
      name      = "${var.app_name}"
      image     = "${var.api_repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.api_port
          hostPort      = var.api_port
        }
      ]
      environment = [
        {
          name  = "KINESIS_STREAM_NAME"
          value = var.kinesis_stream_name
        },
      ]
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = {
    Name = "${var.app_name}-template"
  }
}
