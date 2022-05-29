resource "aws_sqs_queue" "sqs" {
  name = var.name
}