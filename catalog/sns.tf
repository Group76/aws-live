resource "aws_sns_topic" "product-topic" {
  name = "product-topic"
  fifo_topic = true
}