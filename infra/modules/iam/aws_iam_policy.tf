resource "aws_iam_policy" "ecr_policy" {
  name = "${var.app_name}_ecr_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
