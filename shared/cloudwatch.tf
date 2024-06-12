resource "aws_cloudwatch_log_group" "ecs_catalog_api" {
  name = "/ecs/catalog-api"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "ecs_catalog_api" {
  name           = "ecs/catalog-api"
  log_group_name = aws_cloudwatch_log_group.ecs_catalog_api.name
}