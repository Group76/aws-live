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

# ECS Task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution_role_policy_attach" {
  name = "ecs-task-execution-role-policy-attach"
  roles = [
    aws_iam_role.ecs_task_execution_role.name
  ]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}