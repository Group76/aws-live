resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "vpclink"
  security_group_ids = [aws_security_group.lb.id]
  subnet_ids         = aws_subnet.private.*.id
}

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "restaurant-gateway"
  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_authorizer" "jwt_auth" {
  api_id                            = aws_apigatewayv2_api.api_gateway.id
  authorizer_type                   = "REQUEST"
  authorizer_uri                    = aws_lambda_function.auth_function.invoke_arn
  identity_sources                  = ["$request.header.Authorization"]
  name                              = "jwt-authorizer"
  authorizer_payload_format_version = "2.0"
}

resource "aws_lambda_permission" "allow_api_gw_invoke_authorizer" {  
  statement_id  = "allowInvokeFromAPIGatewayAuthorizer"  
  action        = "lambda:InvokeFunction"  
  function_name = aws_lambda_function.auth_function.function_name  
  principal     = "apigateway.amazonaws.com"  
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/authorizers/${aws_apigatewayv2_authorizer.jwt_auth.id}"  
}

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
