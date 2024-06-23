resource "aws_ecs_service" "catalog-api-service" {
  name            = "catalog-api"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task-catalog-api.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    security_groups = [aws_security_group.ecs_task.id]
    subnets         = aws_subnet.private.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.catalog.id
    container_name   = aws_ecs_task_definition.task-catalog-api.family
    container_port   = 8080
  }

   depends_on = [
    aws_cloudwatch_log_group.ecs_catalog_api,
    aws_cloudwatch_log_stream.ecs_catalog_api,
    aws_lb_target_group.catalog,
    aws_lb_listener.catalog
  ]
}
