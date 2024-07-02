resource "aws_iam_policy_attachment" "ecr_attach" {
  name       = "${var.app_name}_ecr_attach"
  roles      = ["${aws_iam_role.main_role.name}"]
  policy_arn = aws_iam_policy.ecr_policy.arn
}

# IAMロールにポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
