resource "aws_apigatewayv2_vpc_link" "main" {
  name        = "vpc-link"
  security_group_ids = [ aws_security_group.sg_shared.id ]
  subnet_ids = [ aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id ]
}

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "integration_lb_catalog" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  description      = "Api gateway for load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.ecs_alb_listener.arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.main.id
  timeout_milliseconds = 10000
}

resource "aws_apigatewayv2_route" "product_route" {
  depends_on         = [aws_apigatewayv2_integration.integration_lb_catalog]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "GET /v1/product/type/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.integration_lb_catalog.id}"
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id = aws_apigatewayv2_api.api_gateway.id
  name   = "$default"
  auto_deploy = true
  default_route_settings {
    logging_level = "INFO"
    detailed_metrics_enabled = true
  }

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
    format = jsonencode({
      requestId            = "$context.requestId"
      ip                   = "$context.identity.sourceIp"
      caller               = "$context.identity.caller"
      user                 = "$context.identity.user"
      requestTime          = "$context.requestTime"
      requestTimeEpoch     = "$context.requestTimeEpoch"
      httpMethod           = "$context.httpMethod"
      resourcePath         = "$context.resourcePath"
      status               = "$context.status"
      protocol             = "$context.protocol"
      responseLength       = "$context.responseLength"
      integrationError     = "$context.integrationErrorMessage"
      integrationStatus    = "$context.integrationStatus"
      integrationLatency   = "$context.integrationLatency"
      responseLatency      = "$context.responseLatency"
      userAgent            = "$context.identity.userAgent"
      stage                = "$context.stage"
      domainName           = "$context.domainName"
      apiId                = "$context.apiId"
    })
  }
}

output "api_endpoint" {
  value = aws_apigatewayv2_stage.api_stage.invoke_url
}