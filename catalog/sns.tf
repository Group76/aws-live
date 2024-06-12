resource "aws_sns_topic" "product_topic" {
  name = "product.fifo"
  fifo_topic = true
}