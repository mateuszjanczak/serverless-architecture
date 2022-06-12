data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_policy_document.json
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.src
  output_path = "${var.src}.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.name
  handler          = var.handler
  runtime          = var.runtime
  role             = aws_iam_role.iam_for_lambda.arn
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
}