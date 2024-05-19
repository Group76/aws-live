resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster"
}

resource "aws_ecs_task_definition" "task-catalog-api" {
  family                   = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name   = "catalog-api"
      image  = "catalog-ecr-repository:latest"
      cpu    = 512
      memory = 1024
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      essential = true
    }
  ])
}

resource "aws_ecs_service" "catalog-api-service" {
  name            = "catalog-api"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task-catalog-api.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.sg_shared.id]
    assign_public_ip = true
  }
}