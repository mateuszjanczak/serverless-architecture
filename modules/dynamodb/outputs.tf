output "arn" {
  value = aws_dynamodb_table.dynamodb.arn
}

output "tableName" {
  value = aws_dynamodb_table.dynamodb.name
}