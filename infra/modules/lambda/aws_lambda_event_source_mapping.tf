resource "aws_lambda_event_source_mapping" "main" {
  event_source_arn  = var.kinesis_stream_arn
  function_name     = aws_lambda_function.main.arn
  starting_position = "LATEST"
}
