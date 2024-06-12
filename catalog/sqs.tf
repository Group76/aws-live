resource "aws_sqs_queue" "product_queue" {
  name                      = "product-queue"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 0
  visibility_timeout_seconds = 30
}

resource "aws_sns_topic_subscription" "sns_subscription" {
  topic_arn = aws_sns_topic.product_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.product_queue.arn
}

resource "aws_sqs_queue_policy" "product_queue_policy" {
  queue_url = aws_sqs_queue.product_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.product_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.product_topic.arn
          }
        }
      }
    ]
  })
}