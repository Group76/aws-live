resource "aws_sns_topic" "client_topic" {
  name = "client.fifo"
  fifo_topic = true
}