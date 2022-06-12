module "queue" {
  source = "./modules/sqs"

  name = "queue"
}

module "topic" {
  source = "./modules/sns"

  name = "topic"
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
      test = "ArnEquals"
      values = [
        module.topic.arn
      ]
      variable = "aws:SourceArn"
    }
  }
}

resource "aws_sqs_queue_policy" "sns_to_sqs_policy" {
  policy    = data.aws_iam_policy_document.sns_to_sqs_policy_document.json
  queue_url = module.queue.id
}

module "dynamodb" {
  source = "./modules/dynamodb"

  name          = "messages"
  hash_key_name = "MessageId"
}

module "lambda" {
  source = "./modules/lambda"

  name    = "lambda"
  src     = "./src/index.js"
  handler = "index.handler"
  runtime = "nodejs14.x"

  environment_variables = {
    tableName = module.dynamodb.tableName
  }
}

data "aws_iam_policy_document" "sqs_to_lambda_document" {
  statement {
    effect = "Allow"

    actions = [
      "SQS:ReceiveMessage",
      "SQS:DeleteMessage",
      "SQS:GetQueueAttributes"
    ]

    resources = [
      module.queue.arn
    ]
  }
}

resource "aws_iam_policy" "sqs_to_lambda_policy" {
  policy = data.aws_iam_policy_document.sqs_to_lambda_document.json
}

resource "aws_iam_role_policy_attachment" "sqs_to_lambda_role_policy_attachment" {
  policy_arn = aws_iam_policy.sqs_to_lambda_policy.arn
  role       = module.lambda.role_name
}

resource "aws_lambda_event_source_mapping" "sqs_to_lambda_mapping" {
  event_source_arn = module.queue.arn
  function_name    = module.lambda.arn
}

data "aws_iam_policy_document" "lambda_dynamodb_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:PutItem"
    ]

    resources = [
      module.dynamodb.arn
    ]
  }
}

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  policy = data.aws_iam_policy_document.lambda_dynamodb_policy_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy_attachment" {
  role       = module.lambda.role_name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}