resource "aws_sqs_queue" "order_queue" {
  name                      = "order-queue.fifo"
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

resource "aws_sqs_queue" "order_client_notification_queue" {
  name                      = "order-client-notification-queue.fifo"
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

resource "aws_sqs_queue" "order_kitchen_notification_queue" {
  name                      = "order-kitchen-notification-queue.fifo"
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
  topic_arn = aws_sns_topic.order-topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.order_queue.arn
}

resource "aws_sns_topic_subscription" "sns_client_notification_subscription" {
  topic_arn = aws_sns_topic.order-client-notification-topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.order_client_notification_queue.arn
}

resource "aws_sns_topic_subscription" "sns_kitchen_notification_subscription" {
  topic_arn = aws_sns_topic.order-kitchen-notification-topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.order_kitchen_notification_queue.arn
}

resource "aws_sqs_queue_policy" "order_queue_policy" {
  queue_url = aws_sqs_queue.order_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.order_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.order-topic.arn
          }
        }
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "order_client_queue_policy" {
  queue_url = aws_sqs_queue.order_client_notification_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.order_client_notification_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.order-client-notification-topic.arn
          }
        }
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "order-Kitchen_queue_policy" {
  queue_url = aws_sqs_queue.order_kitchen_notification_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.order_kitchen_notification_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.order-kitchen-notification-topic.arn
          }
        }
      }
    ]
  })
}