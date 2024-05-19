resource "aws_sns_topic" "client-topic" {
  name = "client-topic"
  fifo_topic = true
}