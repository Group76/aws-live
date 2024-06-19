resource "aws_sqs_queue" "client_queue" {
  name                      = "client-queue.fifo"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0
  visibility_timeout_seconds = 30
  fifo_queue = true
  content_based_deduplication = true
  deduplication_scope = "queue"
  fifo_throughput_limit = "perQueue"
}

resource "aws_sns_topic_subscription" "sns_subscription" {
  topic_arn = aws_sns_topic.client_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.client_queue.arn
}

resource "aws_sqs_queue_policy" "client_queue_policy" {
  queue_url = aws_sqs_queue.client_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.client_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.client_topic.arn
          }
        }
      }
    ]
  })
}