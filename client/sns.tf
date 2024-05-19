resource "aws_sns_topic" "client" {
  name = "client"
  fifo_topic = true
}