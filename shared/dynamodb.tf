resource "aws_dynamodb_table" "client_table" {
  name           = "Client"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "document"

  attribute {
    name = "document"
    type = "S"
  }
}