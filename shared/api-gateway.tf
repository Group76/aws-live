resource "aws_apigatewayv2_vpc_link" "main" {
  name        = "vpc-link"
  security_group_ids = [ aws_security_group.alb_security_group.id ]
  subnet_ids = [ aws_subnet.private_subnet_1.id ]
}

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "integration" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  description      = "Api gateway for load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.tcp.arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.main.id
}

resource "aws_apigatewayv2_route" "load_balancer_route" {
  depends_on         = [aws_apigatewayv2_integration.integration]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "ANY /{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.integration.id}"
}