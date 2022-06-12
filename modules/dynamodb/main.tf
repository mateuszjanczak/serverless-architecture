resource "aws_dynamodb_table" "dynamodb" {
  name         = var.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key_name

  attribute {
    name = var.hash_key_name
    type = var.hash_key_type
  }
}