resource "aws_sns_topic" "order-topic" {
  name = "order.fifo"
  fifo_topic = true
}

resource "aws_sns_topic" "order-cancelled-topic" {
  name = "order-cancelled.fifo"
  fifo_topic = true
}