resource "aws_sns_topic" "client-topic" {
  name = "client.fifo"
  fifo_topic = true
}