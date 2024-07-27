resource "aws_sns_topic" "order-topic" {
  name = "order.fifo"
  fifo_topic = true
}

resource "aws_sns_topic" "order-client-notification-topic" {
  name = "order-client-notification.fifo"
  fifo_topic = true
}

resource "aws_sns_topic" "order-kitchen-notification-topic" {
  name = "order-kitchen-notification.fifo"
  fifo_topic = true
}