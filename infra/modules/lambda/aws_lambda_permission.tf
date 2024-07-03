# Lambda Permissionの設定
resource "aws_lambda_permission" "allow_kinesis_invoke" {
  statement_id  = "AllowExecutionFromKinesis"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "kinesis.amazonaws.com"
  source_arn    = var.kinesis_stream_arn
}
