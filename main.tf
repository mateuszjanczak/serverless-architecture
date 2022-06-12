module "queue" {
  source = "./modules/sqs"
  name   = "queue"
}

module "topic" {
  source = "./modules/sns"
  name   = "topic"
}

resource "aws_sns_topic_subscription" "sns_to_sqs_subscription" {
  endpoint  = module.queue.arn
  protocol  = "sqs"
  topic_arn = module.topic.arn
}

data "aws_iam_policy_document" "sns_to_sqs_policy_document" {
  statement {
    effect = "Allow"

    principals {
      identifiers = ["sns.amazonaws.com"]
      type        = "Service"
    }

    actions = [
      "SQS:SendMessage",
      "SQS:SendMessageBatch"
    ]

    resources = [
      module.queue.arn
    ]

    condition {
      test     = "ArnEquals"
      values   = [
        module.topic.arn
      ]
      variable = "aws:SourceArn"
    }
  }
}

resource "aws_sqs_queue_policy" "sns_to_sqs_policy" {
  policy = data.aws_iam_policy_document.sns_to_sqs_policy_document.json
  queue_url = module.queue.id
}