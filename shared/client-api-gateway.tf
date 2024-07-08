resource "aws_apigatewayv2_integration" "integration_lb_client" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  description      = "Api gateway for client load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.client.arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id
  timeout_milliseconds = 10000
  credentials_arn  = aws_iam_role.api_gateway_role.arn

  request_parameters = {
    "overwrite:path" = "$request.path"
  }

  depends_on = [ 
    aws_apigatewayv2_vpc_link.vpc_link,
    aws_lb.client,
    aws_apigatewayv2_api.api_gateway            
  ]
}

resource "aws_apigatewayv2_route" "create_client_route" {
  depends_on         = [aws_apigatewayv2_integration.integration_lb_client]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "POST /v1/user"
  target             = "integrations/${aws_apigatewayv2_integration.integration_lb_client.id}"
}

resource "aws_apigatewayv2_route" "get_token_email" {
  depends_on         = [aws_apigatewayv2_integration.integration_lb_client]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "POST /v1/auth/email"
  target             = "integrations/${aws_apigatewayv2_integration.integration_lb_client.id}"
}

resource "aws_apigatewayv2_route" "get_token_document" {
  depends_on         = [aws_apigatewayv2_integration.integration_lb_client]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "POST /v1/auth/document"
  target             = "integrations/${aws_apigatewayv2_integration.integration_lb_client.id}"
}

resource "aws_apigatewayv2_route" "anonymize" {
  depends_on         = [aws_apigatewayv2_integration.integration_lb_client]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "POST /v1/anonymize"
  target             = "integrations/${aws_apigatewayv2_integration.integration_lb_client.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt_auth.id
}

resource "aws_apigatewayv2_stage" "client_stage" {
  api_id = aws_apigatewayv2_api.api_gateway.id
  name   = "client"
  auto_deploy = true

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

output "client_endpoint" {
  value = aws_apigatewayv2_stage.client_stage.invoke_url
}
