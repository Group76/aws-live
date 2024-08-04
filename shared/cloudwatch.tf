resource "aws_cloudwatch_log_group" "ecs_catalog_api" {
  name = "/ecs/catalog-api"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "ecs_catalog_api" {
  name           = "ecs/catalog-api"
  log_group_name = aws_cloudwatch_log_group.ecs_catalog_api.name
}

resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name = "/aws/apigateway"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "api_gw_logs" {
  name           = "aws/apigateway"
  log_group_name = aws_cloudwatch_log_group.api_gw_logs.name
}

resource "aws_cloudwatch_log_group" "ecs_client_api" {
  name = "/ecs/client-api"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "ecs_client_api" {
  name           = "ecs/client-api"
  log_group_name = aws_cloudwatch_log_group.ecs_client_api.name
}

resource "aws_cloudwatch_log_group" "ecs_order_api" {
  name = "/ecs/order-api"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "ecs_order_api" {
  name           = "ecs/order-api"
  log_group_name = aws_cloudwatch_log_group.ecs_order_api.name
}