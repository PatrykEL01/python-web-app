resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role_policy_attachment" "ecs_sm_readonly" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}



resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = var.tags
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task-family"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "myapp"
      image     = var.app_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [{
        containerPort = 8080
        protocol      = "tcp"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/myapp"
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "DB_PASSWORD"
          value = data.aws_secretsmanager_secret_version.db_password.secret_string
        },
        {
          name  = "DB_HOST"
          value = aws_secretsmanager_secret_version.db_connection_string.secret_string
        }
      ]

    }
  ])
  depends_on = [null_resource.create_sm_secret, aws_secretsmanager_secret_version.db_connection_string]
  tags       = var.tags
}



resource "aws_ecs_service" "my_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nlb_tg.arn
    container_name   = "myapp"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.nlb_listener]
  tags       = var.tags
}

resource "aws_cloudwatch_log_group" "ecs_myapp" {
  name              = "/ecs/myapp"
  retention_in_days = 7

  tags = var.tags
}


resource "aws_cloudwatch_log_stream" "ecs_myapp_stream" {
  name           = "ecs-myapp-stream"
  log_group_name = aws_cloudwatch_log_group.ecs_myapp.name

}