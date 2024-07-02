output "ecs_iam_role" {
  value = aws_iam_role.ecs_role.arn
}

output "lambda_iam_role" {
  value = aws_iam_role.lambda_role.arn
}
