resource "aws_sns_topic" "product" {
  name = "product"
  fifo_topic = true
}