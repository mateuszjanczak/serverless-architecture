output "arn" {
  value = aws_lambda_function.lambda.arn
}

output "role_name" {
  value = aws_iam_role.iam_for_lambda.name
}