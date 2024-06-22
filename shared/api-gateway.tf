resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "vpclink"
  security_group_ids = [aws_security_group.lb.id]
  subnet_ids         = aws_subnet.private.*.id
}

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "restaurant-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "integration_lb_catalog" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  description      = "Api gateway for load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.catalog.arn
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
    aws_lb.default,
    aws_apigatewayv2_api.api_gateway            
  ]
}

resource "aws_apigatewayv2_route" "get_product_route" {
  depends_on         = [aws_apigatewayv2_integration.integration_lb_catalog]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "GET /v1/product/type/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.integration_lb_catalog.id}"
}

resource "aws_apigatewayv2_route" "create_product_route" {
  depends_on         = [aws_apigatewayv2_integration.integration_lb_catalog]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "POST /v1/product"
  target             = "integrations/${aws_apigatewayv2_integration.integration_lb_catalog.id}"
}

resource "aws_apigatewayv2_route" "create_product_test_route" {
  depends_on         = [aws_apigatewayv2_integration.integration_lb_catalog]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "POST /v1/product-test"
  target             = "integrations/${aws_apigatewayv2_integration.integration_lb_catalog.id}"
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id = aws_apigatewayv2_api.api_gateway.id
  name   = "catalog"
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

# Set who can invoke this API Gateway via AssumeRole
resource "aws_iam_role" "api_gateway_role" {
  name = "apigw-to-alb-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        "Principal": {
            "Service": [
                "apigateway.amazonaws.com"
            ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_policy_attachment" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = aws_iam_policy.api_invocation_policy.arn
}
 
# Policy to attach to the above invocation role
resource "aws_iam_policy" "api_invocation_policy" {
  name = "apigw-to-alb-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeRules"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ],
        Resource = "arn:aws:elasticloadbalancing:*"
      }
    ]
  })
}

output "api_endpoint" {
  value = aws_apigatewayv2_stage.api_stage.invoke_url
}