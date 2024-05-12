resource "aws_iam_policy" "ecs_ssm_policy" {
  name        = "ECSParameterStoreAccessPolicy"
  description = "Allows ECS tasks to access Systems Manager Parameter Store"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "ssm:GetParametersByPath",
          "ssm:DescribeParameters"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ecs_role" {
  name = "ecs-cluster-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_ssm_policy_attachment" {
  name       = "ECSParameterStoreAccessAttachment"
  roles      = [aws_iam_role.ecs_role.name]
  policy_arn = aws_iam_policy.ecs_ssm_policy.arn
}