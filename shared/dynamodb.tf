resource "aws_dynamodb_table" "client_table" {
  name           = "Client"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "guest_client" {
  table_name = aws_dynamodb_table.client_table.name
  hash_key   = aws_dynamodb_table.client_table.hash_key

  item = <<ITEM
{
  "id": {"S": "83f3ea51-dacc-430c-ac34-8d64907d9a7c"}
}
ITEM
}