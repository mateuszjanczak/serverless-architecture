output "sqs_arn" {
  value = module.queue.arn
}

output "sns_arn" {
  value = module.topic.arn
}