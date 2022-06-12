output "sqs_arn" {
  value = module.queue.arn
}

output "sns_arn" {
  value = module.topic.arn
}

output "dynamodb_arn" {
  value = module.dynamodb.arn
}

output "lambda_arn" {
  value = module.lambda.arn
}