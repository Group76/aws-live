resource "aws_sns_topic" "order-topic" {
  name = "order.fifo"
  fifo_topic = true
}