resource "aws_ecs_service" "catalog-api-service" {
  name            = "catalog-api"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task-catalog-api.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public_subnet_1.id]
    security_groups  = [aws_security_group.sg_shared.id]
    assign_public_ip = true
  }
}